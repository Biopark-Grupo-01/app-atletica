import 'package:app_atletica/models/match_model.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:app_atletica/screens/trainings/expandable_text.dart';
import 'package:app_atletica/screens/trainings/training-modal.dart';
import 'package:app_atletica/services/match_service.dart';
import 'package:app_atletica/services/training_service.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrainingsScreen extends StatefulWidget {
  const TrainingsScreen({super.key});

  @override
  State<TrainingsScreen> createState() => _TrainingsScreenState();
}

class _TrainingsScreenState extends State<TrainingsScreen> {
  final TrainingService _trainingService = TrainingService();
  final MatchService _matchService = MatchService();
  List<Training> _trainings = [];
  List<Match> _matches = [];
  List<String> _subscribedIds = [];
  List<Map<String, String>> _userSubscriptions = [];
  bool _isLoading = true;
  String? _error;

  int _selectedTabIndex = 0;
  List<String> _selectedCategories = [];

  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _modalities = [];

  late final UserProvider userProvider;
  late final user;

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentUser;
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
      final userId = user.id;
      if (_selectedTabIndex == 1) {
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
      } else {
        final matches = await _matchService.getMatches();
        setState(() {
          _matches = matches;
          _isLoading = false;
        });
      }
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
    final filteredEvents = _selectedTabIndex == 1
        ? _trainings.where((event) {
            final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(event.modality.toUpperCase());
            try {
              final eventDate = DateTime.parse(event.date);
              if (eventDate.isBefore(DateTime.now())) return false;
            } catch (_) {
              return false;
            }
            return matchesCategory;
          }).toList()
        : _matches.where((event) {
            final matchesCategory = _selectedCategories.isEmpty || _selectedCategories.contains(event.modality.toUpperCase());
            try {
              final eventDate = DateTime.parse(event.date);
              if (eventDate.isBefore(DateTime.now())) return false;
            } catch (_) {
              return false;
            }
            return matchesCategory;
          }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF001835),
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
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
              child: _error != null
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
                  : _isLoading
                      ? SizedBox(
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(color: Color(0xFFFFD700)),
                          ),
                        )
                      : filteredEvents.isEmpty
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
                                if (_selectedTabIndex == 1) {
                                  final training = event as Training;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        final sub = _userSubscriptions.firstWhereOrNull((sub) => sub['trainingId'] == training.id);
                                        showTrainingModal(
                                          context,
                                          training,
                                          _subscribedIds,
                                          _loadData,
                                          _scrollController,
                                          subscriptionId: sub != null ? sub['subscriptionId'] : null,
                                        );
                                      },
                                      onLongPress: () {
                                        _showContextMenu(context, training, true);
                                      },
                                      child: _buildEventCard(
                                        training.title,
                                        training.description,
                                        formatDate(training.date),
                                        training.place,
                                        training.modality.toUpperCase(),
                                        _subscribedIds.contains(training.id)
                                      ),
                                    ),
                                  );
                                } else {
                                  final match = event as Match;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: GestureDetector(
                                      onTap: () {
                                        showMatchModal(context, match);
                                      },
                                      onLongPress: () {
                                        _showContextMenu(context, match, false);
                                      },
                                      child: _buildEventCard(
                                        match.title,
                                        match.description,
                                        formatDate(match.date),
                                        match.place,
                                        match.modality.toUpperCase(),
                                        false,
                                      ),
                                    ),
                                  );
                                }
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
      'directions_run': Icons.directions_run,
      'fitness_center': Icons.fitness_center,
      'kayaking': Icons.kayaking,
      'kitesurfing': Icons.kitesurfing,
      'paragliding': Icons.paragliding,
      'rowing': Icons.rowing,
      'scoreboard': Icons.scoreboard,
      'scuba_diving': Icons.scuba_diving,
      'skateboarding': Icons.skateboarding,
      'sledding': Icons.sledding,
      'snowboarding': Icons.snowboarding,
      'sports': Icons.sports,
      'sports_mma': Icons.sports_mma,
      'stadium': Icons.stadium,
      'surfing': Icons.surfing,
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
            _loadData();
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

  Future<void> _showContextMenu(BuildContext context, dynamic event, bool isTraining) async {
    final eventTitle = isTraining ? (event as Training).title : (event as Match).title;
    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF001835),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Opções para "$eventTitle"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: const Text('Editar', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _editEvent(event, isTraining);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Excluir', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _deleteEvent(context, event, isTraining);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _editEvent(dynamic event, bool isTraining) {
    if (isTraining) {
      final training = event as Training;
      // Navegar para a tela de edição de treino
      Navigator.pushNamed(
        context,
        '/trainings_registration',
        arguments: training, // Passa o treino atual para edição
      ).then((_) {
        // Recarrega os dados quando volta da tela de edição
        _loadData();
      });
    } else {
      final match = event as Match;
      // Navegar para a tela de edição de amistoso
      Navigator.pushNamed(
        context,
        '/trainings_registration',
        arguments: match, // Passa o amistoso atual para edição
      ).then((_) {
        // Recarrega os dados quando volta da tela de edição
        _loadData();
      });
    }
  }

  Future<void> _deleteEvent(BuildContext context, dynamic event, bool isTraining) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2C3E50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            'Confirmar Exclusão',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            isTraining 
              ? 'Tem certeza que deseja excluir este treino?\n\n"${(event as Training).title}"'
              : 'Tem certeza que deseja excluir este amistoso?\n\n"${(event as Match).title}"',
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.2),
              ),
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _performDelete(event, isTraining);
    }
  }

  Future<void> _performDelete(dynamic event, bool isTraining) async {
    try {
      setState(() {
        _isLoading = true;
      });

      bool success = false;
      if (isTraining) {
        final training = event as Training;
        success = await _trainingService.deleteTraining(training.id);
      } else {
        final match = event as Match;
        success = await _matchService.deleteMatch(match.id);
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isTraining ? 'Treino excluído com sucesso!' : 'Amistoso excluído com sucesso!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        // Recarrega os dados
        await _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isTraining ? 'Erro ao excluir treino!' : 'Erro ao excluir amistoso!',
            ),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

void showMatchModal(BuildContext context, Match match) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => TrainingModal(match: match),
  );
}