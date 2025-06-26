import 'package:app_atletica/screens/account/tickets.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/ticket_model.dart';
import 'package:app_atletica/services/ticket_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventTicketsWidget extends StatefulWidget {
  final String eventId;
  final VoidCallback? onTicketPurchased;

  const EventTicketsWidget({
    super.key,
    required this.eventId,
    this.onTicketPurchased,
  });

  @override
  State<EventTicketsWidget> createState() => _EventTicketsWidgetState();
}

class _EventTicketsWidgetState extends State<EventTicketsWidget> {
  List<TicketModel> _tickets = [];
  bool _isLoading = true;
  String? _error;
  bool _isPurchasing = false;

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

      print('Carregando tickets para evento: ${widget.eventId}');
      final tickets = await TicketService.getAvailableTicketsByEvent(widget.eventId);
      print('Tickets carregados: ${tickets.length}');
      
      // Debug: imprimir detalhes dos tickets
      for (final ticket in tickets) {
        print('Ticket: ${ticket.name}, Preço: ${ticket.price}, Status: ${ticket.status}');
      }
      
      setState(() {
        _tickets = tickets;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar tickets: $e');
      setState(() {
        _error = 'Erro ao carregar ingressos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _purchaseTicket(TicketModel ticket) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = userProvider.currentUser;
    
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você precisa estar logado para comprar ingressos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isPurchasing = true;
    });

    try {
      // Usa o método completo de compra que reserva e compra em uma operação
      await TicketService.purchaseTicket(ticket.id, currentUser.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ingresso comprado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Recarrega a lista de tickets
      _loadTickets();
      
      // Notifica o widget pai se necessário
      if (widget.onTicketPurchased != null) {
        widget.onTicketPurchased!();
      }
      final user = userProvider.currentUser!;

      // Navega para a tela de ingressos do usuário com indicação de compra recente
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => TicketsScreen(specificUserId: user.id),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao comprar ingresso: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isPurchasing = false;
      });
    }
  }

  void _showTicketDetails(TicketModel ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ticket.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Descrição: ${ticket.description}'),
            const SizedBox(height: 8),
            Text(
              'Preço: R\$ ${ticket.price.toStringAsFixed(2).replaceAll('.', ',')}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text('Status: ${ticket.statusFormatted}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
          if (ticket.isAvailable) ...[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Redireciona para WhatsApp ou contato da atlética
                _buyWithAtletica(ticket);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text('Comprar com a Atlética'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isPurchasing
                  ? null
                  : () {
                      Navigator.pop(context);
                      _purchaseTicket(ticket);
                    },
              child: _isPurchasing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('Comprar pelo App'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _buyWithAtletica(TicketModel ticket) async {
    // Aqui você pode implementar a lógica para redirecionar para WhatsApp
    // ou mostrar informações de contato da atlética
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Comprar com a Atlética'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Para comprar este ingresso com a atlética, entre em contato:'),
            const SizedBox(height: 16),
            Text('• WhatsApp: (11) 99999-9999'),
            Text('• Email: contato@atleticatigrebranco.com'),
            const SizedBox(height: 16),
            Text('Ingresso: ${ticket.name}'),
            Text('Preço: ${_formatPrice(ticket.price)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _openWhatsApp(
                context,
                ticket.name,
                ticket.price.toStringAsFixed(2).replaceAll('.', ','),
                1, // Quantidade fixa de 1 para compra via atlética
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: Text('Abrir WhatsApp'),
          ),
        ],
      ),
    );
  }
  
  void _openWhatsApp(BuildContext context, String title, String price, int quantity) async {
    // Número do WhatsApp da atlética (substitua pelo número real)
    const String phoneNumber = '5544999719743'; // Formato: código do país + DDD + número
    
    // Calcula o valor total
    final double unitPrice = double.tryParse(price.replaceAll(',', '.')) ?? 0.0;
    final double totalPrice = unitPrice * quantity;
    final String formattedTotalPrice = totalPrice.toStringAsFixed(2).replaceAll('.', ',');
    
    // Mensagem personalizada
    final String message = '''
Olá! 👋

Gostaria de comprar ingresso(s) para o evento:

🎉 *$title*
🎫 Quantidade: $quantity ingresso${quantity > 1 ? 's' : ''}
💰 Valor unitário: R\$ $price
💰 Valor total: R\$ $formattedTotalPrice

Poderia me ajudar com a compra? 😊
    '''.trim();

    // URL encode da mensagem
    final String encodedMessage = Uri.encodeComponent(message);
    
    // URLs para WhatsApp
    final String whatsappUrl = 'whatsapp://send?phone=$phoneNumber&text=$encodedMessage';
    final String whatsappWebUrl = 'https://wa.me/$phoneNumber?text=$encodedMessage';
    
    try {
      // Tenta abrir o app do WhatsApp primeiro
      await launchUrl(Uri.parse(whatsappUrl));
    } catch (e) {
      // Se falhar, tenta abrir no WhatsApp Web
      try {
        await launchUrl(
          Uri.parse(whatsappWebUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (e2) {
        // Se ambos falharem, mostra mensagem de erro
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o WhatsApp'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatPrice(double price) {
    return 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Erro ao carregar ingressos: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTickets,
              child: Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.confirmation_number_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Nenhum ingresso disponível para este evento',
              style: TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ingressos Disponíveis',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _tickets.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ticket = _tickets[index];
            return _buildTicketCard(ticket);
          },
        ),
      ],
    );
  }

  Widget _buildTicketCard(TicketModel ticket) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ticket.isAvailable ? AppColors.yellow : Colors.grey,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                _formatPrice(ticket.price),
                style: TextStyle(
                  fontSize: 18,
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
              Expanded(
                child: Text(
                  'Status: ${ticket.statusFormatted}',
                  style: TextStyle(
                    color: ticket.isAvailable ? Colors.green : Colors.orange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (ticket.isAvailable) ...[
                ElevatedButton(
                  onPressed: () => _buyWithAtletica(ticket),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: Text(
                    'Atlética',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                ElevatedButton(
                  onPressed: _isPurchasing ? null : () => _purchaseTicket(ticket),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    foregroundColor: AppColors.black,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  child: _isPurchasing
                      ? SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'App',
                          style: TextStyle(fontSize: 12),
                        ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => _showTicketDetails(ticket),
                  child: Text(
                    'Detalhes',
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
