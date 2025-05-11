import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class EventItem extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String location;
  final String title;
  final String description;

  const EventItem({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400, // Altura ajustada
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 180, // Altura da imagem reduzida proporcionalmente
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.lightGrey,
                    child: const Center(
                      child: Icon(Icons.image_not_supported, size: 50),
                    ),
                  );
                },
              ),
            ),
          ),

          // Conteúdo do card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.yellow,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),

                  // Descrição centralizada
                  Center(
                    child: Text(
                      description,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Data e Localização
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: AppColors.lightGrey),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on, size: 14, color: AppColors.lightGrey),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
