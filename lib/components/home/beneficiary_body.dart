import 'package:flutter/material.dart';
import '../../models/food_item.dart'; // Pastikan path ini bener ke model lo
import 'food_card.dart';

class BeneficiaryBody extends StatefulWidget {
  const BeneficiaryBody({super.key});

  @override
  State<BeneficiaryBody> createState() => _BeneficiaryBodyState();
}

class _BeneficiaryBodyState extends State<BeneficiaryBody> {
  // 1. PINDAHKAN STATE KATEGORI KE SINI
  int _selectedCategory = 0;

  final List<String> _categories = [
    'All',
    'Heavy Meals',
    'Beverages',
    'Vegetables',
  ];
  final List<String> _categoryEmojis = [
    'assets/images/CategoryAll.png',
    'assets/images/CategoryHeavy.png',
    'assets/images/CategoryBeverages.png',
    'assets/images/CategoryVegetables.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchBar(),
        const SizedBox(height: 24),
        _buildCategoryTabs(),
        const SizedBox(height: 24),
        _buildRecommendedHeader(),
        _buildFoodList(),
      ],
    );
  }

  // --- WIDGET HELPER IMPLEMENTATION ---

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: [
            SizedBox(width: 20),
            Icon(Icons.search, color: Colors.grey, size: 22),
            SizedBox(width: 12),
            Text(
              'Search sushi, rolls...',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final isSelected = i == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = i),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFFE8F5E9)
                          : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                      border: isSelected
                          ? Border.all(color: const Color(0xFF4CAF50), width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Image.asset(
                        _categoryEmojis[i],
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _categories[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recommended',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            'See All',
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    // FILTER LOGIC: Ambil data dari recommendedItems (file model)
    final filteredFoods = recommendedItems.where((food) {
      if (_selectedCategory == 0) return true; // 'All'
      return food.category == _categories[_selectedCategory];
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredFoods.length,
      itemBuilder: (context, index) {
        return FoodCard(item: filteredFoods[index]);
      },
    );
  }
}
