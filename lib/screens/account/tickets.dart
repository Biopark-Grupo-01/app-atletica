import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final List<Map<String, String>> tickets = [
    {'date': '15/03/2025', 'title': 'Festa de Abertura', 'status': 'Ativo', 'imagePath': 'https://picsum.photos/300/150'},
    {'date': '16/04/2025', 'title': 'Competição de Atletismo', 'status': 'Utilizado', 'imagePath': 'https://picsum.photos/301/150'},
    {'date': '17/05/2025', 'title': 'Show de Talentos', 'status': 'Utilizado', 'imagePath': 'https://picsum.photos/302/150'},
    {'date': '18/06/2025', 'title': 'Corrida Noturna', 'status': 'Ativo', 'imagePath': 'https://picsum.photos/303/150'},
    {'date': '19/07/2025', 'title': 'Feira Gastronômica', 'status': 'Ativo', 'imagePath': 'https://picsum.photos/304/150'},
    {'date': '20/08/2025', 'title': 'Encerramento com Banda', 'status': 'Ativo', 'imagePath': 'https://picsum.photos/305/150'},
  ];

  String _searchQuery = '';
  String _selectedStatus = 'Ativo';

  @override
  Widget build(BuildContext context) {
    final filteredTickets = tickets.where((ticket) {
      final matchesTitle = ticket['title']!.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus = _selectedStatus == 'Todos' || ticket['status']!.toLowerCase() == _selectedStatus.toLowerCase();
      return matchesTitle && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: const [
                    Divider(color: Color(0xFFFFD700), thickness: 1, indent: 32, endIndent: 32),
                    SizedBox(height: 8),
                    Text(
                      'INGRESSOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Color(0xFFFFD700), thickness: 1, indent: 32, endIndent: 32),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF003366),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Buscar evento',
                      hintStyle: const TextStyle(color: Colors.white70),
                      prefixIcon: const Icon(Icons.search, color: Colors.white70),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    decoration: BoxDecoration(
                      color: const Color(0xFF003366),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SizedBox(
                      height: 36,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          value: _selectedStatus,
                          dropdownColor: const Color(0xFF003366),
                          style: const TextStyle(color: Colors.white),
                          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                          items: ['Todos', 'Ativo', 'Utilizado']
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: filteredTickets.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final ticket = filteredTickets[index];
                  return TicketCard(
                    date: ticket['date']!,
                    title: ticket['title']!,
                    status: ticket['status']!,
                    imagePath: ticket['imagePath']!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4, onTap: (index) {
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
      }),
    );
  }
}

class TicketCard extends StatelessWidget {
  final String date;
  final String title;
  final String status;
  final String imagePath;

  const TicketCard({super.key, required this.date, required this.title, required this.status, required this.imagePath});

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
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFFD700) : const Color(0xFFFFD700).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageWidth,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(date, style: TextStyle(color: Colors.grey[900], fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 4),
                      Text(status, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
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

    final base = Path()
      ..moveTo(0, cornerRadius)
      ..quadraticBezierTo(0, 0, cornerRadius, 0)
      ..lineTo(size.width - cornerRadius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, cornerRadius)
      ..lineTo(size.width, size.height / 2 - cornerRadius)
      ..arcToPoint(Offset(size.width, size.height / 2 + cornerRadius), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(size.width, size.height - cornerRadius)
      ..quadraticBezierTo(size.width, size.height, size.width - cornerRadius, size.height)
      ..lineTo(cornerRadius, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - cornerRadius)
      ..close();

    final topCut = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(imageWidth, 0), width: notchWidth, height: notchHeight), const Radius.circular(4)));
    final bottomCut = Path()
      ..addRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(imageWidth, size.height), width: notchWidth, height: notchHeight), const Radius.circular(4)));

    return Path.combine(PathOperation.difference, Path.combine(PathOperation.difference, base, topCut), bottomCut);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}