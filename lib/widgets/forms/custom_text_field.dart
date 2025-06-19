// lib/widgets/forms/custom_text_field.dart
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final IconData? icon; // Icon is now optional (IconData?)
  final TextEditingController? controller; // Allows passing an external controller
  final String? Function(String?)? validator; // Allows passing a validation function
  final bool readOnly; // For fields that shouldn't be typed into (like dates)
  final VoidCallback? onTap; // To handle taps (like for the date picker)
  final TextInputType keyboardType; // To define the keyboard type (email, URL, etc.)

  const CustomTextField({
    super.key,
    required this.label,
    this.icon, // Now optional
    this.controller, // Add this parameter
    this.validator, // Add this parameter
    this.readOnly = false, // Default to false
    this.onTap, // Add this parameter
    this.keyboardType = TextInputType.text, // Default to plain text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Keep the entire field centered
      children: [
        TextFormField(
          controller: controller, // Use the passed controller
          validator: validator, // Use the passed validator
          readOnly: readOnly, // Apply the readOnly property
          onTap: onTap, // Apply the onTap function
          keyboardType: keyboardType, // Set the keyboard type
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: AppColors.white),
            // Only show prefixIcon if 'icon' is not null
            prefixIcon: icon != null ? Icon(icon, color: AppColors.white) : null,

            // Changed to OutlineInputBorder for a modern and consistent look
            filled: true,
            fillColor: AppColors.lightBlue, // Background color of the field, consistent with CustomTextBox
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
              borderSide: BorderSide.none, // No default border
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.white, width: 1), // Border when enabled
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.yellow, width: 2), // Border when focused
            ),
            errorBorder: OutlineInputBorder( // Border for error state
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder( // Border for focused error state
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          style: const TextStyle(color: AppColors.white), // Color of the input text
          cursorColor: AppColors.lightGrey, // Color of the text cursor
        ),
        const SizedBox(height: 15), // Spacing below the field
      ],
    );
  }
}