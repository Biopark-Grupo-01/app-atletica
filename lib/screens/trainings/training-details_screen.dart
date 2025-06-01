import 'dart:ui';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class TreinoDetalhesScreen extends StatelessWidget {
  const TreinoDetalhesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const iconColor = Colors.white;
    const textColor = Colors.white;
    const subTextColor = Colors.white70;

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
                        color: Colors.black.withOpacity(0.5),
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
                  const Text(
                    'UUELCOME – TUDO TE LEVA À UUELCOME',
                    style: TextStyle(
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
                        children: const [
                          Text(
                            '17/05/2025 - 16:00  →  17/05/2025 - 23:59',
                            style: TextStyle(color: Colors.white, fontSize: 14),
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
                            const Text(
                              'DE OLHO NO INSTA  -  Londrina, PR',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 2),
                            GestureDetector(
                              onTap: () {
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
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.white),
                        label: const Text('Compartilhar', style: TextStyle(color: Colors.white)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () {},
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
                  const Text(
                    'EMBARQUE NA REVOADA',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

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
                          children: const [
                            Text('TERCEIRO LOTE', style: TextStyle(color: Colors.white70)),
                            SizedBox(height: 8),
                            Text('R\$ 88,00', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text('+ taxa a partir de R\$ 8,80', style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.remove, color: Colors.white),
                            ),
                            const Text('0', style: TextStyle(color: Colors.white, fontSize: 16)),
                            IconButton(
                              onPressed: () {},
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
                          // ação ao clicar
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Comprar Agora',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black,
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
                  const Text(
                    'Não importa se é de avião, de patinete, a pé ou de carro, o nosso destino é um só.\n\n'
                    'Dia 17/05 você tem um encontro marcado com a XV na maior Cervejada do sul do país.\n'
                    'Despache suas malas, afivele seu cinto e vem com a XV nessa viagem com destino à alegria. 💙❤️🦈',
                    style: TextStyle(color: subTextColor, fontSize: 14),
                  ),

                  const SizedBox(height: 72),

                  // Faixa Etária
                  _sectionTitle(Icons.how_to_reg, 'Faixa Etária'),
                  const SizedBox(height: 16),
                  const Text(
                    'Proibido menores de 18',
                    style: TextStyle(color: subTextColor),
                  ),
                  const SizedBox(height: 24),

                  // Documentos solicitados
                  _sectionTitle(Icons.badge_outlined, 'Documentos solicitados na entrada'),
                  const SizedBox(height: 16),
                  const Text(
                    '• Documento Oficial com foto',
                    style: TextStyle(color: subTextColor),
                  ),
                  const SizedBox(height: 24),

                  // Políticas de cancelamento
                  _sectionTitle(Icons.gavel_outlined, 'Políticas de Cancelamento do Evento'),
                  const SizedBox(height: 16),
                  const Text(
                    'A solicitação de cancelamento pode ser feita em até 7 dias corridos após a compra, '
                    'desde que seja feita antes de 48 horas do início do evento.',
                    style: TextStyle(color: subTextColor),
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

