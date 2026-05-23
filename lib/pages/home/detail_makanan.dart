import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:save_n_serve/components/shared/food_image_slider.dart';
import 'package:save_n_serve/constants/api_constants.dart';
import 'package:save_n_serve/controllers/claim_controller.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';
import 'package:save_n_serve/services/session_service.dart';

class DetailMakananPage extends StatelessWidget {
  final FoodItem food;

  const DetailMakananPage({
    super.key,
    required this.food,
  });

  /// True only when the item is still available AND has not yet expired.
  /// Parses the ISO-8601 expiry string as local time so UTC offsets don't
  /// incorrectly mark a valid item as expired on the device.
  /// Parses an ISO-8601 timestamp as UTC, appending 'Z' when no timezone
  /// marker is present (defence-in-depth alongside FoodItem._toUtcString).
  DateTime _parseUtc(String isoDate) {
    final s = isoDate.trim();
    final hasZone = s.endsWith('Z') ||
        s.contains('+') ||
        (s.length > 19 && s[19] == '-');
    return DateTime.parse(hasZone ? s : '${s}Z');
  }

  String _formatTimeHHmm(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatExpiry(String isoDate) {
    try {
      final dt = _parseUtc(isoDate).toLocal();
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}  '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }

  void _showReportDialog(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    final nav = Navigator.of(context);

    // Maps display label → backend enum value required by createReportValidator.
    const reasons = [
      ('Spam / Penipuan', 'spam'),
      ('Makanan tidak sesuai deskripsi', 'fake_food'),
      ('Pemberi tidak hadir saat pengambilan', 'no_show'),
      ('Konten tidak pantas', 'inappropriate_content'),
      ('Lainnya', 'other'),
    ];

    // descriptionController is NOT disposed via .then() — .then() fires as a
    // microtask before the dismiss animation ends, causing the TextField to
    // access a disposed controller mid-animation ("_dependents.isEmpty" crash).
    // The controller is released by GC when the dialog widget tree is torn down.
    final descriptionController = TextEditingController();
    String? selectedReason; // starts null → "Kirim" disabled until user picks

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        // StatefulBuilder is safe here: setDialogState is only called
        // synchronously in onChanged — never across an async gap.
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Laporkan Pelanggaran'),
          contentPadding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RadioGroup<String>(
                    groupValue: selectedReason,
                    onChanged: (v) => setDialogState(() => selectedReason = v),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: reasons.map(
                        (r) => RadioListTile<String>(
                          dense: true,
                          title: Text(r.$1, style: const TextStyle(fontSize: 14)),
                          value: r.$2,
                        ),
                      ).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      maxLength: 1000,
                      decoration: const InputDecoration(
                        hintText: 'Catatan tambahan (opsional)...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => nav.pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              // Disabled until the user picks a reason.
              onPressed: selectedReason == null
                  ? null
                  : () {
                      // 1. Capture both values BEFORE pop — controllers may be
                      //    accessed by the framework during the dismiss animation.
                      final reason = selectedReason!;
                      final description = descriptionController.text.trim();
                      // 2. Close dialog synchronously.
                      nav.pop();
                      // 3. Fire background call with plain Strings — no widget refs.
                      _submitReport(messenger, reason, description);
                    },
              child: const Text('Kirim', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitReport(
    ScaffoldMessengerState messenger,
    String reason,
    String description,
  ) async {
    try {
      final token = SessionService.token;
      final reportedId = food.giverId;
      if (token == null) {
        throw Exception('Sesi tidak ditemukan, silakan login ulang');
      }
      if (reportedId == null || reportedId.isEmpty) {
        throw Exception('Data pemberi tidak tersedia untuk item ini');
      }
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/reports'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'reported_id': reportedId,
          'reason': reason,
          if (description.isNotEmpty) 'description': description,
        }),
      );
      if (!messenger.mounted) return;
      if (response.statusCode == 201) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Terimakasih sudah mengunggah keresahannya.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        String msg = 'Gagal mengirim laporan';
        try {
          final body = jsonDecode(response.body);
          if (body is Map) msg = body['message']?.toString() ?? msg;
        } catch (_) {}
        messenger.showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!messenger.mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final expiryUtc = food.expiryDate != null
        ? DateTime.parse(food.expiryDate!.contains('Z') ? food.expiryDate! : '${food.expiryDate}Z')
        : null;
    final bool claimable = expiryUtc != null &&
        DateTime.now().toUtc().isBefore(expiryUtc) &&
        food.status?.trim().toLowerCase() == 'available';
    print('🚨 DEBUG DETAILS: status="${food.status}", expiry="${food.expiryDate}", expiryUtc=$expiryUtc, nowUtc=${DateTime.now().toUtc()}, isClaimable=$claimable');
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        title: const Text(
          'Donations Details',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.flag_outlined, color: Colors.black),
            tooltip: 'Laporkan',
            onPressed: () => _showReportDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur bagikan dalam pengembangan')),
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            FoodImageSlider(imageUrls: food.imageUrls, height: 250),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // TITLE + PRICE
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        backgroundImage: food.imageUrls.isNotEmpty
                            ? NetworkImage(food.imageUrls.first) as ImageProvider
                            : AssetImage(food.imagePath),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              food.name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Gratis',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),

                            const SizedBox(height: 6),

                            if (food.giverName != null)
                              Text(
                                'Donated by ${food.giverName}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // PICKUP WINDOW
                  // Note: the DB stores one time field — expiry_date — which
                  // equals the END of the giver's pickup window. The start
                  // time entered on the donation form is not persisted.
                  const Text(
                    'Pickup Window',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),
                  if (food.expiryDate != null) ...[
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 16, color: Colors.grey),
                        const SizedBox(width: 6),
                        Text(
                          food.pickupStart != null
                              ? 'Pickup available: ${_formatTimeHHmm(food.pickupStart!)} – '
                                '${_formatTimeHHmm(_parseUtc(food.expiryDate!).toLocal())}'
                              : 'Pickup closes at: ${_formatExpiry(food.expiryDate!)}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      claimable
                          ? 'Pickup window is still open — claim now!'
                          : 'Pickup window has closed',
                      style: TextStyle(
                        color: claimable ? const Color(0xFF2E7D32) : Colors.redAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else
                    const Text(
                      'No pickup time set',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // LOCATION — sebelumnya arrow mati, sekarang ada SnackBar
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur peta dalam pengembangan')),
                    ),
                    child: Row(
                      children: [

                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFFEAEAEA),
                          child: Icon(Icons.location_on, color: Colors.black54),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                food.giverName ?? food.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                food.location,
                                style: const TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.arrow_forward_ios, size: 18),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // DESCRIPTION
                  const Text(
                    'What you need to know',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 12),
                  Text(
                    food.description?.isNotEmpty == true
                        ? food.description!
                        : 'Tidak ada deskripsi tersedia.',
                    style: const TextStyle(height: 1.6, fontSize: 14),
                  ),

                  const SizedBox(height: 40),

                  // CLAIM BUTTON — only rendered when item is still claimable
                  if (claimable)
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            final ok = await claimController.claimItem(food);
                            if (ok && context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const MainPageBene(
                                    initialIndex: 2,
                                    activityInitialTab: 0,
                                  ),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            if (!context.mounted) return;
                            final msg = e
                                .toString()
                                .replaceFirst('Exception: ', '');
                            // Stale in-memory state: claim already exists on
                            // the server but was lost after restart. Sync and
                            // redirect to On Process instead of showing error.
                            if (msg.contains('already have an active claim')) {
                              claimController.loadClaims();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (_) => const MainPageBene(
                                    initialIndex: 2,
                                    activityInitialTab: 0,
                                  ),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(msg),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Claim Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Center(
                        child: Text(
                          food.status?.trim().toLowerCase() == 'available'
                              ? 'Pickup window has closed'
                              : 'This donation is no longer available',
                          style: TextStyle(
                            color: Colors.red.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
