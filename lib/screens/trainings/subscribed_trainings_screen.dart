import 'package:flutter/material.dart';
import 'package:app_atletica/services/training_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/screens/trainings/training-modal.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class SubscribedTrainingsScreen extends StatefulWidget {
  const SubscribedTrainingsScreen({super.key});

  @override
  State<SubscribedTrainingsScreen> createState() => _SubscribedTrainingsScreenState();
}

class _SubscribedTrainingsScreenState extends State<SubscribedTrainingsScreen> {
  final TrainingService _trainingService = TrainingService();
  List<Map<String, dynamic>> _trainings = [];
  bool _isLoading = true;
  String? _error;
  List<String> _subscribedIds = [];
  List<Map<String, String>> _userSubscriptions = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  Future<void> _loadTrainings({bool preserveScroll = false}) async {
    setState(() {
      _isLoading = !preserveScroll;
      _error = null;
    });
    try {
      // Substitua pelo id real do usuário logado
      const userId = '3e66159f-efaa-4c74-8bce-51c1fef3622e';
      final trainings = await _trainingService.getUserSubscriptions(userId);
      setState(() {
        _trainings = trainings;
        _subscribedIds = trainings.map((t) => t['training']['id'] as String).toList();
        _userSubscriptions = trainings.map((sub) => {
          'trainingId': sub['training']['id'] as String,
          'subscriptionId': sub['id'] as String,
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar treinos: $e';
        _isLoading = false;
      });
    }
  }

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return rawDate;
    }
  }

  void showTrainingModal(
    BuildContext context,
    Training training,
    List<String> _subscribedIds,
    Future<void> Function({bool preserveScroll}) _loadData,
    ScrollController _scrollController, {
    String? subscriptionId,
  }) async {
    final double currentScrollOffset = _scrollController.offset;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (_) => TrainingModal(
        training: training,
        isSubscribed: _subscribedIds.contains(training.id),
        subscriptionId: subscriptionId,
        onClose: () async {
          await _loadData(preserveScroll: true);
        },
      ),
    ).then((_) async {
      await _loadData(preserveScroll: true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(currentScrollOffset);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treinos Inscritos'),
        backgroundColor: AppColors.blue,
      ),
      backgroundColor: AppColors.blue,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.white)))
              : _trainings.isEmpty
                  ? const Center(child: Text('Nenhum treino inscrito.', style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _trainings.length,
                      itemBuilder: (context, index) {
                        final trainingJson = _trainings[index]['training'];
                        final training = Training.fromJson(trainingJson);
                        final sub = _userSubscriptions.firstWhereOrNull((sub) => sub['trainingId'] == training.id);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: GestureDetector(
                            onTap: () {
                              showTrainingModal(
                                context,
                                training,
                                _subscribedIds,
                                _loadTrainings,
                                _scrollController,
                                subscriptionId: sub != null ? sub['subscriptionId'] : null,
                              );
                            },
                            child: Container(
                              child: _buildEventCard(
                                training.title,
                                training.description,
                                formatDate(training.date),
                                training.place,
                                training.modality.toUpperCase(),
                                true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }

  Widget _buildEventCard(String title, String description, String date, String location, String category, bool isSubscribed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSubscribed ? const Color(0xFF1E88E5).withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: isSubscribed ? Border.all(color: const Color(0xFF42A5F5), width: 2) : null,
        boxShadow: isSubscribed
            ? [
                BoxShadow(
                  color: const Color(0xFF42A5F5).withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(date, style: const TextStyle(color: Colors.white, fontSize: 14)),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isSubscribed ? Colors.greenAccent : const Color(0xFFFFD700),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isSubscribed ? "INSCRITO" : category,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: isSubscribed ? Colors.greenAccent : const Color(0xFFFFD700),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
