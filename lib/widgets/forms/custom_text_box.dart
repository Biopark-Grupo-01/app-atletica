// lib/widgets/forms/custom_text_box.dart
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomTextBox extends StatelessWidget {
  // Adiciona o parâmetro label para personalizar o texto
  final String label;
  // Permite passar um controlador de texto externo
  final TextEditingController? controller;
  // Permite passar uma função de validação para o TextFormField
  final String? Function(String?)? validator;

  const CustomTextBox({
    super.key,
    this.label = 'Descrição', // Valor padrão para 'label' se não for fornecido
    this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // Centraliza o campo inteiro
      children: [
        // Remove a Row com Icon e Text fixos, pois o TextFormField já tem labelText
        TextFormField(
          controller: controller, // Usa o controlador passado via construtor
          validator: validator,   // Usa a função de validação passada
          maxLines: 5,            // Mantém as 5 linhas máximas
          minLines: 3,            // Adiciona um mínimo de 3 linhas para melhor visual
          decoration: InputDecoration(
            labelText: label, // Usa o label passado para o InputDecoration
            labelStyle: const TextStyle(color: AppColors.white),

            // Adiciona as propriedades de design para consistência com CustomTextField
            filled: true,
            fillColor: AppColors.lightBlue, // Cor de fundo do campo
            
            // Define o estilo da borda para todos os estados
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), // Bordas arredondadas
              borderSide: BorderSide.none, // Sem borda padrão
            ),
            // Estilo da borda quando o campo está habilitado (não focado)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.white, width: 1), // Borda branca
            ),
            // Estilo da borda quando o campo está focado
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.yellow, width: 2), // Borda amarela mais grossa
            ),
            // Estilo da borda quando há um erro de validação
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1), // Borda vermelha para erro
            ),
            // Estilo da borda quando há um erro e o campo está focado
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2), // Borda vermelha mais grossa
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          ),
          style: const TextStyle(color: AppColors.white), // Cor do texto digitado
          cursorColor: AppColors.lightGrey, // Cor do cursor
        ),
        const SizedBox(height: 15), // Espaçamento após o campo
      ],
    );
  }
}