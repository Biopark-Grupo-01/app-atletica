import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/events/news_detail_screen.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  bool isLoading = true;
  String? error;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final service = EventsNewsService();
      final data = await service.loadData(context);
      final newsList = (data['news'] ?? []).map<Map<String, String>>((e) => Map<String, String>.from(e)).toList();
      final eventsList = (data['events'] ?? []).map<Map<String, String>>((e) => Map<String, String>.from(e)).toList();

      setState(() {
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

  Future<void> _loadNewsFromBackend() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final response = await http.get(Uri.parse('http://192.168.1.2:3001/api/news'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        final List<Map<String, String>> newsList = data.map<Map<String, String>>((item) {
          return {
            'id': item['id'] ?? '',
            'title': item['title'] ?? '',
            'description': item['description'] ?? '',
            'date': item['date'] ?? '', // MANTÉM formato ISO
            'author': item['author'] ?? '',
            'imageUrl': '', // Adapte se houver imagem
            'location': '', // Adapte se houver local
          };
        }).toList();
        setState(() {
          news = newsList;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Erro ao buscar notícias: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  DateTime _parseDate(String dateStr) {
    try {
      // Tenta ISO 8601 (notícias)
      return DateTime.parse(dateStr);
    } catch (_) {
      try {
        // Tenta dd/MM/yyyy (eventos)
        return DateFormat('dd/MM/yyyy').parse(dateStr);
      } catch (e) {
        return DateTime(2000);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentList = _selectedTabIndex == 0 ? events : news;
    final sortedList = [...currentList];
    sortedList.sort((a, b) {
      final dateA = _parseDate(a['date'] ?? '');
      final dateB = _parseDate(b['date'] ?? '');
      return dateB.compareTo(dateA);
    });

    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              )
            : error != null
                ? Center(
                    child: Text(
                      'Erro: ${error ?? "Erro desconhecido"}',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTab('EVENTOS', 0)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTab('NOTÍCIAS', 1)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: sortedList.length,
                            itemBuilder: (context, index) {
                              final item = sortedList[index];
                              final isLast = index == sortedList.length - 1;
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_selectedTabIndex == 1) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => NewsDetailScreen(news: item),
                                          ),
                                        );
                                      } else {
                                        Navigator.pushNamed(
                                          context,
                                          '/trainingDetail',
                                          arguments: item,
                                        );
                                      }
                                    },
                                    child: _selectedTabIndex == 0
                                        ? EventItem(
                                            imageUrl: item['imageUrl'] ?? '',
                                            date: item['date'] ?? '',
                                            location: item['location'] ?? '',
                                            title: item['title'] ?? '',
                                            description: item['description'] ?? '',
                                          )
                                        : NewsItem(
                                            imageUrl: item['imageUrl'] ?? '',
                                            date: item['date'] ?? '',
                                            title: item['title'] ?? '',
                                            description: item['description'] ?? '',
                                          ),
                                  ),
                                  if (_selectedTabIndex == 1 && !isLast)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                      child: Divider(
                                        color: AppColors.lightGrey.withOpacity(0.4),
                                        thickness: 1.2,
                                        height: 1,
                                      ),
                                    )
                                  else if (_selectedTabIndex == 0)
                                    const SizedBox(height: 40),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3 
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = index == _selectedTabIndex;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          setState(() {
            _selectedTabIndex = index;
          });
          if (index == 1) {
            await _loadNewsFromBackend();
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? AppColors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? AppColors.yellow : AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
