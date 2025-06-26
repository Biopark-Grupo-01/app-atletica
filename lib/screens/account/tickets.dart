import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:app_atletica/widgets/tickets/ticket_card.dart';
import 'package:app_atletica/services/ticket_service.dart';
import 'package:app_atletica/models/ticket_model.dart';
import 'package:provider/provider.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:intl/intl.dart';

class TicketsScreen extends StatefulWidget {
  final String? specificUserId; // Para quando admin quer ver tickets de um usuário específico
  
  const TicketsScreen({super.key, this.specificUserId});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  List<TicketModel> _tickets = [];
  List<TicketModel> _allTickets = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedStatus = 'all';
  String _sortCriteria = 'date';
  bool _isLoading = true;
  String? _error;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _filterTickets();
    });
    _loadTickets();
    _checkUserRole();
    
    // Mostra mensagem se o usuário acabou de comprar um ticket
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPurchaseSuccess();
    });
  }

  void _checkForPurchaseSuccess() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map<String, dynamic> && args['justPurchased'] == true) {
      final ticketName = args['ticketName'] as String?;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ticketName != null 
                ? 'Parabéns! Você adquiriu o ingresso "$ticketName" com sucesso!'
                : 'Parabéns! Seu ingresso foi adquirido com sucesso!',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
          action: SnackBarAction(
            label: 'Ver ingressos',
            textColor: Colors.white,
            onPressed: () {
              // Scroll para o topo da lista
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkUserRole() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      // Admin pode alterar status tanto na tela geral quanto na específica de usuário
      _isAdmin = userProvider.isAdmin;
    });
  }

  Future<void> _loadTickets() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      List<TicketModel> tickets;

      print('Carregando tickets...');
      print('specificUserId: ${widget.specificUserId}');
      print('userProvider.isAdmin: ${userProvider.isAdmin}');
      print('currentUser: ${userProvider.currentUser?.id}');

      if (widget.specificUserId != null) {
        // Admin está vendo tickets de um usuário específico
        print('Carregando tickets para usuário específico: ${widget.specificUserId}');
        tickets = await TicketService.getUserTickets(widget.specificUserId!);
      } else if (userProvider.isAdmin && widget.specificUserId == null) {
        // Admin está na tela geral de tickets - vê todos os tickets
        print('Admin carregando todos os tickets');
        tickets = await TicketService.getAllTickets();
      } else {
        // Usuário normal vê apenas seus próprios tickets
        final userId = userProvider.currentUser?.id;
        if (userId != null) {
          print('Usuário normal carregando seus tickets: $userId');
          tickets = await TicketService.getUserTickets(userId);
        } else {
          print('Usuário não logado');
          tickets = [];
        }
      }

      print('Tickets carregados: ${tickets.length}');
      for (final ticket in tickets) {
        print('Ticket: ${ticket.name} - Status: ${ticket.status} - UserStatus: ${ticket.userStatus}');
      }

      setState(() {
        _allTickets = tickets;
        _filterTickets();
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar tickets: $e');
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterTickets() {
    setState(() {
      _tickets = _allTickets.where((ticket) {
        final matchesTitle = ticket.name.toLowerCase().contains(
          _searchController.text.toLowerCase(),
        );
        final matchesStatus = _selectedStatus == 'all' ||
            ticket.ticketCardStatus == _selectedStatus;
        return matchesTitle && matchesStatus;
      }).toList();

      _sortTickets();
    });
  }

  void _sortTickets() {
    switch (_sortCriteria) {
      case 'title':
        _tickets.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'added':
        _tickets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'date':
      default:
        _tickets.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
  }

  Future<void> _showStatusChangeDialog(TicketModel ticket) async {
    if (!_isAdmin) return;

    // Se estamos visualizando tickets de um usuário específico, mostra ações específicas para admin
    if (widget.specificUserId != null) {
      _showUserTicketManagementDialog(ticket);
      return;
    }

    // Fluxo original para admin geral
    final statusOptions = [
      {'text': 'Disponível', 'value': 'available'},
      {'text': 'Reservado', 'value': 'reserved'},
      {'text': 'Vendido', 'value': 'sold'},
      {'text': 'Cancelado', 'value': 'cancelled'},
    ];

    final userStatusOptions = [
      {'text': 'Não Pago', 'value': 'not_paid'},
      {'text': 'Pago', 'value': 'paid'},
      {'text': 'Usado', 'value': 'used'},
      {'text': 'Expirado', 'value': 'expired'},
      {'text': 'Cancelado', 'value': 'cancelled'},
      {'text': 'Reembolsado', 'value': 'refunded'},
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alterar Status - ${ticket.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Status Atual: ${ticket.displayStatus}'),
            const SizedBox(height: 16),
            Text('Novo Status do Ticket:'),
            ...statusOptions.map((option) => RadioListTile<String>(
              title: Text(option['text']!),
              value: option['value']!,
              groupValue: null,
              onChanged: (value) async {
                Navigator.pop(context);
                await _updateTicketStatus(ticket, status: value);
              },
            )),
            const Divider(),
            Text('Status do Usuário:'),
            ...userStatusOptions.map((option) => RadioListTile<String>(
              title: Text(option['text']!),
              value: option['value']!,
              groupValue: null,
              onChanged: (value) async {
                Navigator.pop(context);
                await _updateTicketStatus(ticket, userStatus: value);
              },
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showUserTicketManagementDialog(TicketModel ticket) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Gerenciar Ingresso'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingresso: ${ticket.name}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status Atual: ${ticket.displayStatus}'),
            const SizedBox(height: 16),
            Text(
              'Ações disponíveis:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          // Marcar como Pago
          if (ticket.userStatus != 'paid' && ticket.userStatus != 'used')
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _markTicketAsPaid(ticket);
              },
              icon: Icon(Icons.payment, color: Colors.green),
              label: Text('Marcar como Pago'),
              style: TextButton.styleFrom(foregroundColor: Colors.green),
            ),
          
          // Marcar como Usado
          if (ticket.userStatus == 'paid' || ticket.userStatus == 'not_paid')
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _markTicketAsUsed(ticket);
              },
              icon: Icon(Icons.check_circle, color: Colors.blue),
              label: Text('Marcar como Usado'),
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          
          // Remover Ingresso
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _showRemoveTicketConfirmation(ticket);
            },
            icon: Icon(Icons.delete, color: Colors.red),
            label: Text('Remover Ingresso'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
          
          // Cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _showRemoveTicketConfirmation(TicketModel ticket) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Remoção'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 48),
            const SizedBox(height: 16),
            Text(
              'Tem certeza que deseja remover o ingresso "${ticket.name}" deste usuário?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Esta ação não pode ser desfeita.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _removeTicketFromUser(ticket);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Remover'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateTicketStatus(
    TicketModel ticket, {
    String? status,
    String? userStatus,
  }) async {
    try {
      await TicketService.updateTicketStatus(
        ticketId: ticket.id,
        status: status,
        userStatus: userStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status atualizado com sucesso'),
          backgroundColor: Colors.green,
        ),
      );

      _loadTickets(); // Recarrega os tickets
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _markTicketAsPaid(TicketModel ticket) async {
    try {
      await TicketService.markTicketAsPaid(ticket.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresso marcado como pago com sucesso'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _loadTickets(); // Recarrega os tickets
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao marcar ingresso como pago: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _markTicketAsUsed(TicketModel ticket) async {
    try {
      await TicketService.markTicketAsUsed(ticket.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresso marcado como usado com sucesso'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _loadTickets(); // Recarrega os tickets
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao marcar ingresso como usado: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> _removeTicketFromUser(TicketModel ticket) async {
    try {
      // Torna o ticket disponível novamente removendo a associação com o usuário
      await TicketService.makeTicketAvailable(ticket.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresso removido do usuário com sucesso'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      _loadTickets(); // Recarrega os tickets
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover ingresso do usuário: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _getImageUrl(TicketModel ticket) {
    // Retorna uma imagem padrão ou baseada no evento
    return 'https://picsum.photos/300/150?random=${ticket.id.hashCode}';
  }

  Widget _buildUserTicketManagementHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withOpacity(0.1),
        border: Border.all(color: AppColors.lightBlue, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.admin_panel_settings,
                color: AppColors.lightBlue,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Gerenciamento de Ingressos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightBlue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Visualizando ingressos de um usuário específico.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Toque em um ingresso para gerenciar (marcar como pago/usado ou remover).',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Erro: $_error'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTickets,
                          child: Text('Tentar Novamente'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Header específico para admin visualizando usuário
                          if (widget.specificUserId != null && _isAdmin)
                            _buildUserTicketManagementHeader(),
                          
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
          items: const [
            {'text': 'Todos', 'value': 'all'},
            {'text': 'Válido', 'value': 'valid'},
            {'text': 'Utilizado', 'value': 'used'},
            {'text': 'Expirado', 'value': 'expired'},
            {'text': 'Não Pago', 'value': 'unpaid'},
          ],
          onChanged: (value) {
            setState(() => _selectedStatus = value!);
            _filterTickets();
          },
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
          onChanged: (value) {
            setState(() => _sortCriteria = value!);
            _filterTickets();
          },
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
    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.confirmation_number, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              widget.specificUserId != null
                  ? 'Este usuário não possui ingressos'
                  : 'Nenhum ingresso encontrado',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final ticket = _tickets[index];
        final isUserSpecificManagement = widget.specificUserId != null && _isAdmin;
        
        return GestureDetector(
          // Se é admin vendo usuário específico, usa tap; senão usa long press
          onTap: isUserSpecificManagement ? () => _showUserTicketManagementDialog(ticket) : null,
          onLongPress: (!isUserSpecificManagement && _isAdmin) ? () => _showStatusChangeDialog(ticket) : null,
          child: Container(
            decoration: isUserSpecificManagement ? BoxDecoration(
              border: Border.all(color: AppColors.lightBlue.withOpacity(0.3), width: 1),
              borderRadius: BorderRadius.circular(12),
            ) : null,
            child: Stack(
              children: [
                TicketCard(
                  date: _formatDate(ticket.createdAt),
                  title: ticket.name,
                  status: ticket.ticketCardStatus,
                  imagePath: _getImageUrl(ticket),
                ),
                // Indicador de ação disponível para admin
                if (isUserSpecificManagement)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.touch_app,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
