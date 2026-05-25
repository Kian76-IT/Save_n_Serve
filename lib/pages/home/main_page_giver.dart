import 'dart:async';
import 'package:flutter/material.dart';
import 'package:save_n_serve/components/home/giver_body.dart';
import 'package:save_n_serve/controllers/notification_controller.dart';
import 'package:save_n_serve/pages/activity/giver_activity_page.dart';
import 'package:save_n_serve/pages/notifications/notifications_page.dart';
import 'package:save_n_serve/pages/profile/profile.dart';
import 'package:save_n_serve/theme.dart';

class MainPageGiver extends StatefulWidget {
  final int initialIndex;
  const MainPageGiver({super.key, this.initialIndex = 0});

  static MainPageGiverState? of(BuildContext context) =>
      context.findAncestorStateOfType<MainPageGiverState>();

  @override
  State<MainPageGiver> createState() => MainPageGiverState();
}

class MainPageGiverState extends State<MainPageGiver> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void changeTab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _GiverHomeTab(),
      const GiverActivityPage(standaloneMode: false),
      const ProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism_outlined),
            activeIcon: Icon(Icons.volunteer_activism),
            label: 'Donate',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Giver's Home Tab — banner identical to receiver's HomeTab, body is GiverBody
// ─────────────────────────────────────────────────────────────────────────────
class _GiverHomeTab extends StatefulWidget {
  const _GiverHomeTab();

  @override
  State<_GiverHomeTab> createState() => _GiverHomeTabState();
}

class _GiverHomeTabState extends State<_GiverHomeTab> {
  int _currentBanner = 0;
  late PageController _bannerController;
  Timer? _bannerTimer;

  static const _bannerImages = [
    'assets/images/Slide1.png',
    'assets/images/Slide2.png',
    'assets/images/Slide3.png',
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _bannerImages.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
    notificationController.fetchUnreadCount();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBanner(),
              const SizedBox(height: 16),
              const GiverBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return AspectRatio(
      aspectRatio: 412 / 234,
      child: Stack(
        children: [
          // Sliding images
          PageView.builder(
            controller: _bannerController,
            itemCount: _bannerImages.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (_, i) =>
                Image.asset(_bannerImages[i], fit: BoxFit.cover),
          ),

          // Role chip — static, non-interactive (Giver is enforced by session)
          Positioned(
            top: 12,
            left: 16,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.volunteer_activism,
                      color: Colors.white, size: 13),
                  SizedBox(width: 5),
                  Text(
                    'Giver',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Notification bell
          Positioned(
            top: 12,
            right: 16,
            child: ListenableBuilder(
              listenable: notificationController,
              builder: (context, _) {
                final count = notificationController.unreadCount;
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NotificationsPage()),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_none,
                            color: Colors.white, size: 20),
                      ),
                      if (count > 0)
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              count > 99 ? '99+' : '$count',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Dot indicators
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerImages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentBanner ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentBanner
                        ? Colors.white
                        : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
