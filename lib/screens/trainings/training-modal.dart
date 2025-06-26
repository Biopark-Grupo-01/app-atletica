import 'package:app_atletica/models/match_model.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:app_atletica/services/training_service.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingModal extends StatefulWidget  {
  final Training? training;
  final Match? match;
  final bool isSubscribed;
  final String? subscriptionId;
  final void Function()? onClose;

  const TrainingModal({
    super.key,
    this.training,
    this.match,
    this.isSubscribed = false,
    this.subscriptionId,
    this.onClose,
  }) : assert(training != null || match != null);

  @override
  State<TrainingModal> createState() => _TrainingModalState();
}

class _TrainingModalState extends State<TrainingModal> {
  bool _loading = false;
  bool _subscribed = false;

  final _service = TrainingService();

  late final UserProvider userProvider;
  late final user;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentUser;
    _subscribed = widget.isSubscribed;
  }

  Future<void> _handleSubscribe() async {
    setState(() => _loading = true);
    final success = await _service.subscribeToTraining(widget.training!.id, user.id);
    setState(() {
      _loading = false;
      if (success) _subscribed = true;
    });
  }

  Future<void> _handleUnsubscribe() async {
    setState(() => _loading = true);
    if (widget.subscriptionId == null) {
      setState(() { _loading = false; });
      return;
    }
    final success = await _service.unsubscribeFromTraining(widget.subscriptionId!);
    setState(() {
      _loading = false;
      if (success) _subscribed = false;
    });
  }

   String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTraining = widget.training != null;
    final screenHeight = MediaQuery.of(context).size.height;
    bool disableUnsubscribe = false;
    if (isTraining && _subscribed) {
      try {
        final trainingDate = DateTime.parse(widget.training!.date);
        disableUnsubscribe = trainingDate.isBefore(DateTime.now());
      } catch (_) {}
    }

    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
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
                          Padding(
                            padding: const EdgeInsets.only(top: 12, left: 2, right: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                    isTraining
                                      ? "${formatDate(widget.training!.date)} • ${widget.training!.time.substring(0, 5)}"
                                      : "${formatDate(widget.match!.date)} • ${widget.match!.time.substring(0, 5)}",
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              isTraining ? widget.training!.title.toUpperCase() : widget.match!.title.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isTraining)
                            _infoSection(
                              icon: Icons.how_to_reg,
                              title: 'Técnico',
                              content: Text(
                                (widget.training!.coach.isNotEmpty)
                                    ? widget.training!.coach
                                    : 'A definir...',
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ),
                          if (isTraining) const SizedBox(height: 16),
                          _infoSection(
                            icon: Icons.how_to_reg,
                            title: 'Responsável',
                            content: Text(
                              (isTraining ? widget.training!.responsible : widget.match!.responsible).isNotEmpty
                                  ? (isTraining ? widget.training!.responsible : widget.match!.responsible)
                                  : 'A definir...',
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _infoSection(
                            icon: Icons.place,
                            title: 'Local',
                            content: Text(
                              isTraining ? widget.training!.place : widget.match!.place,
                              style: const TextStyle(color: Colors.white70),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _infoSection(
                            icon: Icons.notes,
                            title: 'Descrição',
                            content: Text(
                              (isTraining ? widget.training!.description : widget.match!.description).isNotEmpty
                                  ? (isTraining ? widget.training!.description : widget.match!.description)
                                  : 'A definir...',
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isTraining) ...[
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _subscribed || _loading ? null : _handleSubscribe,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _subscribed ? Colors.white24 : Colors.white,
                          foregroundColor: _subscribed ? Colors.white70 : Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: _subscribed
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
                    if (_subscribed) ...[
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: (_loading || disableUnsubscribe) ? null : _handleUnsubscribe,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400], // quando habilitado
                            disabledBackgroundColor: const Color.fromARGB(149, 239, 83, 80),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Cancelar Inscrição',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                  if (!isTraining) ...[
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Para participar deste amistoso, entre em contato com o responsável.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],
              ),
            ),
          ),
        ),
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
