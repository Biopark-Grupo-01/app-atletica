import 'package:flutter/material.dart';
import 'package:app_atletica/models/ticket_model.dart';
import 'package:app_atletica/services/ticket_service.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/search_bar.dart';

class AdminTicketsScreen extends StatefulWidget {
  const AdminTicketsScreen({super.key});

  @override
  State<AdminTicketsScreen> createState() => _AdminTicketsScreenState();
}

class _AdminTicketsScreenState extends State<AdminTicketsScreen> {
  List<TicketModel> _tickets = [];
  Map<String, String> _eventNames = {}; // Map para armazenar eventId -> eventName
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final tickets = await TicketService.getAllTickets();
      
      // Carregar nomes dos eventos
      final eventIds = tickets.map((ticket) => ticket.eventId).toSet();
      final eventsService = EventsNewsService();
      
      for (String eventId in eventIds) {
        try {
          final event = await eventsService.getEventById(eventId);
          if (event != null && event['title'] != null) {
            _eventNames[eventId] = event['title']!;
          }
        } catch (e) {
          print('Erro ao carregar evento $eventId: $e');
          _eventNames[eventId] = 'Evento #$eventId';
        }
      }
      
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erro: $_error', style: TextStyle(color: AppColors.white)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTickets,
                          child: Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              'Gerenciar Ingressos',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.yellow,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomSearchBar(
                              hintText: 'Pesquisar ingressos',
                              controller: _searchController,
                            ),
                            const SizedBox(height: 20),
                            // Removed create ticket button - tickets are created automatically with events
                          ],
                        ),
                      ),
                      Expanded(
                        child: _tickets.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.confirmation_number, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum ingresso encontrado',
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _tickets.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final ticket = _tickets[index];
                                  return _buildTicketCard(ticket);
                                },
                              ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ticket.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                'R\$ ${ticket.price.toStringAsFixed(2).replaceAll('.', ',')}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.yellow,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ticket.description,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.event, color: AppColors.white, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Evento: ${_eventNames[ticket.eventId] ?? 'Evento #${ticket.eventId}'}',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Status: ${ticket.displayStatus}',
                  style: TextStyle(
                    color: ticket.isAvailable ? Colors.green : 
                           ticket.isSold ? Colors.blue :
                           ticket.isUsed ? Colors.orange :
                           Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: AppColors.blue,
                      title: Text('Confirmar Exclusão', style: TextStyle(color: AppColors.white)),
                      content: Text(
                        'Tem certeza que deseja excluir este ingresso?',
                        style: TextStyle(color: AppColors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancelar', style: TextStyle(color: AppColors.white)),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    try {
                      await TicketService.deleteTicket(ticket.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ingresso excluído com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      _loadTickets();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao excluir ingresso: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
