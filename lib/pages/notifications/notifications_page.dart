import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants/api_constants.dart';
import '../../controllers/notification_controller.dart';
import '../../services/session_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _notifications = [];

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final response = await http
          .get(
            Uri.parse('${ApiConstants.baseUrl}/notifications?limit=50'),
            headers: {'Authorization': 'Bearer ${SessionService.token}'},
          )
          .timeout(const Duration(seconds: 8));
      if (response.statusCode == 200 && mounted) {
        final body = jsonDecode(response.body);
        final list = (body['notifications'] as List<dynamic>)
            .whereType<Map<String, dynamic>>()
            .toList();
        setState(() {
          _notifications = list;
          _isLoading = false;
        });
        notificationController.setUnread(
          list.where((n) => n['is_read'] == false).length,
        );
      }
    } catch (_) {}
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _markAllRead() async {
    try {
      await http.patch(
        Uri.parse('${ApiConstants.baseUrl}/notifications/read-all'),
        headers: {'Authorization': 'Bearer ${SessionService.token}'},
      );
    } catch (_) {}
    if (!mounted) return;
    setState(() {
      for (final n in _notifications) {
        n['is_read'] = true;
      }
    });
    notificationController.setUnread(0);
  }

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => n['is_read'] == false).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(color: Color(0xFF4CAF50), fontSize: 13),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 72,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No notifications yet',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchNotifications,
                  child: ListView.separated(
                    itemCount: _notifications.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, i) {
                      final n = _notifications[i];
                      final isRead = n['is_read'] == true;
                      return ListTile(
                        tileColor:
                            isRead ? Colors.white : const Color(0xFFF1F8F1),
                        leading: CircleAvatar(
                          backgroundColor:
                              _typeColor(n['type'] as String?)
                                  .withValues(alpha: 0.12),
                          child: Icon(
                            _typeIcon(n['type'] as String?),
                            color: _typeColor(n['type'] as String?),
                            size: 20,
                          ),
                        ),
                        title: Text(
                          n['title'] ?? '',
                          style: TextStyle(
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              n['body'] ?? '',
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatAge(n['created_at']),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        trailing: isRead
                            ? null
                            : Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4CAF50),
                                  shape: BoxShape.circle,
                                ),
                              ),
                      );
                    },
                  ),
                ),
    );
  }

  Color _typeColor(String? type) {
    switch (type) {
      case 'claim':
        return Colors.blue;
      case 'grab':
        return const Color(0xFF4CAF50);
      case 'cancel':
        return Colors.orange;
      case 'report':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _typeIcon(String? type) {
    switch (type) {
      case 'claim':
        return Icons.shopping_bag_outlined;
      case 'grab':
        return Icons.check_circle_outline;
      case 'cancel':
        return Icons.cancel_outlined;
      case 'report':
        return Icons.flag_outlined;
      default:
        return Icons.notifications_none;
    }
  }

  String _formatAge(dynamic raw) {
    if (raw == null) return '';
    try {
      final dt = DateTime.parse(raw.toString()).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}
