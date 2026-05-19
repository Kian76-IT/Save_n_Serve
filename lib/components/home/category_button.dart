import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class CategoryButton extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    super.key,
    required this.title,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? primary.withValues(alpha: 0.1) : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Image.asset(iconPath, width: 30, height: 30),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyle.regularPoppins12.copyWith(
              color: isSelected ? primary : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
