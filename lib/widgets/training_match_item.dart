import 'package:app_atletica/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TrainingMatchItem extends StatelessWidget {
  final String date;
  final String location;
  final String title;
  final String description;
  final String modality;  // Substitui category
  final bool isMatch;     // Substitui type

  const TrainingMatchItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.modality,
    required this.isMatch, // true para AMISTOSO, false para TREINO
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            isMatch ? 'Amistoso: $title' : 'Treino: $title',
            style: const TextStyle(
              color: AppColors.yellow,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),

          // Descrição
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),

          // Informações
          Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, color: AppColors.white, size: 16),              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  modality.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
