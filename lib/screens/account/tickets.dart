import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:app_atletica/widgets/tickets/ticket_card.dart';
import 'package:flutter/material.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

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
  final List<Map<String, String>> tickets = _mockTickets;
  final TextEditingController _searchController =
      TextEditingController();
  String _selectedStatus = 'valid';
  String _sortCriteria = 'date';

  @override
  void initState() {
    super.initState();
    // Atualizar a busca quando o texto mudar
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
    final filtered =
        tickets.where((ticket) {
          final matchesTitle = ticket['title']!.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );
          final matchesStatus =
              _selectedStatus == 'all' ||
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
                CustomTitle(title: 'INGRESSOS'),
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
        color: const Color(0xFF003366),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          menuWidth: width + 5,
          isDense: true,
          value: value,
          dropdownColor: const Color(0xFF003366),
          style: const TextStyle(color: AppColors.white),
          icon: Icon(icon, color: AppColors.white),
          items:
              items.map((item) {
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
        return TicketCard(
          date: ticket['date']!,
          title: ticket['title']!,
          status: ticket['status']!,
          imagePath: ticket['imagePath']!,
        );
      },
    );
  }
}
