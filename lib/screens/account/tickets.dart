import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  State<TicketsScreen> createState() => _TicketsScreenState();
}

class _TicketsScreenState extends State<TicketsScreen> {
  final List<Map<String, String>> tickets = [
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

  String _searchQuery = '';
  String _selectedStatus = 'valid';
  String _sortCriteria = 'date'; // 'date', 'title', 'added'

  @override
  Widget build(BuildContext context) {
    final filteredTickets =
        tickets.where((ticket) {
          final matchesTitle = ticket['title']!.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
          final matchesStatus =
              _selectedStatus == 'all' ||
              ticket['status']!.toLowerCase() == _selectedStatus.toLowerCase();
          return matchesTitle && matchesStatus;
        }).toList();

    filteredTickets.sort((a, b) {
      switch (_sortCriteria) {
        case 'title':
          return a['title']!.compareTo(b['title']!);
        case 'added':
          // Como os ingressos estão em ordem de adição no array original,
          // manteremos a ordem original — ou inverteremos, se quiser ordem reversa
          return tickets.indexOf(b).compareTo(tickets.indexOf(a));
        case 'date':
        default:
          final dateFormat = RegExp(r'(\d{2})/(\d{2})/(\d{4})');
          final aMatch = dateFormat.firstMatch(a['date']!);
          final bMatch = dateFormat.firstMatch(b['date']!);
          if (aMatch != null && bMatch != null) {
            final aDate = DateTime(
              int.parse(aMatch.group(3)!),
              int.parse(aMatch.group(2)!),
              int.parse(aMatch.group(1)!),
            );
            final bDate = DateTime(
              int.parse(bMatch.group(3)!),
              int.parse(bMatch.group(2)!),
              int.parse(bMatch.group(1)!),
            );
            return aDate.compareTo(bDate);
          }
          return 0;
      }
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Container(
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
                        style: const TextStyle(color: AppColors.lightGrey),
                        decoration: InputDecoration(
                          hintText: 'Buscar evento',
                          hintStyle: const TextStyle(
                            color: AppColors.lightGrey,
                          ),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.lightGrey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    CustomTitle(title: 'INGRESSOS'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Dropdown de Status
                        Container(
                          width: 130,
                          height: 50,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF003366),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                          menuWidth: 135,
                              isDense: true,
                              value: _selectedStatus,
                              dropdownColor: const Color(0xFF003366),
                              style: const TextStyle(color: AppColors.white),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                color: AppColors.white,
                              ),
                              items:
                                  [
                                        {'text': 'Todos', 'value': 'all'},
                                        {'text': 'Válido', 'value': 'valid'},
                                        {'text': 'Utilizado', 'value': 'used'},
                                        {
                                          'text': 'Expirado',
                                          'value': 'expired',
                                        },
                                        {'text': 'Não Pago', 'value': 'unpaid'},
                                      ]
                                      .map(
                                        (status) => DropdownMenuItem(
                                          value: status['value'],
                                          child: Text(status['text']!),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedStatus = value!;
                                });
                              },
                            ),
                          ),
                        ),

                        // Dropdown de Ordenação
                        Container(
                          width: 150,
                          height: 50,
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF003366),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              menuWidth: 155,
                              isDense: true,
                              value: _sortCriteria,
                              dropdownColor: const Color(0xFF003366),
                              style: const TextStyle(color: AppColors.white),
                              icon: const Icon(
                                Icons.sort,
                                color: AppColors.white,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'date',
                                  child: Text('Data'),
                                ),
                                DropdownMenuItem(
                                  value: 'title',
                                  child: Text('A-Z'),
                                ),
                                DropdownMenuItem(
                                  value: 'added',
                                  child: Text('Mais Recente'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _sortCriteria = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
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
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
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
  final String imagePath;

  const TicketCard({
    super.key,
    required this.date,
    required this.title,
    required this.status,
    required this.imagePath,
  });

  bool get isValid => status.toLowerCase() == 'valid';

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width * 0.55;
    return SizedBox(
      height: imageSize * 0.6,
      width: double.infinity,
      child: ClipPath(
        clipper: TicketClipper(imageWidth: imageSize),
        child: Container(
          decoration: BoxDecoration(
            color: getTicketColor(status),
            borderRadius: BorderRadius.circular(12),
            border:
                (status == 'valid' || status == 'unpaid')
                    ? Border.all(
                      color: AppColors.white, // cor da borda com base no status
                      width: 2,
                    )
                    : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: imageSize,
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
                        style: TextStyle(
                          color: AppColors.darkGrey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        traduzirStatus(status),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
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

    return Path.combine(
      PathOperation.difference,
      Path.combine(PathOperation.difference, base, topCut),
      bottomCut,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

String traduzirStatus(String status) {
  switch (status.toLowerCase()) {
    case 'valid':
      return 'Válido';
    case 'used':
      return 'Utilizado';
    case 'expired':
      return 'Expirado';
    case 'unpaid':
      return 'Não Pago';
    default:
      return status; // Fallback para casos desconhecidos
  }
}

Color getTicketColor(String status) {
  switch (status.toLowerCase()) {
    case 'valid':
      return AppColors.yellow;
    case 'used':
      return Colors.blueGrey.shade300;
    case 'expired':
      return const Color.fromARGB(255, 163, 134, 30);
    case 'unpaid':
      return AppColors.lightGrey;
    default:
      return AppColors.blue;
  }
}
