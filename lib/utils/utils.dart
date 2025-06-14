import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:intl/intl.dart';

/// Funções utilitárias para uso em todo o aplicativo

// Formatar data no padrão brasileiro
String formatDateBR(DateTime date) {
  final formatter = DateFormat('dd/MM/yyyy');
  return formatter.format(date);
}

// Formatar preço para moeda brasileira
String formatCurrency(dynamic value) {
  if (value == null) return 'R\$ 0,00';
  
  // Se o valor vier como string, converte para double
  double numValue;
  if (value is String) {
    // Remove R$ e outros caracteres não numéricos, exceto ponto e vírgula
    final cleanValue = value.replaceAll(RegExp(r'[^0-9,.]'), '');
    // Substitui vírgula por ponto para conversão correta
    final valueWithDot = cleanValue.replaceAll(',', '.');
    numValue = double.tryParse(valueWithDot) ?? 0.0;
  } else if (value is double) {
    numValue = value;
  } else if (value is int) {
    numValue = value.toDouble();
  } else {
    return 'R\$ 0,00';
  }
  
  final formatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
  );
  
  return formatter.format(numValue);
}

// Mostrar um snackbar personalizado
void showCustomSnackbar(
  BuildContext context, 
  String message, {
  bool isError = false,
  int durationSeconds = 3,
}) {  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : AppColors.blue,
      duration: Duration(seconds: durationSeconds),
    ),
  );
}

// Validar CPF
bool isValidCpf(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
  
  // CPF deve ter 11 dígitos
  if (cpf.length != 11) {
    return false;
  }
  
  // Verifica se todos os dígitos são iguais
  if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
    return false;
  }
  
  // Validação dos dígitos verificadores
  List<int> digits = cpf.split('').map(int.parse).toList();
  
  // Cálculo do primeiro dígito verificador
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += digits[i] * (10 - i);
  }
  int remainder = 11 - (sum % 11);
  int firstVerifier = remainder >= 10 ? 0 : remainder;
  
  if (firstVerifier != digits[9]) {
    return false;
  }
  
  // Cálculo do segundo dígito verificador
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += digits[i] * (11 - i);
  }
  remainder = 11 - (sum % 11);
  int secondVerifier = remainder >= 10 ? 0 : remainder;
  
  return secondVerifier == digits[10];
}

// Formatar CPF para exibição
String formatCpf(String cpf) {
  // Remove caracteres não numéricos
  cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');
  
  if (cpf.length != 11) {
    return cpf;
  }
  
  return '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9)}';
}

// Obter cores com base na categoria
Color getCategoryColor(String category) {
  switch (category.toUpperCase()) {
    case 'CANECAS':
      return Colors.blue;
    case 'ROUPAS':
      return Colors.green;
    case 'CHAVEIROS':
      return Colors.orange;
    case 'TATUAGENS':
      return Colors.purple;
    default:
      return AppColors.yellow;
  }
}

// Cores para diferentes papéis de usuário
Color roleColor(String? role) {
  switch (role?.toUpperCase()) {
    case 'ASSOCIADO':
      return const Color.fromARGB(255, 49, 151, 234);
    case 'DIRETORIA':
      return AppColors.yellow;
    case 'NÃO ASSOCIADO':
      return AppColors.lightGrey;
    default:
      return AppColors.lightGrey;
  }
}
