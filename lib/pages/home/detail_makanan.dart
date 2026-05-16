import 'package:flutter/material.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/controllers/claim_controller.dart';
import 'package:save_n_serve/pages/home/home_tab.dart';

class DetailMakananPage extends StatelessWidget {
  final FoodItem food;

  const DetailMakananPage({
    super.key,
    required this.food,
  });

  void _showReportDialog(BuildContext context) {
    final reportController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Laporkan Pelanggaran'),
        content: TextField(
          controller: reportController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Input alasan report...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Laporan Anda telah dikirim dan akan ditinjau oleh sistem.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Kirim',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    ).then((_) => reportController.dispose());
  }

  @override
  Widget build(BuildContext context) {
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
            Image.asset(
              food.imagePath,
              width: double.infinity,
              height: 240,
              fit: BoxFit.cover,
            ),

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
                        backgroundImage: AssetImage(food.imagePath),
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

                            const Text(
                              'Updated 17 minutes ago',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Divider(),

                  // EXPIRE
                  const Text(
                    'When does this expire?',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),

                  const SizedBox(height: 10),
                  const Text('Best before date: 12 Jan 2028', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Expired date: 12 April 2028', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text(
                    'This deal expires on Save n Serve Tomorrow',
                    style: TextStyle(color: Colors.redAccent, fontSize: 13),
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
                                food.name,
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
                  const Text(
                    '1. Add this item to your watchlist so you can easily check its availability before heading to the store.',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2. Check the opening hours before you go.',
                    style: TextStyle(height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '3. Find the item in-store and buy it at the till as usual.',
                    style: TextStyle(height: 1.6),
                  ),

                  const SizedBox(height: 40),

                  // CLAIM NOW BUTTON
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
                      onPressed: () {
                        claimController.claimItem(food);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const MainPageBene(initialIndex: 2),
                          ),
                          (route) => false,
                        );
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
