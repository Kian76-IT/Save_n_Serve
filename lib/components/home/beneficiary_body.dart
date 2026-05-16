import 'package:flutter/material.dart';
import '../../controllers/home_controller.dart';
import 'food_card.dart'; 

class BeneficiaryBody extends StatefulWidget {
  const BeneficiaryBody({super.key});

  @override
  State<BeneficiaryBody> createState() => _BeneficiaryBodyState();
}

class _BeneficiaryBodyState extends State<BeneficiaryBody> {
  // Menggunakan singleton — tidak membuat instance baru setiap rebuild
  final _controller = homeController;

  @override
  void initState() {
    super.initState();
    // Guard: hanya fetch jika data belum ada, agar tidak re-fetch saat ganti role
    if (_controller.foodList.isEmpty) {
      _controller.fetchFoods();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
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
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fitur pencarian dalam pengembangan')),
        ),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))
            ],
          ),
          child: const Row(
            children: [
              SizedBox(width: 20),
              Icon(Icons.search, color: Colors.grey, size: 22),
              SizedBox(width: 12),
              Text('Search sushi, rolls...', style: TextStyle(color: Colors.grey, fontSize: 15)),
            ],
          ),
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
        itemCount: _controller.categories.length,
        itemBuilder: (context, i) {
          final isSelected = i == _controller.selectedCategory;
          return GestureDetector(
            onTap: () => _controller.changeCategory(i),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                children: [
                  Container(
                    width: 55, height: 55,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE8F5E9) : const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(15),
                      border: isSelected ? Border.all(color: const Color(0xFF4CAF50), width: 2) : null,
                    ),
                    child: Center(
                      child: Image.asset(_controller.categoryEmojis[i], width: 30, height: 30),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _controller.categories[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
          const Text('Recommended', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fitur lihat semua dalam pengembangan')),
            ),
            child: Text('See All', style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList() {
    if (_controller.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator(color: Colors.green)),
      );
    }

    final filteredFoods = _controller.getFilteredFoods();

    if (filteredFoods.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text('No food items found.', style: TextStyle(color: Colors.grey))),
      );
    }

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