import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextFieldProfile extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFieldProfile({
    super.key,
    required this.label,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.white),
            suffixIcon: suffixIcon ?? Icon(icon, color: AppColors.white),
            border: const UnderlineInputBorder(),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.yellow, width: 2),
            ),
          ),
          style: const TextStyle(color: AppColors.white),
          cursorColor: AppColors.lightGrey,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
