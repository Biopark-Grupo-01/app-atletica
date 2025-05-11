import 'package:app_atletica/widgets/custom_square_button.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/home/carousel_item.dart';
import 'package:app_atletica/screens/events/event_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../news/news_item.dart';
import '../trainings/training_item.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<Map<String, String>> trainings = []; // Lista para Treinos e Amistosos

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Carregando dados de notícias e eventos
      final data = await EventsNewsService.loadData(context);
      setState(() {
        news = data['news'] ?? [];
        events = data['events'] ?? [];
        trainings = data['trainings'] ?? []; // Carregando Treinos e Amistosos
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                const SizedBox(height: 30),

                // Exibindo os eventos
                CustomTitle(title: 'EVENTOS'),
                CarouselItem(
                  items: events,
                  useCarousel: true,
                  itemBuilder: (item) => EventItem(
                    imageUrl: item['imageUrl'] ?? '',
                    date: item['date'] ?? '',
                    location: item['location'] ?? '',
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                  ),
                ),

                // Exibindo as notícias
                CustomTitle(title: 'NOTÍCIAS'),
                CarouselItem(
                  items: news,
                  useCarousel: true,
                  itemBuilder: (item) => NewsItem(
                    imageUrl: item['imageUrl'] ?? '',
                    date: item['date'] ?? '',
                    location: item['location'] ?? '',
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                  ),
                ),

                // Exibindo os treinos e amistosos
                CustomTitle(title: 'TREINOS E AMISTOSOS'),
                CarouselItem(
                  items: trainings,
                  useCarousel: true,
                  itemBuilder: (item) => TrainingMatchItem(
                    imageUrl: item['imageUrl'] ?? '',
                    date: item['date'] ?? '',
                    location: item['location'] ?? '',
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                  ),
                ),
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

