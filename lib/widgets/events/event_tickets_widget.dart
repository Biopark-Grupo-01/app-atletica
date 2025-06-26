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

  Future<void> _purchaseFirstAvailable() async {
    if (_tickets.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não há ingressos disponíveis'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Pega o primeiro ticket disponível
    final firstAvailable = _tickets.first;
    await _purchaseTicket(firstAvailable);
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Ingressos Disponíveis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_tickets.length} disponíveis',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_tickets.isNotEmpty) ...[
          _buildTicketTypeCard(_tickets.first), // Mostra apenas o primeiro tipo (todos têm mesmo preço/descrição)
        ],
      ],
    );
  }

  Widget _buildTicketTypeCard(TicketModel sampleTicket) {
    final availableCount = _tickets.length;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: availableCount > 0 ? AppColors.yellow : Colors.grey,
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
                  sampleTicket.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
              Text(
                _formatPrice(sampleTicket.price),
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
            sampleTicket.description,
            style: TextStyle(
              color: AppColors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: availableCount > 0 ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: availableCount > 0 ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Text(
              availableCount > 0 ? '$availableCount ingressos disponíveis' : 'Esgotado',
              style: TextStyle(
                color: availableCount > 0 ? Colors.green : Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (availableCount > 0) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _buyWithAtletica(sampleTicket),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, size: 16),
                        const SizedBox(width: 8),
                        Text('Comprar com a Atlética'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isPurchasing ? null : () => _purchaseFirstAvailable(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.yellow,
                      foregroundColor: AppColors.black,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isPurchasing
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.smartphone, size: 16),
                              const SizedBox(width: 8),
                              Text('Comprar pelo App'),
                            ],
                          ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Ingressos Esgotados',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
