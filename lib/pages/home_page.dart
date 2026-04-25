import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const KitabisaApp());
}

class KitabisaApp extends StatelessWidget {
  const KitabisaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kitabisa - BisaMakan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
      ),
      home: const MainPageBene(),
    );
  }
}

// ─────────────────────────────────────────────
// DATA MODELS
// ─────────────────────────────────────────────

class FoodItem {
  final String name;
  final String location;
  final double rating;
  final double originalPrice;
  final double discountedPrice;
  final double distance;
  final Color imageColor; // placeholder colour
  final String imagePath;

  const FoodItem({
    required this.name,
    required this.location,
    required this.rating,
    required this.originalPrice,
    required this.discountedPrice,
    required this.distance,
    required this.imageColor,
    required this.imagePath,
  });
}

const List<FoodItem> recommendedItems = [
  FoodItem(
    name: 'Burger King',
    location: 'Tanah Abang Square',
    rating: 4.8,
    originalPrice: 3.99,
    discountedPrice: 1.67,
    distance: 0.5,
    imageColor: Color(0xFFD4A373),
    imagePath: 'assets/images/GambarProduk1.png',
  ),
  FoodItem(
    name: 'Sushi Rolls',
    location: 'Grand Indonesia',
    rating: 4.9,
    originalPrice: 5.50,
    discountedPrice: 2.20,
    distance: 1.2,
    imageColor: Color(0xFFE07A5F),
    imagePath: 'assets/images/GambarProduk2.png',
  ),
  FoodItem(
    name: 'Fresh Beverages',
    location: 'SCBD Food Court',
    rating: 4.7,
    originalPrice: 2.50,
    discountedPrice: 1.00,
    distance: 0.8,
    imageColor: Color(0xFF81B29A),
    imagePath: 'assets/images/GambarProduk3.png',
  ),
];

// ─────────────────────────────────────────────
// MAIN PAGE
// ─────────────────────────────────────────────

class MainPageBene extends StatefulWidget {
  const MainPageBene({super.key});

  @override
  State<MainPageBene> createState() => _MainPageBeneState();
}

class _MainPageBeneState extends State<MainPageBene> {
  int _selectedNav = 0;
  int _selectedCategory = 0;
  int _currentBanner = 0;
  late PageController _bannerController;
  Timer? _bannerTimer;

final List<_BannerData> _banners = const [
    // Ini iklan pertamamu yang tadi udah di-setup di folder assets
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
                    // ── Moving Banner ──
                    _buildMovingBanner(),

                    const SizedBox(height: 16),

                    // ── Search Bar ──
                    _buildSearchBar(),

                    const SizedBox(height: 20),

                    // ── Category Tabs ──
                    _buildCategoryTabs(),

                    const SizedBox(height: 20),

                    // ── Recommended Section ──
                    _buildRecommendedHeader(),

                    const SizedBox(height: 12),

                    // ── Food Cards ──
                    ...recommendedItems.map((item) => _buildFoodCard(item)),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // ── Bottom Navigation ──
            _buildBottomNav(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // MOVING BANNER
  // ─────────────────────────────────────────────

  Widget _buildMovingBanner() {
    return AspectRatio(
      aspectRatio: 412 / 234,
      child: Stack(
        children: [
          // PageView
          PageView.builder(
            controller: _bannerController,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return _BannerSlide(banner: banner);
            },
          ),

          // Role chip – top left
          Positioned(
            top: 12,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Role Selected:',
                    style: TextStyle(color: Colors.white70, fontSize: 10),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Beneficiary',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                ],
              ),
            ),
          ),

          // Notification bell – top right
          Positioned(
            top: 12,
            right: 16,
            child: Stack(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF5252),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Dot indicators – bottom center
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_banners.length, (i) {
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
              }),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // SEARCH BAR
  // ─────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.search, color: Color(0xFF9E9E9E), size: 22),
            const SizedBox(width: 10),
            Text(
              'Search sushi, rolls, sashimi...',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CATEGORY TABS
  // ─────────────────────────────────────────────

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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(14),
                      border: selected
                          ? Border.all(color: const Color(0xFF4CAF50), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Image.asset(
                        _categoryEmojis[i],
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _categories[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF757575),
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // RECOMMENDED HEADER
  // ─────────────────────────────────────────────

  Widget _buildRecommendedHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF212121),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Text(
              'All',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FOOD CARD
  // ─────────────────────────────────────────────

  Widget _buildFoodCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image area
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  item.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  ),
                ),
              // Rating badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF212121).withOpacity(0.85),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
                      const SizedBox(width: 3),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Plus button
              Positioned(
                bottom: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),

          // Info row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Name & Location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),

                // Distance + Price
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place_outlined, size: 12, color: Color(0xFF9E9E9E)),
                        const SizedBox(width: 2),
                        Text(
                          '${item.distance}km',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF9E9E9E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '\$${item.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF5252),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Color(0xFFFF5252),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '\$${item.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF212121),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BOTTOM NAVIGATION
  // ─────────────────────────────────────────────

  Widget _buildBottomNav() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.bookmark_border_rounded, 'label': 'Watchlist'},
      {'icon': Icons.bar_chart_rounded, 'label': 'Activity'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final selected = i == _selectedNav;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedNav = i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    items[i]['icon'] as IconData,
                    size: 24,
                    color: selected
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFFBDBDBD),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    items[i]['label'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFFBDBDBD),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BANNER DATA & SLIDE WIDGET
// ─────────────────────────────────────────────

class _BannerData {
  final String imagePath; // Sekarang kita cuma butuh jalur gambar

  const _BannerData({
    required this.imagePath,
  });
}

class _BannerSlide extends StatelessWidget {
  final _BannerData banner;

  const _BannerSlide({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      banner.imagePath,
      fit: BoxFit.cover,
    );
  }
}