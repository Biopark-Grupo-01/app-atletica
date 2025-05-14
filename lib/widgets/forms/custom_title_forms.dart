
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTitleForms extends StatelessWidget {
  final String title;

  const CustomTitleForms({
    super.key,
    required this.title,
  });
@override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width  * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: SizedBox(
              width: double.infinity,
              child: Divider(color: AppColors.yellow, thickness: 1),
            ),
          ),
          Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Center(
            child: SizedBox(
              width: double.infinity,
              child: Divider(color: AppColors.yellow, thickness: 1),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}