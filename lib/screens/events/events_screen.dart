import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  // Lista combinada para exibir tudo em ordem cronológica
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
      
      // Obter as listas separadas
      final newsList = data['news'] ?? [];
      final eventsList = data['events'] ?? [];
      
      // Criar a lista combinada com tipo identificado
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
      
      // Ordenar a lista combinada por data
      combined.sort((a, b) {
        DateTime dateA = _parseDate(a['date'] ?? '');
        DateTime dateB = _parseDate(b['date'] ?? '');
        // Ordenar do mais recente ao mais antigo
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
  
  // Função para converter string de data em objeto DateTime
  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      // Retornar uma data mínima em caso de erro
      return DateTime(2000);
    }
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
                        CustomTitle(title: 'EVENTOS E NOTÍCIAS'),
                        // Exibir itens combinados em ordem cronológica
                        ...combinedItems.map(
                          (item) => Column(
                            children: [
                              // Verificar o tipo do item e exibir o widget adequado
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/trainingDetail', // ou a rota da tela que quiser abrir
                                    arguments: item, // se quiser passar o conteúdo do card
                                  );
                                },
                                child: item['type'] == 'news'
                                  ? NewsItem(
                                      imageUrl: item['imageUrl'] ?? '',
                                      date: item['date'] ?? '',
                                      location: item['location'] ?? '',
                                      title: item['title'] ?? '',
                                      description: item['description'] ?? '',
                                    )
                                  : EventItem(
                                      imageUrl: item['imageUrl'] ?? '',
                                      date: item['date'] ?? '',
                                      location: item['location'] ?? '',
                                      title: item['title'] ?? '',
                                      description: item['description'] ?? '',
                                    ),
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