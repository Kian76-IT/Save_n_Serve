import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 21, left: 46, right: 46),
      child: Column(
        children: [
          _buildActivityCard(
            imageUrl: 'assets/images/activity1.png',
            title: "Burger King",
            location: 'Burger King Tanah Abang Square',
            statusDate: "Completed (12 Jan 2026)",
            time: '12 Min',
          ),

          SizedBox(height: 38),
          _buildActivityCard(
            imageUrl: 'assets/images/activity2.png',
            title: "Dim Sum Master ",
            location: 'Grand Indonesia',
            statusDate: "Completed (12 Jan 2026)",
            time: '12 Min',
          ),

          SizedBox(height: 38),
          _buildActivityCard(
            imageUrl: 'assets/images/activity3.png',
            title: "HokBen",
            location: 'Slipi',
            statusDate: "Completed (12 Jan 2026)",
            time: '-',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required String imageUrl,
    required String title,
    required String location,
    required String statusDate,
    required String time,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Stack(
        children: [
          Image.asset(
            imageUrl,
            width: double.infinity,
            height: 450,
            fit: BoxFit.cover,
          ),

          Container(
            height: 450,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star, color: Colors.grey, size: 20),
            ),
          ),

          Positioned(
            bottom: 25,
            left: 10,
            right: 25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyle.interSemibold32.copyWith(
                    color: background,
                    fontSize: 24,
                  ),
                ),
                Text(
                  location,
                  style: AppTextStyle.interRegular14.copyWith(
                    color: background.withValues(alpha: 0.9),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                _buildInfoRow(Icons.check_circle_outline, statusDate),
                _buildInfoRow(Icons.person_outline, 'Beneficiary'),
                _buildInfoRow(Icons.access_time, time),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, color: background, size: 14), // Ikon kecil putih
          const SizedBox(width: 6), // Jarak ikon ke teks
          Text(
            text,
            style: AppTextStyle.interRegular14.copyWith(
              color: background,
              fontSize: 12, // Teks detail lebih kecil
            ),
          ),
        ],
      ),
    );
  }
}
