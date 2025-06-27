import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(color: AppColors.white),
            prefixIcon: Icon(icon, color: AppColors.white),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.yellow, width: 2),
            ),
          ),
          dropdownColor: AppColors.blue,
          style: TextStyle(color: AppColors.white),
          icon: Icon(Icons.arrow_drop_down, color: AppColors.white),
          items: items,
          onChanged: onChanged,
          validator: validator,
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
