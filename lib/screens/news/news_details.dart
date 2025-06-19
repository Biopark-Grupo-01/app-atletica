import 'dart:convert';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NewsDetailsScreen extends StatelessWidget {
  const NewsDetailsScreen({super.key});

  // Função para buscar notícia pelo id
  Future<Map<String, dynamic>> fetchNewsById(String id) async {
    final url = Uri.parse('http://10.200.142.159:3001/api/news/$id'); // ajuste a URL do seu backend
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    } else {
      throw Exception('Falha ao carregar notícia');
    }
  }

  bool _isNetworkUrl(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  Widget _buildNewsImage(String imageUrl) {
    if (_isNetworkUrl(imageUrl)) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/images/placeholder.png",
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey,
            child: const Center(
              child: Icon(Icons.image_not_supported, size: 50, color: Colors.white),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final args = ModalRoute.of(context)?.settings.arguments;
    final String? newsId = args is String ? args : null;

    if (newsId == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF001835),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text(
            'Erro: ID da notícia não fornecido.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF001835),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchNewsById(newsId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Erro ao carregar notícia: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Notícia não encontrada.',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            final newsItem = snapshot.data!;
            final String imageUrl = newsItem['imageUrl'] ?? 'assets/images/placeholder.png';
            final String title = newsItem['title'] ?? 'Título da Notícia Não Informado';
            final String date = newsItem['date'] ?? 'Data Não Informada';
            final String description = newsItem['description'] ?? 'Descrição da notícia não disponível.';

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: screenHeight * 0.3,
                        width: double.infinity,
                        child: _buildNewsImage(imageUrl),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 12,
                        left: 12,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              date,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        _sectionTitle(Icons.notes, 'Descrição da Notícia'),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color.fromARGB(128, 52, 90, 167), width: 0.5),
                              bottom: BorderSide(color: Color.fromARGB(128, 52, 90, 167), width: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              ClipOval(
                                child: Image.asset(
                                  "assets/images/emblema.png",
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Organizado por',
                                      style: TextStyle(color: Colors.white60, fontSize: 12),
                                    ),
                                    Text(
                                      'Associação Atlética Tigre Branco',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 72),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}

Widget _sectionTitle(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, color: Colors.white),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}
