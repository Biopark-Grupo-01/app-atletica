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
  final EventsNewsService _service = EventsNewsService();
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  bool isLoading = true;
  String? error;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadEventsFromService(); // Carrega eventos do serviço por padrão
  }

  Future<void> _loadNewsFromService() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final newsList = await _service.getNewsFromBackend();
      setState(() {
        news = newsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadEventsFromService() async {
    setState(() {
      isLoading = true;
      error = null;
    });
    try {
      final eventsList = await _service.getEventsFromBackend();
      setState(() {
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
                                    onLongPress: () {
                                      _showContextMenu(context, item, _selectedTabIndex);
                                    },
                                    child: _selectedTabIndex == 0
                                        ? EventItem(
                                            imageUrl: item['imageUrl'] ?? '',
                                            date: item['date'] ?? '',
                                            location: item['location'] ?? '',
                                            title: item['title'] ?? '',
                                            description: item['description'] ?? '',
                                            price: item['price'] ?? '0,00',
                                          )
                                        : GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => NewsDetailScreen(news: item),
                                                ),
                                              );
                                            },
                                            child: NewsItem(
                                              imageUrl: item['imageUrl'] ?? '',
                                              date: item['date'] ?? '',
                                              title: item['title'] ?? '',
                                              description: item['description'] ?? '',
                                            ),
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
            await _loadNewsFromService();
          } else if (index == 0) {
            await _loadEventsFromService();
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

  Future<void> _showContextMenu(BuildContext context, Map<String, String> item, int tabIndex) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.blue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Opções para "${item['title']}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Editar', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _editItem(item, tabIndex);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteItem(context, item, tabIndex);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _editItem(Map<String, String> item, int tabIndex) {
    if (tabIndex == 0) {
      // Editar evento
      Navigator.pushNamed(
        context,
        '/event_registration',
        arguments: item,
      ).then((_) {
        // Recarrega os dados quando volta da tela de edição
        _loadEventsFromService();
      });
    } else {
      // Editar notícia
      Navigator.pushNamed(
        context,
        '/news_registration',
        arguments: item,
      ).then((_) {
        // Recarrega os dados quando volta da tela de edição
        _loadNewsFromService();
      });
    }
  }

  Future<void> _deleteItem(BuildContext context, Map<String, String> item, int tabIndex) async {
    final String itemType = tabIndex == 0 ? 'evento' : 'notícia';
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Confirmar Exclusão',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Tem certeza que deseja excluir este $itemType?\n\n"${item['title']}"',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
              ),
              child: Text(
                'Excluir',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _performDelete(item, tabIndex);
    }
  }

  Future<void> _performDelete(Map<String, String> item, int tabIndex) async {
    try {
      setState(() {
        isLoading = true;
      });

      final itemId = item['id'];
      if (itemId == null || itemId.isEmpty) {
        throw Exception('ID do item não encontrado');
      }

      bool success;
      if (tabIndex == 0) {
        // Excluir evento
        success = await _service.deleteEvent(itemId);
      } else {
        // Excluir notícia
        success = await _service.deleteNews(itemId);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tabIndex == 0 ? 'Evento' : 'Notícia'} excluído(a) com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Recarrega os dados
        if (tabIndex == 0) {
          await _loadEventsFromService();
        } else {
          await _loadNewsFromService();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao excluir ${tabIndex == 0 ? 'evento' : 'notícia'}!'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
