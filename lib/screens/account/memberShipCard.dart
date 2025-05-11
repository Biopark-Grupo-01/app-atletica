import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MembershipCardScreen extends StatefulWidget {
  const MembershipCardScreen({super.key});

  @override
  State<MembershipCardScreen> createState() => _MembershipCardScreenState();
}

class _MembershipCardScreenState extends State<MembershipCardScreen> {

  @override
  Widget build(BuildContext context) {
    // Mock user data - This would normally come from your backend
    final user = (
      name: 'Pedro Aparecido Furini',
      registration: '12345678',
      cpf: '123.456.789-01',
      email: 'pedro@gmail.com',
      validUntil: '12/34/5678',
      avatarUrl: 'https://example.com/avatar.jpg', // Replace with actual avatar URL
    );

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: const Center(
                child: Text(
                  'A.A.A.B.E',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF001835),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      // Nome + Foto
                      Column(
                        children: [
                          CircleAvatar(
                            radius: MediaQuery.of(context).size.width * 0.18, // responsivo
                            backgroundImage: NetworkImage(user.avatarUrl),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Infos do usuário com espaçamento proporcional
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoRow('Matrícula:', user.registration),
                            _buildInfoRow('CPF:', user.cpf),
                            _buildInfoRow('E-mail:', user.email),
                            _buildInfoRow('Validade:', user.validUntil),
                          ],
                        ),
                      ),

                      // Rodapé fixado embaixo
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          children: const [
                            Text(
                              'Associação Tigre Branco - 2025',
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            Text(
                              '(01/01/2025 - 31/12/2025)',
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/eventsandnews');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  _buildInfoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 18, // era 16
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              // height: 3,          // mais altur
                fontFeatures: [FontFeature.enable('smcp')], // Habilita small caps
              fontSize: 18, // era 16
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

}