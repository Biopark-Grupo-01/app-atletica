import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 28, 58),
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: SizedBox(
                    width: 214,
                    child: Divider(
                      color: Color.fromARGB(255, 234, 194, 49),
                      thickness: 1,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'EVENTOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: SizedBox(
                    width: 214,
                    child: Divider(
                      color: Color.fromARGB(255, 234, 194, 49),
                      thickness: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 460,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 1.0,
                  ),
                  items: [
                    // Notícia exemplo
                    NewsItem(
                      imageUrl: 'https://via.placeholder.com/350x150',
                      date: '22/04/2025',
                      location: 'São Paulo',
                      title: 'TÍTULO NOTÍCIA',
                      description:
                          'Descrição da notícia com detalhes importantes sobre o acontecimento.',
                    ),
                    NewsItem(
                      imageUrl: 'https://via.placeholder.com/350x150',
                      date: '22/04/2025',
                      location: 'Curitiba',
                      title: 'TÍTULO NOTÍCIA',
                      description:
                          'Descrição da notícia com detalhes importantes sobre o acontecimento.',
                    ),
                  ],
                ),
                const Center(
                  child: SizedBox(
                    width: 214,
                    child: Divider(
                      color: Color.fromARGB(255, 234, 194, 49),
                      thickness: 1,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'NOTÍCIAS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: SizedBox(
                    width: 214,
                    child: Divider(
                      color: Color.fromARGB(255, 234, 194, 49),
                      thickness: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 460,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(
                      milliseconds: 800,
                    ),
                    pauseAutoPlayOnTouch: true,
                    viewportFraction: 1.0,
                  ),
                  items: [
                    // Evento exemplo
                    EventItem(
                      imageUrl: 'https://via.placeholder.com/350x150',
                      date: '30/04/2025',
                      location: 'Belo Horizonte',
                      title: 'TÍTULO EVENTO',
                      description:
                          'Descrição do evento com informações sobre horário e programação.',
                    ),
                    EventItem(
                      imageUrl: 'https://via.placeholder.com/350x150',
                      date: '30/04/2025',
                      location: 'Rio de Janeiro',
                      title: 'TÍTULO EVENTO',
                      description:
                          'Descrição do evento com informações sobre horário e programação.',
                    ),

                    // Adicione mais itens conforme necessário
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // Handle bottom navigation tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
