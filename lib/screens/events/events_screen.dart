import 'package:app_atletica/services/news_service.dart';
import 'package:app_atletica/widgets/news/news_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Alterando para Map<String, dynamic> para compatibilidade com a API
  List<Map<String, dynamic>> news = [];
  List<Map<String, dynamic>> events = [];
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
      setState(() {
        isLoading = true;
        error = null;
      });

      // Carregando dados através do serviço atualizado
      final data = await EventsNewsService.loadData(context);

      setState(() {
        // Convertendo para o tipo correto
        news = List<Map<String, dynamic>>.from(data['news'] ?? []);
        events = List<Map<String, dynamic>>.from(data['events'] ?? []);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      print('Erro ao carregar dados: $e');
    }
  }

  DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime(2000);
    try {
      return DateFormat('dd/MM/yyyy').parse(dateStr);
    } catch (e) {
      try {
        // Tentativa alternativa de parsing (caso a data venha em outro formato do backend)
        return DateTime.parse(dateStr);
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
      final dateA = _parseDate(a['date']?.toString());
      final dateB = _parseDate(b['date']?.toString());
      return dateB.compareTo(dateA);
    });

    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              )
            : error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Erro ao carregar dados:',
                          style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error!,
                          style: const TextStyle(color: AppColors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadData,
                          child: const Text('Tentar novamente'),
                        )
                      ],
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
                          child: sortedList.isEmpty
                              ? Center(
                                  child: Text(
                                    _selectedTabIndex == 0 
                                      ? 'Nenhum evento encontrado.' 
                                      : 'Nenhuma notícia encontrada.',
                                    style: const TextStyle(color: AppColors.white),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: sortedList.length,
                                  itemBuilder: (context, index) {
                                    final item = sortedList[index];
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/trainingDetail',
                                              arguments: item,
                                            );
                                          },
                                          child: _selectedTabIndex == 0
                                              ? EventItem(
                                                  imageUrl: item['imageUrl']?.toString() ?? '',
                                                  date: item['date']?.toString() ?? '',
                                                  location: item['location']?.toString() ?? '',
                                                  title: item['title']?.toString() ?? '',
                                                  description: item['description']?.toString() ?? '',
                                                )
                                              : NewsItem(
                                                  imageUrl: item['imageUrl']?.toString() ?? '',
                                                  date: item['date']?.toString() ?? '',
                                                  title: item['title']?.toString() ?? '',
                                                  description: item['description']?.toString() ?? '',
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
      bottomNavigationBar: const CustomBottomNavBar(
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