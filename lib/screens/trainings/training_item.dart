import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class TrainingMatchItem extends StatelessWidget {
  final String date;
  final String location;
  final String title;
  final String description;
  final String category;  // Categoria
  final String type;      // Tipo (TREINO ou AMISTOSO)

  const TrainingMatchItem({
    super.key,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14), // Aumentado de 12 para 14
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12), // Aumento no borderRadius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
            type == 'TREINOS' ? 'Treino: $title' : 'Amistoso: $title',
            style: const TextStyle(
              color: Color(0xFFFFD700),
              fontSize: 18, // Aumentado de 16 para 18
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6), // Aumentado de 4 para 6

          // Descrição
          Text(
            description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15, // Aumentado de 13 para 15
            ),
          ),
          const SizedBox(height: 10), // Aumentado de 8 para 10

          // Informações
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16), // Aumentado de 14 para 16
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(color: Colors.white, fontSize: 14), // Aumentado de 13 para 14
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, color: Colors.white, size: 16), // Aumentado de 14 para 16
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14), // Aumentado de 13 para 14
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Aumento no padding
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8), // Aumento no borderRadius
                ),
                child: Text(
                  category,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13, // Aumentado de 11 para 13
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
