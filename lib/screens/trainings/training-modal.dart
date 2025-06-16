import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingModal extends StatelessWidget {
  final bool isSubscribed;
  final String? subscriptionId;
  final void Function()? onClose;

  const TrainingModal({
    super.key, 
    this.isSubscribed = false
  });

  @override
  State<TrainingModal> createState() => _TrainingModalState();
}

class _TrainingModalState extends State<TrainingModal> {
  bool _loading = false;
  bool _subscribed = false;

  final _service = TrainingService();

  @override
  void initState() {
    super.initState();
    _subscribed = widget.isSubscribed;
  }

  Future<void> _handleSubscribe() async {
    setState(() => _loading = true);
    final success = await _service.subscribeToTraining(widget.training.id, '3e66159f-efaa-4c74-8bce-51c1fef3622e');
    setState(() {
      _loading = false;
      if (success) _subscribed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Blur background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Modal content
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Training image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/images/cartao.png",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(top: 12, left: 2, right: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    formatDate(training.date),
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.place, color: Colors.white70, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    training.place,
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            training.modality.toUpperCase(),
                            style: const TextStyle(
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
                            'Treino preparatório para o campeonato',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoSection(
                          icon: Icons.how_to_reg,
                          title: 'Técnico',
                          content: const Text(
                            'João Silva',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _infoSection(
                          icon: Icons.person,
                          title: 'Responsável',
                          content: Text(
                            training.responsible,
                            style: const TextStyle(color: Colors.white70),
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
                      onPressed: isSubscribed ? null : () {},
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
                      child: _loading
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_subscribed) ...[
                                  const Icon(Icons.check_circle_outline, color: Colors.white70),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  _subscribed ? 'Inscrição Concluída' : 'Se Inscrever',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _subscribed ? Colors.white70 : Colors.black,
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

        // Close button
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
}
