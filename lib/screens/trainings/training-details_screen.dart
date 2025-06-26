import 'dart:ui';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class TreinoDetalhesScreen extends StatefulWidget {
  const TreinoDetalhesScreen({super.key});

  @override
  State<TreinoDetalhesScreen> createState() => _TreinoDetalhesScreenState();
}

class _TreinoDetalhesScreenState extends State<TreinoDetalhesScreen> {
  int _ticketQuantity = 0; // Quantidade de ingressos selecionados

  String _calculateTotalPrice(String unitPrice, int quantity) {
    final double price = double.tryParse(unitPrice.replaceAll(',', '.')) ?? 0.0;
    final double total = price * quantity;
    return total.toStringAsFixed(2).replaceAll('.', ',');
  }

  String _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '17/05/2025 - 16:00';
    }
    
    try {
      // Parse da data ISO 8601
      final DateTime dateTime = DateTime.parse(dateStr);
      
      // Formatação da data (dd/MM/yyyy) e hora (HH:mm)
      final String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
      final String formattedTime = DateFormat('HH:mm').format(dateTime);
      
      return '$formattedDate - $formattedTime';
    } catch (e) {
      // Se falhar, retorna o valor original ou padrão
      return dateStr.isNotEmpty ? dateStr : '17/05/2025 - 16:00';
    }
  }

  void _shareEvent(String title, String formattedDate, String location, String description, String price) {
    final String shareText = '''
🎉 *$title*

📅 Data: $formattedDate
📍 Local: $location
💰 Ingresso: R\$ $price

📋 Descrição:
$description

Vem com a gente! 🔥
    '''.trim();

    Share.share(
      shareText,
      subject: title,
    );
  }

  void _openInstagram(BuildContext context) async {
    const String instagramAppUrl = 'instagram://user?username=tigrebrancodnz';
    const String instagramWebUrl = 'https://www.instagram.com/tigrebrancodnz/';
    
    try {
      // Tenta abrir o app do Instagram primeiro
      await launchUrl(Uri.parse(instagramAppUrl));
    } catch (e) {
      // Se falhar, tenta abrir no navegador
      try {
        await launchUrl(
          Uri.parse(instagramWebUrl),
          mode: LaunchMode.externalApplication,
        );
      } catch (e2) {
        // Se ambos falharem, mostra mensagem de erro
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não foi possível abrir o Instagram'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _openWhatsApp(BuildContext context, String title, String formattedDate, String location, String price, int quantity) async {
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
📅 Data: $formattedDate
📍 Local: $location
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

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const subTextColor = Colors.white70;

    // Recebe os dados do evento via arguments
    final Map<String, String> eventData = 
        ModalRoute.of(context)?.settings.arguments as Map<String, String>? ?? {};
    
    final String title = eventData['title'] ?? 'UUELCOME – TUDO TE LEVA À UUELCOME';
    final String date = eventData['date'] ?? '17/05/2025';
    final String formattedDate = _formatDateTime(eventData['date']);
    print('Valor de date: $date');
    print('Valor formatado: $formattedDate');
    final String location = eventData['location'] ?? 'DE OLHO NO INSTA  -  Londrina, PR';
    final String description = eventData['description'] ?? 'Não importa se é de avião, de patinete, a pé ou de carro, o nosso destino é um só.\n\nDia 17/05 você tem um encontro marcado com a XV na maior Cervejada do sul do país.\nDespache suas malas, afivele seu cinto e vem com a XV nessa viagem com destino à alegria. 💙❤️🦈';
    final String price = eventData['price'] ?? '88,00';

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF001835),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/cartao.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_today_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          SizedBox(height: 2),
                          Text(
                            '(Horário de Brasília)',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location,
                              style: const TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(ClipboardData(text: location));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Endereço copiado!')),
                                );
                              },
                              child: const Text(
                                'Copiar Endereço',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.bookmark_border, color: Colors.white),
                      label: const Text('Marcar interesse', style: TextStyle(color: Colors.white)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.people_outline, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '2473 pessoas marcaram interesse',
                          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )
                    ]
                  ),

                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          _shareEvent(title, formattedDate, location, description, price);
                        },
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text('Compartilhar', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          _openInstagram(context);
                        },
                        icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                        label: const Text('Instagram', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                        
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    'Ingressos',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // const Text(
                  //   'EMBARQUE NA REVOADA',
                  //   style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  // ),
                  // const SizedBox(height: 8),

                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(128, 52, 90, 167),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PRIMEIRO LOTE', style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 8),
                            Text('R\$ $price', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            // const Text('+ taxa a partir de R\$ 8,80', style: TextStyle(color: Colors.white54, fontSize: 12)),
                            if (_ticketQuantity > 0) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Total: R\$ ${_calculateTotalPrice(price, _ticketQuantity)}',
                                style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_ticketQuantity > 0) {
                                    _ticketQuantity--;
                                  }
                                });
                              },
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                            Text('$_ticketQuantity', style: const TextStyle(color: Colors.white, fontSize: 16)),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _ticketQuantity++;
                                });
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_ticketQuantity > 0) {
                            _openWhatsApp(context, title, formattedDate, location, price, _ticketQuantity);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Selecione ao menos 1 ingresso para comprar'),
                                backgroundColor: Colors.orange,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _ticketQuantity > 0 ? Colors.white : Colors.grey.shade300,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, color: _ticketQuantity > 0 ? Colors.black : const Color.fromARGB(169, 0, 0, 0)),
                            const SizedBox(width: 8),
                            Text(
                              'Comprar Agora',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: _ticketQuantity > 0 ? Colors.black : Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),                    
                  ),

                  // const SizedBox(height: 16),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Color(0xff292929),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: const [
                  //       Row(
                  //         children: [
                  //           Icon(Icons.receipt_long, color: Colors.redAccent, size: 20),
                  //           SizedBox(width: 8),
                  //           Expanded(
                  //             child: Text(
                  //               'Taxas aplicadas ao pagar com Pix, cartão de crédito ou boleto',
                  //               style: TextStyle(color: Colors.white, fontSize: 13),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       SizedBox(height: 12),
                  //       Text(
                  //         '🔻 Metade da taxa com o clube',
                  //         style: TextStyle(color: Colors.redAccent, fontSize: 14, fontWeight: FontWeight.bold),
                  //       ),
                  //     ],
                  //   ),
                  // ),


                  const SizedBox(height: 36),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color.fromARGB(128, 52, 90, 167), width: 0.5),
                        bottom: BorderSide(color: Color.fromARGB(128, 52, 90, 167), width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            "assets/images/emblema.png",
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Organizado por',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'Associação Atlética Tigre Branco',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),





                  const SizedBox(height: 24),

                  // Descrição do Evento
                  _sectionTitle(Icons.notes, 'Descrição do Evento'),
                  const SizedBox(height: 24),
                  Text(
                    description,
                    style: const TextStyle(color: subTextColor, fontSize: 14),
                  ),

                  const SizedBox(height: 72),

                  // Faixa Etária
                  _sectionTitle(Icons.how_to_reg, 'Faixa Etária'),
                  const SizedBox(height: 16),
                  const Text(
                    'Proibido menores de 18',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // Documentos solicitados
                  _sectionTitle(Icons.badge_outlined, 'Documentos solicitados na entrada'),
                  const SizedBox(height: 16),
                  const Text(
                    '• Documento Oficial com foto',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // Políticas de cancelamento
                  _sectionTitle(Icons.gavel_outlined, 'Políticas de Cancelamento do Evento'),
                  const SizedBox(height: 16),
                  const Text(
                    'A solicitação de cancelamento pode ser feita em até 7 dias corridos após a compra, '
                    'desde que seja feita antes de 48 horas do início do evento.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3 
      ),
    );
  }
}

Widget _sectionTitle(IconData icon, String title) {
  return Row(
    children: [
      Icon(icon, color: Colors.white),
      const SizedBox(width: 8),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    ],
  );
}

