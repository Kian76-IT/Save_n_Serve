import 'dart:async';
import 'package:flutter/material.dart';
import '../components/home/giver_body.dart';
import '../components/home/beneficiary_body.dart';
import 'package:save_n_serve/controllers/food_controller.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentBanner = 0;
  String _selectedRole = 'Beneficiary';
  late PageController _bannerController;
  Timer? _bannerTimer;

  final List<_BannerData> _banners = const [
    _BannerData(imagePath: 'assets/images/Slide1.png'),
    _BannerData(imagePath: 'assets/images/Slide2.png'),
    _BannerData(imagePath: 'assets/images/Slide3.png'),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      final next = (_currentBanner + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
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
              _buildMovingBanner(),
              const SizedBox(height: 16),

              // SWITCHER LOGIC
              _selectedRole == 'Beneficiary'
                  ? const BeneficiaryBody()
                  : const GiverBody(),
            ],
          ),
        ),
      ),

      bottomNavigationBar: foodController.isWatchlistEmpty()
          ? null
          : Container(
              margin: const EdgeInsets.all(16),

              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),

              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(18),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  GestureDetector(
                    onTap: () {
                      MainPageBene.of(context)?.changeTab(1);
                    },

                    child: Row(
                      children: [
                        Text(
                          "View Watchlist",

                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          "${foodController.totalItems()} items",

                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Row(
                    children: [
                      Text(
                        "\$${foodController.totalPrice().toStringAsFixed(2)}",

                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Icon(Icons.shopping_bag, color: Colors.white),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  // ─────────────────────────────────────────────
  // WIDGET HELPERS
  // ─────────────────────────────────────────────

  Widget _buildMovingBanner() {
    return AspectRatio(
      aspectRatio: 412 / 234,
      child: Stack(
        children: [
          PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (context, index) =>
                _BannerSlide(banner: _banners[index]),
          ),
          Positioned(top: 12, left: 16, child: _buildRoleChip()),
          Positioned(top: 12, right: 16, child: _buildNotificationBell()),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _banners.length,
                (i) => _buildDotIndicator(i),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedRole,
          dropdownColor: Colors.black87,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white,
            size: 18,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRole = newValue!;
            });
          },
          items: ['Beneficiary', 'Giver'].map((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.notifications_none,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  Widget _buildDotIndicator(int i) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: i == _currentBanner ? 18 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: i == _currentBanner ? Colors.white : Colors.white38,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

// ── BANNER CLASSES ──
class _BannerData {
  final String imagePath;
  const _BannerData({required this.imagePath});
}

class _BannerSlide extends StatelessWidget {
  final _BannerData banner;
  const _BannerSlide({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Image.asset(banner.imagePath, fit: BoxFit.cover);
  }
}
