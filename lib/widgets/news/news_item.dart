import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';

class NewsItem extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String title;
  final String description;
  final bool hideLocationIcon;

  const NewsItem({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.title,
    required this.description,
    this.hideLocationIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Retângulo com imagem
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: 250,
            child: Image.network(
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

        // Informações de texto abaixo do retângulo
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
