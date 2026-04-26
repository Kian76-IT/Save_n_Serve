import 'package:flutter/material.dart';
import 'package:save_n_serve/models/food_item.dart';
import 'package:save_n_serve/theme.dart';

class DonationCard extends StatelessWidget {
  final FoodItem food; // Mengambil data langsung dari model

  const DonationCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          // Bagian Atas: Gambar & Rating
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: Image.asset(food.imagePath, height: 180, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 12, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      Text(" ${food.rating}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Bagian Bawah: Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.name, style: AppTextStyle.regularPoppins12.copyWith(fontWeight: FontWeight.bold)),
                Text("${food.distance} • ${food.location}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("\$${food.discountedPrice} ", style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
                        Text("\$${food.originalPrice}", style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 14)),
                      ],
                    ),
                    CircleAvatar(
                      backgroundColor: primary,
                      radius: 18,
                      child: const Icon(Icons.add, color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}