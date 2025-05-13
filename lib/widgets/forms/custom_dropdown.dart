import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final IconData icon;

  const CustomDropdown({super.key, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DropdownButtonFormField<String>(
          value:
              null,
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
          
          items:
              <String>[
                'Canecas',
                'Roupas',
                'Chaveiros',
                'Tatuagens',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: (String? newValue) {
            // Aqui você pode atualizar o estado com o novo valor selecionado
            // Por exemplo, usando setState() ou algum gerenciador de estado
          },
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}
