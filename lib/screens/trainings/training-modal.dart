import 'dart:ui';
import 'package:flutter/material.dart';

class TrainingModal extends StatelessWidget {
  final bool isSubscribed;

  const TrainingModal({super.key, this.isSubscribed = false});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Blur atrás do modal
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Modal
        Center(
          child: Padding(
            padding: const EdgeInsets.all(45),
            child: Container(
              height: screenHeight * 0.7,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 26, 47, 74),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/images/cartao.png",
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'FUTSAL FEMININO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          _infoSection(
                            icon: Icons.notes,
                            title: 'Descrição',
                            content: const Text(
                              'Sessão intensa para atletas avançados. Treino específico para resistência física e técnica',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _infoSection(
                            icon: Icons.how_to_reg,
                            title: 'Técnico',
                            content: const Text(
                              'João Vitor Carrara',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 16),

                          _infoSection(
                            icon: Icons.how_to_reg,
                            title: 'Responsável',
                            content: const Text(
                              'Emilly Tavares (43) 98817-3878',
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubscribed ? null : () {
                        // ação ao clicar
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSubscribed ? Colors.white24 : Colors.white,
                        foregroundColor: isSubscribed ? Colors.white70 : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: isSubscribed
                              ? const BorderSide(color: Colors.white54, width: 1.5)
                              : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isSubscribed) ...[
                            const Icon(Icons.check_circle_outline, color: Colors.white70),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            isSubscribed ? 'Inscrição Concluída' : 'Se Inscrever',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isSubscribed ? Colors.white70 : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),

        // Botão "X" fora do modal
        Positioned(
          bottom: 30,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text(
                    'X',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _infoSection({
  required IconData icon,
  required String title,
  required Widget content,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      content,
    ],
  );
}
