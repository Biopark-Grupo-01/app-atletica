import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextFieldProfile extends StatelessWidget {
  final String label;
  final IconData icon;

  const CustomTextFieldProfile({super.key, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: TextEditingController(),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.white),
            suffixIcon: Icon(icon, color: AppColors.white),
            border: UnderlineInputBorder(),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.yellow, width: 2),
            ),
          ),
          style: TextStyle(color: AppColors.white),
          cursorColor: AppColors.lightGrey,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
