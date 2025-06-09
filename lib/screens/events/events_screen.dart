import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

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
      final data = await EventsNewsService.loadData(context);
      final newsList = data['news'] ?? [];
      final eventsList = data['events'] ?? [];

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

  DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      return DateTime(2000);
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
                      'Erro: \$error',
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
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                        if (_selectedTabIndex == 0) {
                                        Navigator.pushNamed(
                                          context,
                                          '/trainingDetail',
                                          arguments: item,
                                        );
                                        } else {
                                        Navigator.pushNamed(
                                          context,
                                          '/newsDetail',
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
                                            location: item['location'] ?? '',
                                            title: item['title'] ?? '',
                                            description: item['description'] ?? '',
                                          ),
                                  ),
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
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
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
