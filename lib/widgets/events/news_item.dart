import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:intl/intl.dart';

class NewsItem extends StatelessWidget {
  final String imageUrl;
  final String? title;
  final String? description;
  final String? date; // ISO 8601 string do backend

  const NewsItem({
    super.key,
    required this.imageUrl,
    this.title,
    this.description,
    this.date,
  });

  String getTimeAgo() {
    if (date == null || date!.isEmpty) return '';
    try {
      DateTime dateTime;
      if (date!.endsWith('Z')) {
        // Backend salva como local mas adiciona 'Z', então removemos o 'Z' e parseamos como local
        dateTime = DateTime.parse(date!.replaceAll('Z', ''));
        // print('Data recebida (com Z, tratada como local): $date');
        // print('DateTime parseado (sem Z, local): $dateTime');
      } else {
        dateTime = DateTime.parse(date!);
        // print('Data recebida (sem Z): $date');
        // print('DateTime parseado: $dateTime');
      }
      final now = DateTime.now();
      // print('Data atual: $now');
      final diff = now.difference(dateTime);
      // print('Diferença: $diff');
      if (diff.inSeconds < 0) return 'Agora mesmo'; // futuro
      if (diff.inSeconds < 60) return 'Agora mesmo';
      if (diff.inMinutes < 60) return '${diff.inMinutes} min atrás';
      if (diff.inHours < 24) return '${diff.inHours} h atrás';
      if (diff.inDays >= 1 && diff.inDays < 7) return '${diff.inDays} d atrás';
      if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} sem atrás';
      if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} m atrás';
      return '${(diff.inDays / 365).floor()} a atrás';
    } catch (e) {
      // print('Erro ao calcular getTimeAgo: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Removido o retângulo com imagem
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title ?? '',
                  style: const TextStyle(
                    color: AppColors.yellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                getTimeAgo(),
                style: const TextStyle(
                  color: AppColors.lightGrey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}