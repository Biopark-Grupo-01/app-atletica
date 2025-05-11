import 'package:app_atletica/widgets/custom_square_button.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/home/carousel_item.dart';
import 'package:app_atletica/screens/eventsandnews/event_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

import '../eventsandnews/news_item.dart';
import '../trainings/training_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> eventsAndNews = [];
  List<Map<String, String>> trainings = [];

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await EventsNewsService.loadData(context);
      final events = data['events'] ?? [];
      final news = data['news'] ?? [];
      final combined = [...events, ...news];

      setState(() {
        eventsAndNews = combined;
        trainings = data['trainings'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
            ? Center(child: Text('Erro: $error'))
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 5),

                // Mensagem de boas-vindas estilizada
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Atlética Tigre Branco!\n',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(218, 255, 204, 0), // Amarelo mais fraco
                        ),
                      ),
                      TextSpan(
                        text:
                        'Fique por dentro dos eventos, notícias e conquistas da nossa atlética!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),


                const SizedBox(height: 25),

                // Eventos e Notícias
                CustomTitle(title: 'EVENTOS E NOTÍCIAS'),
                CarouselItem(
                  items: eventsAndNews,
                  useCarousel: true,
                  itemBuilder: (item) {
                    if (item['type'] == 'evento') {
                      return EventItem(
                        imageUrl: item['imageUrl'] ?? '',
                        title: item['title'] ?? '',
                        description: item['description'] ?? '',
                        date: item['date'] ?? '',
                        location: item['location'] ?? '',
                      );
                    } else {
                      return NewsItem(
                        imageUrl: item['imageUrl'] ?? '',
                        title: item['title'] ?? '',
                        description: item['description'] ?? '',
                        date: item['date'] ?? '',
                        location: item['location'] ?? '',
                      );
                    }
                  },
                ),

                const SizedBox(height: 30),


                CustomTitle(title: 'TREINOS E AMISTOSOS'),
                CarouselItem(
                  items: trainings,
                  useCarousel: true,
                  itemBuilder: (item) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Exibir o Treino
                        TrainingMatchItem(
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          date: item['date'] ?? '',
                          location: item['location'] ?? '',
                          category: item['category'] ?? '',
                          type: 'TREINOS',  // Tipo como Treino
                        ),
                        const SizedBox(height: 14),
                        // Exibir o Amistoso
                        TrainingMatchItem(
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          date: item['date'] ?? '',
                          location: item['location'] ?? '',
                          category: item['category'] ?? '',
                          type: 'AMISTOSOS',  // Tipo como Amistoso
                        ),
                        const SizedBox(height: 14),
                        // Exibir um terceiro item
                        TrainingMatchItem(
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          date: item['date'] ?? '',
                          location: item['location'] ?? '',
                          category: item['category'] ?? '',
                          type: 'AMISTOSOS',  // Tipo como Amistoso (poderia ser outro tipo, se necessário)
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
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
              Navigator.pushNamed(context, '/eventsandnews');
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
