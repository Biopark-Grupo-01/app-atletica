import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text; // Texto no botão
  final VoidCallback onPressed; // Callback para o evento de clique
  final bool isDisabled; // Controla se o botão está habilitado ou desabilitado

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false, // Por padrão o botão está habilitado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(280, 50), // Tamanho do botão
        backgroundColor: isDisabled
            ? Colors.grey // Cor do botão desabilitado
            : const Color.fromARGB(255, 234, 194, 49), // Cor padrão
        foregroundColor: const Color.fromARGB(255, 8, 8, 8), // Cor do texto
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Bordas arredondadas
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold, // Estilo do texto
          fontSize: 16,
        ),
      ),
    );
  }
}