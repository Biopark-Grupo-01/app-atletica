import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;

  const CustomTextField({super.key, required this.label, required this.icon, this.validator, this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.white),
            prefixIcon: Icon(icon, color: AppColors.white),
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
          validator: validator,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
