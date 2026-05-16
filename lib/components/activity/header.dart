import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class Header extends StatelessWidget {
  final int selectedTab; // 0 = Done, 1 = On Process
  final ValueChanged<int> onTabChanged;

  const Header({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 14),
          child: Text(
            'Activity',
            style: AppTextStyle.interSemibold32.copyWith(
              color: Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(thickness: 3, color: Color(0xfff2e7d32)),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            children: [
              _buildTab("Done", 0, 55),
              const SizedBox(width: 18),
              _buildTab("On Process", 1, 102),
            ],
          ),
        ),
        const SizedBox(height: 21),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Filter role dalam pengembangan')),
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    color: background,
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Beneficiary',
                        style: AppTextStyle.interRegular14.copyWith(
                          color: primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String label, int index, double underlineWidth) {
    final isActive = selectedTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyle.interMedium20.copyWith(
              fontSize: 25,
              color: isActive ? text : Colors.grey,
            ),
          ),
          const SizedBox(height: 0),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 2,
            width: isActive ? underlineWidth : 0,
            color: primary,
          ),
        ],
      ),
    );
  }
}
