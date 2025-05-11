import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/eventsandnews/event_item.dart';
import 'package:app_atletica/screens/eventsandnews/news_item.dart';
import 'package:intl/intl.dart';

class EventsNewsScreen extends StatefulWidget {
  const EventsNewsScreen({super.key});

  @override
  State<EventsNewsScreen> createState() => _EventsNewsScreenState();
}

class _EventsNewsScreenState extends State<EventsNewsScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<Map<String, dynamic>> combinedItems = [];

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

      final newsList = data['news'] ?? [];
      final eventsList = data['events'] ?? [];  // Correção de chave 'events'

      List<Map<String, dynamic>> combined = [];

      // Adicionar notícias à lista combinada
      for (var item in newsList) {
        combined.add({
          ...item,
          'type': 'news',
        });
      }

      // Adicionar eventos à lista combinada
      for (var item in eventsList) {
        combined.add({
          ...item,
          'type': 'event',
        });
      }

      combined.sort((a, b) {
        DateTime dateA = _parseDate(a['date'] ?? '');
        DateTime dateB = _parseDate(b['date'] ?? '');
        return dateB.compareTo(dateA);
      });

      setState(() {
        combinedItems = combined;
        news = newsList;
        events = eventsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      return DateTime(2000);
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.85; // Ajusta a largura do card (85% da largura da tela)

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
                const SizedBox(height: 5),
                CustomTitle(title: 'EVENTOS E NOTÍCIAS'),
                ...combinedItems.map(
                      (item) => Column(
                    children: [
                      // Utiliza a largura ajustada para os cards
                      Container(
                        width: cardWidth, // Aplica a largura do card
                        child: item['type'] == 'news'
                            ? NewsItem(
                          imageUrl: item['imageUrl'] ?? '',
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          date: item['date'] ?? '',
                          location: item['location'] ?? '',
                        )
                            : EventItem(
                          imageUrl: item['imageUrl'] ?? '',
                          title: item['title'] ?? '',
                          description: item['description'] ?? '',
                          date: item['date'] ?? '',
                          location: item['location'] ?? '',
                        ),
                      ),
                      const SizedBox(height: 20), // Ajuste do espaçamento
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
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
              Navigator.pushNamed(context, '/events_news');
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
