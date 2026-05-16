import 'package:flutter/material.dart';
import 'package:save_n_serve/components/activity/header.dart';
import 'package:save_n_serve/controllers/claim_controller.dart';
import 'package:save_n_serve/theme.dart';
import 'package:save_n_serve/components/empty/empty_state.dart';

class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  // 0 = Done, 1 = On Process
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        top: false,
        child: ListenableBuilder(
          listenable: claimController,
          builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                selectedTab: _selectedTab,
                onTabChanged: (index) => setState(() => _selectedTab = index),
              ),
              Expanded(
                child: _selectedTab == 0
                    ? _buildDoneTab()
                    : _buildOnProcessTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Tab "Done" ───────────────────────────────────────────────
  Widget _buildDoneTab() {
    final items = claimController.done;
    if (items.isEmpty) {
      return const EmptyState(
        imagePath: 'assets/images/whoopies2.png',
        title: 'Belum Ada Riwayat',
        subtitle: 'Belum ada riwayat pengambilan. Claim makanan pertamamu sekarang!',
        buttonColor: Color(0xFF2A6B35),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildDoneCard(items[i]),
    );
  }

  Widget _buildDoneCard(ClaimedItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── FOOD IMAGE ──────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(
                  item.food.imagePath,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.white, size: 15),
                      SizedBox(width: 5),
                      Text(
                        'Berhasil Diambil',
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
              Positioned(
                top: 14,
                right: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        item.food.rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ── DETAIL SECTION ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      item.food.location,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const Spacer(),
                    Text(
                      '${item.food.distance} km',
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Gratis',
                    style: TextStyle(
                      color: Color(0xFF2E7D32),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FFF4),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.verified, color: Color(0xFF4CAF50), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Pengambilan Selesai — Terima kasih!',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tab "On Process" ─────────────────────────────────────────
  Widget _buildOnProcessTab() {
    final items = claimController.onProcess;
    if (items.isEmpty) {
      return const EmptyState(
        imagePath: 'assets/images/whoopies2.png',
        title: 'Belum Ada!',
        subtitle: 'Kamu belum memiliki donasi yang sedang diproses saat ini.',
        buttonColor: Color(0xFF2A6B35),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: items.length,
      itemBuilder: (context, i) => _buildClaimCard(items[i]),
    );
  }

  Widget _buildClaimCard(ClaimedItem item) {
    final timeExpired = item.remainingSeconds == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.asset(
              item.food.imagePath,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.food.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item.food.location,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),

                const SizedBox(height: 16),

                // Countdown
                Center(
                  child: Text(
                    item.timerText,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: timeExpired ? Colors.red : const Color(0xFF4CAF50),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Center(
                  child: Text(
                    'Waktu pengambilan tersisa',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),

                const SizedBox(height: 16),

                // Instruction panel — replaces the complete button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.5),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange, size: 20),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Tunjukkan layar ini kepada Pemberi/Kasir saat melakukan pembayaran di lokasi.',
                          style: TextStyle(
                            color: Color(0xFF795548),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
