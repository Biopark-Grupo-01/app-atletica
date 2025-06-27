import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';

class NewsDetailScreen extends StatelessWidget {
  final Map<String, String> news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  String get formattedDate {
    try {
      if ((news['date'] ?? '').contains('/')) {
        return news['date']!;
      }
      final date = DateTime.parse(news['date'] ?? '');
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return news['date'] ?? '';
    }
  }

  String get formattedDateTime {
    try {
      final date = DateTime.parse(news['date'] ?? '');
      final dateStr = DateFormat('dd/MM/yyyy').format(date);
      final hourStr = DateFormat('HH:mm').format(date);
      return '$dateStr • $hourStr';
    } catch (_) {
      return news['date'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: const Text('Detalhe da Notícia', style: TextStyle(color: AppColors.white)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                news['title'] ?? '',
                style: const TextStyle(
                  color: AppColors.yellow,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              if ((news['author'] ?? '').isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.person, color: AppColors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'Por ${news['author']}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, color: AppColors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    formattedDateTime,
                    style: const TextStyle(color: AppColors.white, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Imagem da notícia
              if ((news['imageUrl'] ?? '').isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    EventsNewsService().getFullImageUrl(news['imageUrl']!),
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Container(
                        height: 200,
                        color: AppColors.lightGrey.withValues(alpha: 0.3),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.yellow,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ Erro ao carregar imagem na tela de detalhes: $error');
                      return Container(
                        height: 200,
                        color: AppColors.lightGrey.withValues(alpha: 0.3),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: AppColors.lightGrey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Imagem não encontrada',
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if ((news['imageUrl'] ?? '').isNotEmpty) const SizedBox(height: 24),
              Text(
                news['description'] ?? '',
                style: const TextStyle(color: AppColors.white, fontSize: 18),
              ),
              const SizedBox(height: 24),
              if ((news['location'] ?? '').isNotEmpty)
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.white, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      news['location']!,
                      style: const TextStyle(color: AppColors.white, fontSize: 16),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
