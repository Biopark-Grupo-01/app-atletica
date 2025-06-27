import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texto no botão
  final VoidCallback onPressed; // Callback para o evento de clique
  final bool isDisabled; // Controla se o botão está habilitado ou desabilitado
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false, // Por padrão o botão está habilitado
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(280, 50),
        backgroundColor: isDisabled
            ? AppColors.lightGrey // Cor do botão desabilitado
            : backgroundColor ?? AppColors.yellow,
        foregroundColor: textColor ?? AppColors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}