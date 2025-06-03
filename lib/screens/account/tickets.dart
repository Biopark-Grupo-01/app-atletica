import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:app_atletica/widgets/tickets/ticket_card.dart';
import 'package:app_atletica/screens/account/user_model.dart';

class TicketsScreen extends StatefulWidget {
  final UserModel? user;

  const TicketsScreen({super.key, this.user});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

const List<Map<String, String>> _mockTickets = [
  {
    'date': '15/03/2025',
    'title': 'Festa de Abertura',
    'status': 'expired',
    'imagePath': 'https://picsum.photos/300/150',
  },
  {
    'date': '16/04/2025',
    'title': 'Competição de Atletismo',
    'status': 'used',
    'imagePath': 'https://picsum.photos/301/150',
  },
  {
    'date': '17/05/2025',
    'title': 'Show de Talentos',
    'status': 'used',
    'imagePath': 'https://picsum.photos/302/150',
  },
  {
    'date': '18/06/2025',
    'title': 'Corrida Noturna',
    'status': 'valid',
    'imagePath': 'https://picsum.photos/303/150',
  },
  {
    'date': '19/07/2025',
    'title': 'Feira Gastronômica',
    'status': 'valid',
    'imagePath': 'https://picsum.photos/304/150',
  },
  {
    'date': '20/08/2025',
    'title': 'Encerramento com Banda',
    'status': 'unpaid',
    'imagePath': 'https://picsum.photos/305/150',
  },
];

const List<Map<String, String>> _statusOptions = [
  {'text': 'Todos', 'value': 'all'},
  {'text': 'Válido', 'value': 'valid'},
  {'text': 'Utilizado', 'value': 'used'},
  {'text': 'Expirado', 'value': 'expired'},
  {'text': 'Não Pago', 'value': 'unpaid'},
];

class _TicketsScreenState extends State<TicketsScreen> {
  late List<Map<String, String>> tickets;
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'valid';
  String _sortCriteria = 'date';

  @override
  void initState() {
    super.initState();
    // Criar uma cópia mutável dos tickets
    tickets = _mockTickets.map((ticket) => Map<String, String>.from(ticket)).toList();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _filteredTickets {
    final filtered = tickets.where((ticket) {
      final matchesTitle = ticket['title']!.toLowerCase().contains(
        _searchController.text.toLowerCase(),
      );
      final matchesStatus = _selectedStatus == 'all' ||
          ticket['status']!.toLowerCase() == _selectedStatus.toLowerCase();
      return matchesTitle && matchesStatus;
    }).toList();

    _sortTickets(filtered);
    return filtered;
  }

  void _sortTickets(List<Map<String, String>> list) {
    switch (_sortCriteria) {
      case 'title':
        list.sort((a, b) => a['title']!.compareTo(b['title']!));
        break;
      case 'added':
        list.sort((a, b) => tickets.indexOf(b).compareTo(tickets.indexOf(a)));
        break;
      case 'date':
      default:
        final dateFormat = RegExp(r'(\d{2})/(\d{2})/(\d{4})');
        list.sort((a, b) {
          final aMatch = dateFormat.firstMatch(a['date']!);
          final bMatch = dateFormat.firstMatch(b['date']!);
          if (aMatch != null && bMatch != null) {
            final aDate = DateTime.parse(
              '${aMatch.group(3)}-${aMatch.group(2)}-${aMatch.group(1)}',
            );
            final bDate = DateTime.parse(
              '${bMatch.group(3)}-${bMatch.group(2)}-${bMatch.group(1)}',
            );
            return aDate.compareTo(bDate);
          }
          return 0;
        });
        break;
    }
  }

  void _showUseTicketDialog(int ticketIndex) {
    final ticket = tickets[ticketIndex];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Text(
                'Usar Ingresso',
                style: TextStyle(
                  color: AppColors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deseja marcar este ingresso como utilizado?',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticket['date']!,
                      style: TextStyle(
                        color: AppColors.darkGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Esta ação não pode ser desfeita.',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: TextStyle(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  tickets[ticketIndex]['status'] = 'used';
                });
                Navigator.of(context).pop();
                
                // Mostrar mensagem de sucesso
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Ingresso marcado como utilizado!'),
                    backgroundColor: AppColors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleTicketTap(int index) {
    final ticket = tickets[index];
    if (ticket['status']!.toLowerCase() == 'valid') {
      _showUseTicketDialog(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                CustomSearchBar(
                  hintText: 'Pesquisar ingressos',
                  controller: _searchController,
                ),
                const SizedBox(height: 25),
                _buildFilters(),
                const SizedBox(height: 30),
                _buildTicketsList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        _buildDropdown(
          icon: Icons.arrow_drop_down,
          value: _selectedStatus,
          items: _statusOptions,
          onChanged: (value) => setState(() => _selectedStatus = value!),
          width: 120,
        ),
        const SizedBox(width: 10),
        _buildDropdown(
          icon: Icons.sort,
          value: _sortCriteria,
          items: const [
            {'text': 'Data', 'value': 'date'},
            {'text': 'A-Z', 'value': 'title'},
            {'text': 'Mais Recente', 'value': 'added'},
          ],
          onChanged: (value) => setState(() => _sortCriteria = value!),
          width: 150,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
    required double width,
    IconData? icon,
  }) {
    return Container(
      width: width,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.lightBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuWidth: width + 5,
          isDense: true,
          value: value,
          dropdownColor: AppColors.lightBlue,
          style: const TextStyle(color: AppColors.white),
          icon: Icon(icon, color: AppColors.white),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item['value'],
              child: Text(item['text']!),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTicketsList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredTickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final ticket = _filteredTickets[index];
        final originalIndex = tickets.indexOf(ticket);
        
        return GestureDetector(
          onTap: () => _handleTicketTap(originalIndex),
          child: TicketCard(
            date: ticket['date']!,
            title: ticket['title']!,
            status: ticket['status']!,
            imagePath: ticket['imagePath']!,
          ),
        );
      },
    );
  }
}