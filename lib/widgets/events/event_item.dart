import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:intl/intl.dart';

class EventItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String date;
  final String location;
  final String title;
  final String description;
  final String price;

  const EventItem({
    super.key,
    required this.id,
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

  bool _hasValidImage() {
    // Verifica se tem uma imagem válida do backend
    return imageUrl.isNotEmpty && 
           imageUrl != 'null' && 
           !imageUrl.contains('placeholder') && 
           !imageUrl.contains('via.placeholder');
  }

  String _getNetworkImageUrl() {
    // Se já é uma URL completa, usa diretamente
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return imageUrl;
    }
    
    // Se é um caminho relativo do backend, constrói a URL completa
    return EventsNewsService().getFullImageUrl(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/trainingDetail',
          arguments: {
            'id': id,
            'title': title,
            'date': date,
            'location': location,
            'description': description,
            'price': price,
            'imageUrl': imageUrl,
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
          clipBehavior: Clip.antiAlias,          child: SizedBox(
            width: double.infinity,
            height: 200,
            child: _hasValidImage() 
                ? Image.network(
                    _getNetworkImageUrl(),
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.lightGrey,
                        child: const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Erro ao carregar imagem do evento: $error');
                      // Se falhar carregamento da rede, usa imagem mockada
                      return Image.asset(
                        'assets/images/roupa1.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.lightGrey,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Image.asset(
                    'assets/images/roupa1.png', // Imagem mockada como fallback
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