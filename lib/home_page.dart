import 'dart:async';
import 'package:flutter/material.dart';
import 'models/food_item.dart'; 
import 'components/home/food_card.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _selectedCategory = 0; 
  int _currentBanner = 0;
  late PageController _bannerController;
  Timer? _bannerTimer;

  final List<_BannerData> _banners = const [
    _BannerData(imagePath: 'assets/images/Slide1.png'),
    _BannerData(imagePath: 'assets/images/Slide2.png'),
    _BannerData(imagePath: 'assets/images/Slide3.png'),
  ];

  final List<String> _categories = ['All', 'Heavy Meals', 'Beverages', 'Vegetables'];
  final List<String> _categoryEmojis = [
    'assets/images/CategoryAll.png',
    'assets/images/CategoryHeavy.png',
    'assets/images/CategoryBeverages.png',
    'assets/images/CategoryVegetables.png'
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMovingBanner(),
                    const SizedBox(height: 16),
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    _buildCategoryTabs(),
                    const SizedBox(height: 20),
                    _buildRecommendedHeader(),
                    const SizedBox(height: 12),

                    // Mapping Food Cards yang sudah dibenerin:
                    ...recommendedItems.where((item) {
                      // Pakai _selectedCategory (tanpa Index)
                      final selectedCategoryName = _categories[_selectedCategory];
                      return selectedCategoryName == 'All' || item.category == selectedCategoryName;
                    }).map((item) => FoodCard(item: item)),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // WIDGET HELPER (Banner, Search, Tabs, Header)
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
            itemBuilder: (context, index) => _BannerSlide(banner: _banners[index]),
          ),
          // Role chip & Bell (tetap seperti kode kamu sebelumnya)
          Positioned(
            top: 12, left: 16,
            child: _buildRoleChip(),
          ),
          Positioned(
            top: 12, right: 16,
            child: _buildNotificationBell(),
          ),
          // Indicators
          Positioned(
            bottom: 12, left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_banners.length, (i) => _buildDotIndicator(i)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white30),
      ),
      child: const Row(
        children: [
          Icon(Icons.person, size: 14, color: Colors.white),
          SizedBox(width: 6),
          Text('Role Selected: Beneficiary', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildNotificationBell() {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
      child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: const Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: Colors.grey, size: 22),
            SizedBox(width: 10),
            Text('Search sushi, rolls...', style: TextStyle(color: Colors.grey, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final selected = i == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              width: 76,
              margin: const EdgeInsets.only(right: 8),
              child: Column(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                      border: selected ? Border.all(color: const Color(0xFF4CAF50), width: 2) : null,
                    ),
                    child: Center(child: Image.asset(_categoryEmojis[i], width: 28, height: 28)),
                  ),
                  const SizedBox(height: 6),
                  Text(_categories[i], style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Recommended', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('All', style: TextStyle(color: Colors.green[600], fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ── BANNER MODELS ──
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