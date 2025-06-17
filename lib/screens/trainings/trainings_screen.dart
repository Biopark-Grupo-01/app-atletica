import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/screens/trainings/expandable_text.dart';
import 'package:app_atletica/screens/trainings/training-modal.dart';
import 'package:app_atletica/services/training_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import 'package:intl/intl.dart';

class TrainingsScreen extends StatefulWidget {
  const TrainingsScreen({super.key});

  @override
  State<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  final TrainingService _trainingService = TrainingService();
  List<Training> _trainings = [];
  List<String> _subscribedIds = [];
  List<Map<String, String>> _userSubscriptions = [];
  bool _isLoading = true;
  String? _error;

  int _selectedTabIndex = 0;
  List<String> _selectedCategories = [];

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _modalities = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadModalities();
  }

  Future<void> _loadData({bool preserveScroll = false}) async {
    if (!preserveScroll) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    try {
      const userId = '3e66159f-efaa-4c74-8bce-51c1fef3622e';
      final userSubscriptions = await _trainingService.getUserSubscriptions(userId);
      final trainings = await _trainingService.getTrainings();
      setState(() {
        _userSubscriptions = userSubscriptions.map((sub) => {
          'trainingId': sub['training']['id'] as String,
          'subscriptionId': sub['id'] as String,
        }).toList();
        _subscribedIds = _userSubscriptions.map((sub) => sub['trainingId']!).toList();
        _trainings = trainings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar os eventos: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadModalities() async {
    final modalities = await _trainingService.getTrainingModalities();
    setState(() {
      _modalities = modalities;
    });
  }

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return rawDate; // Retorna como está se der erro
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = _trainings.where((event) {
      final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(event.modality.toUpperCase());
      return matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      appBar: CustomAppBar(),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFFD700)))
            : _error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView(
                    controller: _scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: SizedBox(
                          height: 100,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.only(left: 16),
                            itemCount: _modalities.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 20),
                            itemBuilder: (context, index) {
                              final modality = _modalities[index];
                              final isLast = index == _modalities.length - 1;
                              final isSelected = _selectedCategories.contains(modality['name'].toString().toUpperCase());

                              return Padding(
                                padding: EdgeInsets.only(right: isLast ? 16 : 0),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () {
                                      setState(() {
                                        final category = modality['name'].toString().toUpperCase();
                                        if (_selectedCategories.contains(category)) {
                                          _selectedCategories.remove(category);
                                        } else {
                                          _selectedCategories.add(category);
                                        }
                                      });
                                    },
                                    child: _buildSportIcon(
                                      modality['name'] ?? '',
                                      modality['icon'] ?? '',
                                      isSelected: isSelected,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(child: _buildTab('AMISTOSOS', 0)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTab('TREINOS', 1)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: filteredEvents.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Text(
                                    'Nenhum valor encontrado.',
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Column(
                                children: filteredEvents.map((event) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        final sub = _userSubscriptions.firstWhereOrNull((sub) => sub['trainingId'] == event.id);
                                        showTrainingModal(
                                          context,
                                          event,
                                          _subscribedIds,
                                          _loadData,
                                          _scrollController,
                                          subscriptionId: sub != null ? sub['subscriptionId'] : null,
                                        );
                                      },
                                      child: _buildEventCard(
                                        event.title,
                                        event.description,
                                        formatDate(event.date),
                                        event.place,
                                        event.modality.toUpperCase(),
                                        // event.isSubscribed,
                                        _subscribedIds.contains(event.id)
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
    );
  }

  Widget _buildSportIcon(String label, String iconName, {bool isSelected = false}) {
    // Mapeamento manual para os ícones do Material Icons
    const iconMap = {
      'sports_soccer': Icons.sports_soccer,
      'sports_volleyball': Icons.sports_volleyball,
      'sports_tennis': Icons.sports_tennis,
      'sports_basketball': Icons.sports_basketball,
      'sports_handball': Icons.sports_handball,
      'pool': Icons.pool,
      'golf_course': Icons.golf_course,
      // Adicione outros ícones conforme necessário
    };
    final iconData = iconMap[iconName] ?? Icons.sports;
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSelected
                  ? [const Color(0xFFFFD700), const Color(0xFFFFE066)]
                  : [const Color.fromARGB(128, 52, 90, 167), const Color.fromARGB(128, 52, 90, 167)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            iconData,
            size: 30,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = index == _selectedTabIndex;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTabIndex = index;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? const Color(0xFFFFD700) : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? const Color(0xFFFFD700) : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEventCard(String title, String description, String date, String location, String category, bool isSubscribed) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSubscribed ? const Color(0xFF1E88E5).withOpacity(0.2) : Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: isSubscribed ? Border.all(color: const Color(0xFF42A5F5), width: 2) : null,
        boxShadow: isSubscribed
            ? [
                BoxShadow(
                  color: const Color(0xFF42A5F5).withOpacity(0.5),
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
          ExpandableText(
            key: ValueKey(description),
            text: description,
            trimLines: 2,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

void showTrainingModal(
  BuildContext context,
  Training training,
  List<String> _subscribedIds,
  Future<void> Function({bool preserveScroll}) _loadData,
  ScrollController _scrollController,
  {String? subscriptionId}
) async {
  final double currentScrollOffset = _scrollController.offset;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
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