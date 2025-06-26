import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/models/match_model.dart';
import 'package:app_atletica/screens/events/news_detail_screen.dart';
import 'package:app_atletica/screens/trainings/training-modal.dart';
import 'package:app_atletica/screens/trainings/expandable_text.dart';
import 'package:app_atletica/services/training_service.dart';
import 'package:app_atletica/services/match_service.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:app_atletica/widgets/custom_square_button.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/services/events_news_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_title.dart';
import 'package:app_atletica/widgets/home/carousel_item.dart';
import 'package:app_atletica/widgets/events/event_item.dart';
import 'package:app_atletica/widgets/events/news_item.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<dynamic> trainingsAndMatches = []; // Lista mista para treinos e amistosos
  List<String> _subscribedIds = [];
  List<Map<String, String>> _userSubscriptions = [];

  bool isLoading = true;
  String? error;

  late final UserProvider userProvider;
  late final user;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    user = userProvider.currentUser;
    _loadData();
  }

  Future<void> _loadData({bool preserveScroll = false}) async {
    try {
      if (!preserveScroll) {
        setState(() {
          isLoading = true;
          error = null;
        });
      }
      final service = EventsNewsService();
      
      // Carrega eventos diretamente do backend (limitado a 5)
      final eventsFromBackend = await service.getEventsFromBackend();
      final limitedEvents = eventsFromBackend.take(5).toList();
      
      // Carrega notícias diretamente do backend (limitado a 5)
      final newsFromBackend = await service.getNewsFromBackend();
      final limitedNews = newsFromBackend.take(5).toList();
      
      // Carrega treinos e amistosos diretamente do backend
      final trainingService = TrainingService();
      final matchService = MatchService();
      
      final trainingsFromBackend = await trainingService.getTrainings();
      final matchesFromBackend = await matchService.getMatches();
      
      // Carrega as inscrições do usuário nos treinos
      final userId = user.id;
      final userSubscriptions = await trainingService.getUserSubscriptions(userId);
      
      // Filtra apenas treinos e amistosos futuros
      final now = DateTime.now();
      final futureTrainings = trainingsFromBackend.where((training) {
        try {
          final eventDate = DateTime.parse(training.date);
          return eventDate.isAfter(now);
        } catch (_) {
          return false;
        }
      }).take(2).toList();
      
      final futureMatches = matchesFromBackend.where((match) {
        try {
          final eventDate = DateTime.parse(match.date);
          return eventDate.isAfter(now);
        } catch (_) {
          return false;
        }
      }).take(2).toList();
      
      // Cria lista mista
      final combinedList = <dynamic>[
        ...futureTrainings,
        ...futureMatches,
      ];
      
      setState(() {
        events = limitedEvents; // Usa eventos do backend limitados a 5
        news = limitedNews; // Usa notícias do backend limitadas a 5
        trainingsAndMatches = combinedList; // Usa treinos e amistosos do backend
        
        // Processa as subscrições
        _userSubscriptions = userSubscriptions.map((sub) => {
          'trainingId': sub['training']['id'] as String,
          'subscriptionId': sub['id'] as String,
        }).toList();
        _subscribedIds = _userSubscriptions.map((sub) => sub['trainingId']!).toList();
        
        if (!preserveScroll) {
          isLoading = false;
        }
      });
    } catch (e) {
      print('Erro ao carregar dados da tela home: $e');
      setState(() {
        error = 'Não foi possível carregar os dados. Tente novamente.';
        isLoading = false;
      });
    }
  }

  // Widget que mostra o indicador de carregamento
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.yellow),
          SizedBox(height: 16),
          Text(
            'Carregando dados...',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Widget que mostra a mensagem de erro
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 60),
            SizedBox(height: 16),
            Text(
              error ?? 'Ocorreu um erro inesperado',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.blue,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text(
                'Tentar Novamente',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget que mostra uma mensagem quando a seção está vazia
  Widget _buildEmptySection(String message) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  String formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return rawDate; // Retorna como está se der erro
    }
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoadingView();
    if (error != null) return _buildErrorView();
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomSquareButton(
                  icon: FontAwesomeIcons.ticket,
                  offsetXFactor: -0.033,
                  offsetYFactor: 0.0015,
                  color: AppColors.yellow,
                  label: 'Ingressos',
                  onPressed: () {
                    Navigator.pushNamed(context, '/tickets');
                  },
                ),
                CustomSquareButton(
                  icon: FontAwesomeIcons.idCard,
                  offsetXFactor: -0.033,
                  offsetYFactor: 0.0015,
                  color: AppColors.white,
                  label: 'Carteirinha',
                  onPressed: () {
                    Navigator.pushNamed(context, '/membership');
                  },
                ),
                CustomSquareButton(
                  icon: Icons.support_agent_rounded,
                  label: 'Suporte',
                  color: AppColors.yellow,
                  onPressed: () {
                    openWhatsApp(
                      '5544999719743',
                      text: 'Olá! Preciso de suporte com o aplicativo da atlética.',
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomTitle(title: 'EVENTOS'),
            events.isNotEmpty
                ? CarouselItem(
                  items: events,
                  useCarousel: true,
                  itemBuilder: (item) => EventItem(
                    imageUrl: item['imageUrl'] ?? '',
                    date: item['date'] ?? '',
                    location: item['location'] ?? '',
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                    price: item['price'] ?? '',
                  ),
                )
                : _buildEmptySection('Nenhum evento disponível no momento'),
            const SizedBox(height: 10),
            CustomTitle(title: 'NOTÍCIAS'),
            news.isNotEmpty
                ? CarouselItem(
                  items: news,
                  useCarousel: true,
                  customHeight: 200, // Altura fixa menor para notícias
                  itemBuilder: (item) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NewsDetailScreen(news: item),
                        ),
                      );
                    },
                    child: NewsItem(
                      imageUrl: item['imageUrl'] ?? '',
                      date: item['date'] ?? '',
                      title: item['title'] ?? '',
                      description: item['description'] ?? '',
                    ),
                  ),
                )
                : _buildEmptySection('Nenhuma notícia disponível no momento'),
            const SizedBox(height: 15),
            CustomTitle(title: 'TREINOS E AMISTOSOS'),
            trainingsAndMatches.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trainingsAndMatches.length,
                  itemBuilder: (context, index) {
                    final item = trainingsAndMatches[index];
                    final isTraining = item is Training;
                    
                    // Extrai dados comuns
                    final title = isTraining ? item.title : (item as Match).title;
                    final description = isTraining ? item.description : item.description;
                    final date = isTraining ? item.date : item.date;
                    final location = isTraining ? item.place : item.place;
                    final modality = isTraining ? item.modality : item.modality;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          if (isTraining) {
                            final sub = _userSubscriptions.firstWhereOrNull((sub) => sub['trainingId'] == item.id);
                            showTrainingModal(
                              context, 
                              item,
                              _subscribedIds,
                              _loadData,
                              _scrollController,
                              subscriptionId: sub != null ? sub['subscriptionId'] : null,
                            );
                          } else {
                            showMatchModal(context, item);
                          }
                        },
                        child: _buildEventCard(
                          title,
                          description,
                          formatDate(date),
                          location,
                          modality.toUpperCase(),
                          isTraining ? _subscribedIds.contains(item.id) : false, // Apenas treinos podem ter inscrição
                        ),
                      ),
                    );
                  },
                )
                : _buildEmptySection('Nenhum treino disponível no momento'),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

void showTrainingModal(
  BuildContext context,
  Training training,
  List<String> subscribedIds,
  Future<void> Function({bool preserveScroll}) loadData,
  ScrollController scrollController,
  {String? subscriptionId}
) async {
  final double currentScrollOffset = scrollController.offset;
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => TrainingModal(
      training: training,
      isSubscribed: subscribedIds.contains(training.id),
      subscriptionId: subscriptionId,
      onClose: () async {
        await loadData(preserveScroll: true);
      },
    ),
  ).then((_) async {
    await loadData(preserveScroll: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(currentScrollOffset);
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

void openWhatsApp(String phoneNumber, {String? text}) async {
  String url = "whatsapp://send?phone=$phoneNumber";
  if (text != null) {
    url += "&text=${Uri.encodeComponent(text)}";
  }

  // if (await launch(url)) {
  await launchUrl(Uri.parse(url));
  // } else {
  //   // Não há suporte para este tipo de URL
  // }
}
