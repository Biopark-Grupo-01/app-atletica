
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTitle extends StatelessWidget {
  final String title; // Título a ser exibido

  const CustomTitle({
    super.key,
    required this.title,
  });
@override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
          child: SizedBox(
            width: 214,
            child: Divider(color: AppColors.yellow, thickness: 1),
          ),
        ),
        Center(
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Center(
          child: SizedBox(
            width: 214,
            child: Divider(color: AppColors.yellow, thickness: 1),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}