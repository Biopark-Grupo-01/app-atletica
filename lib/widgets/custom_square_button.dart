import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomSquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? label;
  final Color color;
  final double? offsetXFactor;
  final double? offsetYFactor;

  const CustomSquareButton({
    super.key,
    required this.icon,
    this.offsetXFactor,
    this.offsetYFactor,
    required this.onPressed,
    required this.label,
    this.color = AppColors.yellow,
  });

  @override
  Widget build(BuildContext context) {
    // Pega o tamanho da tela
    final screenWidth = MediaQuery.of(context).size.width;

    // Define o tamanho do botão baseado no tamanho da tela
    final buttonSize = screenWidth * 0.20;

    // Calcula o offset baseado nos fatores proporcionais ou usa o offset fixo
    final Offset calculatedOffset = Offset(
      offsetXFactor != null ? buttonSize * offsetXFactor! : 0,
      offsetYFactor != null ? buttonSize * offsetYFactor! : 0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            fixedSize: Size(buttonSize, buttonSize), // Tamanho adaptativo
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Transform.translate(
            offset: calculatedOffset,
            child: Icon(
              icon,
              size: buttonSize * 0.5,
              color: AppColors.darkGrey,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label ?? '',
          style: const TextStyle(color: AppColors.white, fontSize: 18),
        ),
      ],
    );
  }
}
