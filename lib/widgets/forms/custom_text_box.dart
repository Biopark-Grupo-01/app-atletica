import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextBox extends StatelessWidget {
  final TextEditingController? controller;
  const CustomTextBox({super.key, this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(width: 9),
            Icon(Icons.description, color: AppColors.white),
            SizedBox(width: 10),
            Text(
              'Descrição',
              style: TextStyle(color: AppColors.white, fontSize: 16),
            ),
          ],
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.yellow, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          ),
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
