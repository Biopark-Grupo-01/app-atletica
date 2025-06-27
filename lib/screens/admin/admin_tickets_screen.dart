import 'package:flutter/material.dart';
import 'package:app_atletica/models/ticket_model.dart';
import 'package:app_atletica/services/ticket_service.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/services/user_service.dart';
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
  Map<String, String> _userNames = {}; // Map para armazenar userId -> userName
  Map<String, Map<String, int>> _eventTicketCounts = {}; // Map para contar tickets por evento e status
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
      
      // Carregar nomes dos eventos e contar tickets
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
        
        // Contar tickets por status para este evento (considerando userStatus também)
        final eventTickets = tickets.where((t) => t.eventId == eventId);
        _eventTicketCounts[eventId] = {
          'total': eventTickets.length,
          'available': eventTickets.where((t) => _getTicketFinalStatus(t) == 'available').length,
          'reserved': eventTickets.where((t) => _getTicketFinalStatus(t) == 'reserved').length,
          'sold': eventTickets.where((t) => _getTicketFinalStatus(t) == 'sold').length,
          'used': eventTickets.where((t) => _getTicketFinalStatus(t) == 'used').length,
          'cancelled': eventTickets.where((t) => _getTicketFinalStatus(t) == 'cancelled').length,
        };
      }
      
      // Carregar nomes dos usuários para tickets que têm userId
      final userIds = tickets
          .where((ticket) => ticket.userId != null && ticket.userId!.isNotEmpty)
          .map((ticket) => ticket.userId!)
          .toSet();
      
      for (String userId in userIds) {
        try {
          final user = await UserService.getUserById(userId, context);
          if (user != null) {
            _userNames[userId] = user.name;
          }
        } catch (e) {
          print('Erro ao carregar usuário $userId: $e');
          _userNames[userId] = 'Usuário #$userId';
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
                        child: _eventNames.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.confirmation_number, size: 64, color: Colors.grey),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Nenhum evento com ingressos encontrado',
                                      style: TextStyle(color: Colors.grey, fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                itemCount: _eventNames.length,
                                separatorBuilder: (_, __) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final eventId = _eventNames.keys.elementAt(index);
                                  final eventName = _eventNames[eventId]!;
                                  final ticketCounts = _eventTicketCounts[eventId]!;
                                  return _buildEventCard(eventId, eventName, ticketCounts);
                                },
                              ),
                      ),
                    ],
                  ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildEventCard(String eventId, String eventName, Map<String, int> ticketCounts) {
    final total = ticketCounts['total'] ?? 0;
    final available = ticketCounts['available'] ?? 0;
    final reserved = ticketCounts['reserved'] ?? 0;
    final sold = ticketCounts['sold'] ?? 0;
    final used = ticketCounts['used'] ?? 0;
    final cancelled = ticketCounts['cancelled'] ?? 0;

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
                  eventName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$total ingressos',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'ID do Evento: $eventId',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          // Status dos ingressos
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              _buildStatusChip('Disponíveis', available, Colors.green),
              _buildStatusChip('Reservados', reserved, Colors.orange),
              _buildStatusChip('Vendidos', sold, Colors.blue),
              _buildStatusChip('Usados', used, Colors.purple),
              _buildStatusChip('Cancelados', cancelled, Colors.red),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Navegar para tela de detalhes dos ingressos deste evento
                  _showEventTicketsDetails(eventId, eventName);
                },
                child: Text(
                  'Ver Detalhes',
                  style: TextStyle(color: AppColors.yellow),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showEventTicketsDetails(String eventId, String eventName) {
    final eventTickets = _tickets.where((ticket) => ticket.eventId == eventId).toList();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.blue,
        title: Text(
          'Ingressos - $eventName',
          style: TextStyle(color: AppColors.white),
        ),
        content: Container(
          width: double.maxFinite,
          height: 400,
          child: ListView.separated(
            itemCount: eventTickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final ticket = eventTickets[index];
              return _buildTicketDetailCard(ticket);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetailCard(TicketModel ticket) {
    // Usar o mesmo método de status que usamos na contagem
    final finalStatus = _getTicketFinalStatus(ticket);
    
    // Definir cores e ícones baseados no status final
    Color statusColor;
    IconData statusIcon;
    
    switch (finalStatus) {
      case 'available':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'reserved':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'sold':
        statusColor = Colors.blue;
        statusIcon = Icons.payment;
        break;
      case 'used':
        statusColor = Colors.purple;
        statusIcon = Icons.verified;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  ticket.name,
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: 12,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ticket.displayStatus,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Preço: R\$ ${ticket.formattedPrice}',
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 12,
            ),
          ),
          if (ticket.userId != null && ticket.userId!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.person,
                  size: 12,
                  color: AppColors.white.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 4),
                Text(
                  'Usuário: ${_userNames[ticket.userId] ?? 'Carregando...'}',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
          if (ticket.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              ticket.description,
              style: TextStyle(
                color: AppColors.white.withValues(alpha: 0.6),
                fontSize: 10,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  // Método para determinar o status final do ticket considerando userStatus
  String _getTicketFinalStatus(TicketModel ticket) {
    // Se há userStatus, ele tem prioridade
    if (ticket.userStatus != null) {
      switch (ticket.userStatus!.toLowerCase()) {
        case 'not_paid':
          return 'reserved'; // Tickets não pagos são contados como reservados
        case 'paid':
          return 'sold'; // Tickets pagos são contados como vendidos
        case 'used':
          return 'used';
        case 'expired':
        case 'cancelled':
        case 'refunded':
          return 'cancelled';
        default:
          return ticket.status; // Fallback para o status original
      }
    }
    
    // Se não há userStatus, usa o status original
    return ticket.status;
  }
}
