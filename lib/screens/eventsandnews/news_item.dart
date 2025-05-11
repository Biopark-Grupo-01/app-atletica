import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class NewsItem extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String location;
  final String title;
  final String description;

  const NewsItem({
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
      height: 400, // Altura fixa para padronizar os cards
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagem com borda superior arredondada
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.fill,
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

          // Conteúdo textual
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

                  // Descrição centralizada verticalmente
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
                      Text(
                        date,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.lightGrey,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        location,
                        style: const TextStyle(
                          color: AppColors.lightGrey,
                          fontSize: 14,
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
