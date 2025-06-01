import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/tickets/ticket_clipper.dart';
import 'package:app_atletica/theme/app_colors.dart';

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