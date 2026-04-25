import 'package:flutter/material.dart';

class DonationCard extends StatelessWidget {
  final String organizer;
  final String title;
  final String buttonText;
  final String? buttonText2; // (opsional)

  const DonationCard({
    super.key,
    required this.organizer,
    required this.title,
    required this.buttonText,
    this.buttonText2,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              organizer,
              style: const TextStyle(
                fontSize: 14, 
                color: Colors.grey, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Placeholder Gambar (Kotak Abu-abu)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            
            // Barisan Tombol
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {}, // Belum ada aksi klik
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(buttonText),
                  ),
                ),
                // Jika tombol kedua ada, tampilkan di sebelahnya
                if (buttonText2 != null) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Belum ada aksi klik
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(buttonText2!),
                    ),
                  ),
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}