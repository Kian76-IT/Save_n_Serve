import 'package:flutter/material.dart';
import 'package:save_n_serve/theme.dart';

class Header extends StatelessWidget {
  const Header({super.key});

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
        const Divider(thickness: 3, color: Color(0xFFF2E7D32)),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          child: Row(
            children: [
              Column(
                children: [
                  Text(
                    "Done",
                    style: AppTextStyle.interMedium20.copyWith(
                      fontSize: 25,
                      color: text,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Container(height: 2, width: 55, color: primary),
                ],
              ),
              const SizedBox(width: 18),
              Text(
                "On Process",
                style: AppTextStyle.interMedium20.copyWith(
                  fontSize: 25,
                  color: text,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 21),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                    Icon(Icons.keyboard_arrow_down, size: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}