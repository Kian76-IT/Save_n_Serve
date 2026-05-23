import 'package:flutter/material.dart';
import 'giver_chat_page.dart';
import 'package:save_n_serve/components/shared/food_image_slider.dart';
import 'package:save_n_serve/controllers/giver_activity_controller.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/pages/home/main_page_giver.dart';

class GiverActivityPage extends StatefulWidget {
  /// When [standaloneMode] is true (default) the widget renders its own
  /// BottomNavigationBar so it works as a full-screen push destination.
  /// Set to false when embedding inside MainPageGiver's tab list.
  final bool standaloneMode;
  const GiverActivityPage({super.key, this.standaloneMode = true});

  @override
  State<GiverActivityPage> createState() => _GiverActivityPageState();
}

class _GiverActivityPageState extends State<GiverActivityPage> {
  // 0 = Done, 1 = On Process (default)
  int _selectedTab = 1;

  @override
  void initState() {
    super.initState();
    giverActivityController.fetchMyFoods();
  }

  void _navigateHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainPageGiver()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Activity',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListenableBuilder(
        listenable: giverActivityController,
        builder: (context, _) {
          if (giverActivityController.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
          return RefreshIndicator(
            onRefresh: giverActivityController.fetchMyFoods,
            color: Colors.green,
            child: Center(
              child: Container(
                width: 390,
                color: Colors.white,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── TAB ROW ──
                        Row(
                          children: [
                            _buildTab('Done', 0),
                            const SizedBox(width: 16),
                            _buildTab('On Process', 1),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ── CONTENT ──
                        _selectedTab == 1
                            ? _buildOnProcessView()
                            : _buildDoneView(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: widget.standaloneMode
          ? BottomNavigationBar(
              currentIndex: 1,
              selectedItemColor: Colors.green,
              unselectedItemColor: Colors.grey,
              onTap: (index) {
                if (index == 0) _navigateHome(context);
              },
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.volunteer_activism_outlined),
                    activeIcon: Icon(Icons.volunteer_activism),
                    label: 'Donate'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.receipt_long),
                    label: 'Activity'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: 'Profile'),
              ],
            )
          : null,
    );
  }

  // ─── TAB WIDGET ───────────────────────────────────────────────
  Widget _buildTab(String label, int index) {
    final isActive = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: isActive ? label.length * 8.5 : 0,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  // ─── ON PROCESS VIEW ─────────────────────────────────────────
  Widget _buildOnProcessView() {
    final foods = giverActivityController.activeFoods;

    if (foods.isEmpty) {
      return _buildEmptyState(
        icon: Icons.volunteer_activism_outlined,
        message: 'Belum ada donasi aktif.\nTap tombol Donate untuk mulai!',
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${foods.length} Donasi Aktif',
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
        const SizedBox(height: 12),
        ...foods.map((food) => _buildActiveFoodCard(food)),
      ],
    );
  }

  // ─── DONE VIEW ───────────────────────────────────────────────
  Widget _buildDoneView() {
    final foods = giverActivityController.doneFoods;

    if (foods.isEmpty) {
      return _buildEmptyState(
        icon: Icons.history,
        message: 'Belum ada donasi yang selesai.',
      );
    }

    return Column(
      children: foods.map((food) => _buildDoneFoodCard(food)).toList(),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancelFood(BuildContext context, FoodItem food) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Batalkan Donasi?'),
        content: Text('Donasi "${food.name}" akan dibatalkan dan tidak bisa diklaim.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Ya, Batalkan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await giverActivityController.cancelFood(food.foodId);
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildActiveFoodCard(FoodItem food) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: FoodImageSlider(imageUrls: food.imageUrls, height: 140),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status badge + name row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Aktif',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${food.totalQuantity} ${food.portionUnit ?? 'porsi'}',
                      style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  food.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        food.location,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (food.expiryDate != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Kedaluwarsa: ${_formatExpiry(food.expiryDate!)}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                // Chat button
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GiverChatPage()),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.chat_outlined, size: 16, color: Color(0xFF4CAF50)),
                    label: const Text(
                      'Chat Penerima',
                      style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Cancel donation button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => _confirmCancelFood(context, food),
                    child: const Text(
                      'Batalkan Donasi',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoneFoodCard(FoodItem food) {
    final isCancelled = food.status == 'cancelled';
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: FoodImageSlider(imageUrls: food.imageUrls, height: 130),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCancelled
                            ? const Color(0xFFFFEBEE)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isCancelled ? 'Dibatalkan' : 'Selesai',
                        style: TextStyle(
                          color: isCancelled
                              ? Colors.red.shade700
                              : const Color(0xFF2E7D32),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  food.name,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        food.location,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                        overflow: TextOverflow.ellipsis,
                      ),
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

  String _formatExpiry(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.day}/${dt.month}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return isoDate;
    }
  }
}
