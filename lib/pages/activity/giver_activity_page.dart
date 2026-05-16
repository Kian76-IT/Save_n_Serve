import 'dart:async';
import 'package:flutter/material.dart';
import 'giver_chat_page.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';

class GiverActivityPage extends StatefulWidget {
  const GiverActivityPage({super.key});

  @override
  State<GiverActivityPage> createState() => _GiverActivityPageState();
}

class _GiverActivityPageState extends State<GiverActivityPage> {
  static const _initialSeconds = 20 * 60; // 20 menit pickup window
  int _remainingSeconds = _initialSeconds;
  Timer? _countdownTimer;

  // 0 = Done, 1 = On Process (default — sedang berlangsung)
  int _selectedTab = 1;

  // True setelah user konfirmasi "Selesaikan Donasi"
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _countdownTimer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  String get _timerText {
    final m = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final s = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _navigateHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainPageBene()),
      (route) => false,
    );
  }

  // Dialog konfirmasi sebelum pindah status → Done
  void _confirmComplete() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Apakah pickup sudah selesai dilakukan oleh Beneficiary?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Belum'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Ya, Selesai',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && mounted) {
        setState(() {
          _isCompleted = true;
          _selectedTab = 0;
          _countdownTimer?.cancel();
        });
      }
    });
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

      body: Center(
        child: Container(
          width: 390,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── TAB ROW (interactive) ──
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

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,

        onTap: (index) {
          if (index == 0) _navigateHome(context);
          if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Watchlist page belum dibuat')),
            );
          }
          if (index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile page belum dibuat')),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Watchlist'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // MAP IMAGE
        Container(
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade300,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/activity1.png',
              fit: BoxFit.cover,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ROLE BADGE
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Role : ', style: TextStyle(color: Colors.black54)),
            const Text(
              'Giver',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 16),

        const Text(
          'Pick Up Location :',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 8),

        const Text(
          'KFC, Jl. Pajajaran No.65',
          style: TextStyle(color: Colors.black54),
        ),

        const SizedBox(height: 8),

        const Text(
          'Pick Up Time remaining',
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
        ),

        const SizedBox(height: 32),

        // COUNTDOWN TIMER
        Center(
          child: Text(
            _timerText,
            style: TextStyle(
              fontSize: 48,
              color: _remainingSeconds > 0 ? Colors.orange : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 40),

        // ACTION BUTTONS — Call & Chat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            // CALL (sebelumnya mati — sekarang hidup)
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur panggilan dalam pengembangan'),
                ),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green.withOpacity(0.15),
                child: const Icon(Icons.call, color: Colors.green),
              ),
            ),

            // CHAT
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GiverChatPage()),
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.green.withOpacity(0.15),
                child: const Icon(Icons.chat, color: Colors.green),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // SELESAIKAN DONASI — tombol untuk memindahkan status ke Done
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _confirmComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Selesaikan Donasi',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }

  // ─── DONE VIEW ───────────────────────────────────────────────
  Widget _buildDoneView() {
    if (!_isCompleted) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60),
          child: Column(
            children: [
              Icon(Icons.history, size: 64, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                'Belum ada donasi yang selesai.',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }

    // Tampilkan ringkasan donasi yang telah selesai
    return Column(
      children: [
        const SizedBox(height: 30),
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, size: 64, color: Colors.green),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Donasi Berhasil!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        const Text(
          'KFC, Jl. Pajajaran No.65',
          style: TextStyle(color: Colors.black54, fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        const Text(
          'Pickup berhasil diselesaikan — Terima kasih atas kebaikanmu!',
          style: TextStyle(color: Colors.grey, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
