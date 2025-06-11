import 'dart:ui';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class TelaNoticiasDetalhes extends StatelessWidget {
  const TelaNoticiasDetalhes({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Recebe os argumentos passados para esta tela
    final Map<String, String>? newsItem =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>?;

    // Garante que newsItem não é nulo e extrai os dados
    if (newsItem == null) {
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
            'Erro: Item de notícia não encontrado.',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final String imageUrl = newsItem['imageUrl'] ?? 'assets/images/placeholder.png';
    final String title = newsItem['title'] ?? 'Título da Notícia Não Informado';
    final String date = newsItem['date'] ?? 'Data Não Informada';
    final String description = newsItem['description'] ?? 'Descrição da notícia não disponível.';

    // Função auxiliar para verificar se a string é uma URL válida
    bool _isNetworkUrl(String path) {
      return path.startsWith('http://') || path.startsWith('https://');
    }

    Widget _buildNewsImage() {
      if (_isNetworkUrl(imageUrl)) {
        return Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback para asset local se a URL de rede falhar
            return Image.asset(
              "assets/images/placeholder.png",
              fit: BoxFit.cover,
            );
          },
        );
      } else {
        return Image.asset(
          imageUrl, // Isso cobrirá 'assets/images/placeholder.png' se imageUrl for isso
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Em caso de erro com o asset local (improvável, mas para segurança)
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


    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF001835),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem principal com o botão de voltar
            Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.3,
                  width: double.infinity,
                  child: _buildNewsImage(),
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

            // Conteúdo da notícia
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 36), // Espaçamento antes da seção "Descrição da Notícia"

                  // Descrição da Notícia
                  _sectionTitle(Icons.notes, 'Descrição da Notícia'),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 24), // Espaçamento antes da seção "Organizado por"

                  // Informações do organizador
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
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 3),
    );
  }
}

// Função auxiliar para títulos de seção
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
