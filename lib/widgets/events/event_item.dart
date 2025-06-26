import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final String imageUrl;
  final String date;
  final String location;
  final String title;
  final String description;
  final String price;

  const EventItem({
    super.key,
    required this.imageUrl,
    required this.date,
    required this.location,
    required this.title,
    required this.description,
    required this.price,
  });

  String _formatDate(String dateStr) {
    try {
      // Tenta fazer parse da data ISO 8601 do backend
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (e) {
      // Se falhar, retorna a string original
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/trainingDetail',
          arguments: {
            'title': title,
            'date': date,
            'location': location,
            'description': description,
            'price': price,
          },
        );
      },
      child: Column(
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
                    _formatDate(date),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.lightGrey,
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 16,
                      ),
                    ),
                  ),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.white, fontSize: 16),
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}