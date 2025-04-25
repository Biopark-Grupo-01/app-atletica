import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/utils/utils.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/theme/app_colors.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Aqui ficarão os dados vindos do back
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      news = [
        {
          'imageUrl': 'https://picsum.photos/350/150',
          'date': '22/04/2025',
          'location': 'São Paulo',
          'title': 'Notícia do Backend',
          'description': 'Essa notícia veio da API.',
        },
      ];

      events = [
        {
          'imageUrl': 'https://picsum.photos/350/150',
          'date': '30/04/2025',
          'location': 'Rio de Janeiro',
          'title': 'Evento da API',
          'description': 'Evento vindo do back-end.',
        },
      ];

      isLoading = false;
    });
    // try {
    //   final newsResponse = await makeHttpRequest(context, "/news");
    //   final eventsResponse = await makeHttpRequest(context, "/events");

    //   if (newsResponse.statusCode == 200 && eventsResponse.statusCode == 200) {
    //     setState(() {
    //       news = json.decode(newsResponse.body);
    //       events = json.decode(eventsResponse.body);
    //       isLoading = false;
    //     });
    //   } else {
    //     throw Exception("Erro ao carregar dados do servidor");
    //   }
    // } catch (e) {
    //   setState(() {
    //     error = e.toString();
    //     isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child:
            isLoading
                ? const Center(
                  child: CircularProgressIndicator(color: AppColors.yellow),
                )
                : error != null
                ? Center(
                  child: Text(
                    'Erro: $error',
                    style: const TextStyle(color: AppColors.white),
                  ),
                )
                : SingleChildScrollView(
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
                              color: AppColors.yellow,
                              thickness: 1,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'EVENTOS E NOTÍCIAS',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Center(
                          child: SizedBox(
                            width: 214,
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        ...news.map(
                          (item) => Column(
                            children: [
                              NewsItem(
                                imageUrl: item['imageUrl'] ?? '',
                                date: item['date'] ?? '',
                                location: item['location'] ?? '',
                                title: item['title'] ?? '',
                                description: item['description'] ?? '',
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),

                        ...events.map(
                          (item) => Column(
                            children: [
                              EventItem(
                                imageUrl: item['imageUrl'] ?? '',
                                date: item['date'] ?? '',
                                location: item['location'] ?? '',
                                title: item['title'] ?? '',
                                description: item['description'] ?? '',
                              ),
                              const SizedBox(height: 40),
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
