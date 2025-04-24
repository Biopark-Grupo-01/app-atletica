import 'package:flutter/material.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Retângulo com imagem
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: double.infinity,
            height: 270,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color.fromARGB(255, 189, 189, 189),
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
                      color: Color.fromARGB(255, 248, 246, 245),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.location_on, size: 16, color: Color.fromARGB(255, 189, 189, 189)),
                  const SizedBox(width: 2),
                  Text(
                    location,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 189, 189, 189),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 234, 194, 49),
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color.fromARGB(255, 248, 246, 245),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}