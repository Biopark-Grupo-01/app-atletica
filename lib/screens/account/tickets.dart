import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {

  @override
  Widget build(BuildContext context) {
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

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  const Divider(
                    color: Color(0xFFFFD700),
                    thickness: 1,
                    indent: 32,
                    endIndent: 32,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'INGRESSOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Color(0xFFFFD700),
                    thickness: 1,
                    indent: 32,
                    endIndent: 32,
                  ),
                ],
              ),
            ),

            // Tickets List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  const TicketCard(
                    date: "10/04/2025",
                    title: "Título Evento",
                    status: "Ativo",
                  ),

                  SizedBox(height: 16),
                  const TicketCard(
                    date: "10/04/2025",
                    title: "Título Evento",
                    status: "Utilizado",
                  ),
                  SizedBox(height: 16),
                  const TicketCard(
                    date: "10/04/2025",
                    title: "Título Evento",
                    status: "Inativo",
                  ),
                  SizedBox(height: 16),
                  const TicketCard(
                    date: "10/04/2025",
                    title: "Título Evento",
                    status: "Ativo",
                  ),
                ],
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
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
class TicketCard extends StatelessWidget {
  final String date;
  final String title;
  final String status;

  const TicketCard({
    super.key,
    required this.date,
    required this.title,
    required this.status,
  });

  bool get isActive => status.toLowerCase() == 'ativo';

  @override
  Widget build(BuildContext context) {
    const double imageWidth = 160;

    return SizedBox(
      height: 120,
      width: double.infinity,
      child: ClipPath(
        clipper: TicketClipper(imageWidth: imageWidth),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0), // ❗ deixar aqui
          decoration: BoxDecoration(
            color:
                isActive
                    ? const Color(0xFFFFD700)
                    : const Color(0xFFFFD700).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isActive ? Colors.white : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: TextStyle(color: Colors.grey[900], fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  final double imageWidth;

  TicketClipper({required this.imageWidth});

  @override
  Path getClip(Size size) {
    const double cornerRadius = 12;
    const double notchWidth = 8;
    const double notchHeight = 16;

    // Caminho principal do cartão
    final base =
        Path()
          ..moveTo(0, cornerRadius)
          ..quadraticBezierTo(0, 0, cornerRadius, 0)
          ..lineTo(size.width - cornerRadius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
          ..lineTo(size.width, size.height / 2 - cornerRadius)
          ..arcToPoint(
            Offset(size.width, size.height / 2 + cornerRadius),
            radius: const Radius.circular(cornerRadius),
            clockwise: false,
          )
          ..lineTo(size.width, size.height - cornerRadius)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - cornerRadius,
            size.height,
          )
          ..lineTo(cornerRadius, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - cornerRadius)
          ..close();

    // Recortes internos em formato de "retângulo redondo"
    final topCut =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(imageWidth, 0),
              width: notchWidth,
              height: notchHeight,
            ),
            const Radius.circular(4),
          ),
        );

    final bottomCut =
        Path()..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(imageWidth, size.height),
              width: notchWidth,
              height: notchHeight,
            ),
            const Radius.circular(4),
          ),
        );

    // Subtrai os recortes do cartão principal
    final result = Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, base, topCut),
      bottomCut,
    );

    return result;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}