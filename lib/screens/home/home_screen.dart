import 'package:app_atletica/screens/trainings/training-modal.dart';
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
import 'package:app_atletica/widgets/training_match_item.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Use Map<String, String> para compatibilidade com o widget CarouselItem
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<Map<String, dynamic>> trainings = [];

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });
      
      final data = await EventsNewsService.loadData(context);
      
      // Convertendo os dados dinâmicos para String para compatibilidade com o CarouselItem
      final newsList = (data['news'] as List<dynamic>? ?? []).map((item) {
        final map = Map<String, String>.from({});
        (item as Map).forEach((key, value) {
          map[key.toString()] = value?.toString() ?? '';
        });
        return map;
      }).toList();
      
      final eventsList = (data['events'] as List<dynamic>? ?? []).map((item) {
        final map = Map<String, String>.from({});
        (item as Map).forEach((key, value) {
          map[key.toString()] = value?.toString() ?? '';
        });
        return map;
      }).toList();
      
      setState(() {
        news = newsList;
        events = eventsList;
        trainings = List<Map<String, dynamic>>.from(data['trainings'] ?? []);
        isLoading = false;
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.yellow,
          ),
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
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              error ?? 'Ocorreu um erro inesperado',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: AppColors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Tentar Novamente',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
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
      padding: const EdgeInsets.symmetric(vertical: 24),
      alignment: Alignment.center,
      child: Text(
        message,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: const CustomAppBar(),
      body: isLoading 
          ? _buildLoadingView()
          : error != null 
              ? _buildErrorView()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),
                          
                          // Botões de acesso rápido
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
                                  openWhatsApp("5544999719743", text: "Olá! Preciso de suporte com o app da Atlética.");
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 30),
                          const CustomTitle(title: 'EVENTOS'),
                          
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
                              ),
                            )
                          : _buildEmptySection('Nenhum evento disponível no momento'),
                          
                          const SizedBox(height: 30),
                          const CustomTitle(title: 'NOTÍCIAS'),
                          
                          news.isNotEmpty
                          ? CarouselItem(
                              items: news,
                              useCarousel: true,
                              itemBuilder: (item) => NewsItem(
                                imageUrl: item['imageUrl'] ?? '',
                                date: item['date'] ?? '',
                                location: item['location'] ?? '',
                                title: item['title'] ?? '',
                                description: item['description'] ?? '',
                              ),
                            )
                          : _buildEmptySection('Nenhuma notícia disponível no momento'),
                          
                          const SizedBox(height: 30),
                          const CustomTitle(title: 'TREINOS E AMISTOSOS'),
                          
                          trainings.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: trainings.length,
                              itemBuilder: (context, index) {
                                final training = trainings[index];
                                final isMatch = (training['type']?.toString() ?? '').toUpperCase() == 'AMISTOSOS';
                                
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showTrainingModal(context);
                                    },
                                    child: TrainingMatchItem(
                                      title: training['title']?.toString() ?? '',
                                      description: training['description']?.toString() ?? '',
                                      date: training['date']?.toString() ?? '',
                                      location: training['location']?.toString() ?? '',
                                      modality: training['category']?.toString() ?? '',
                                      isMatch: isMatch,
                                    ),
                                  ),
                                );
                              },
                            )
                          : _buildEmptySection('Nenhum treino disponível no momento'),
                        ],
                      ),
                    ),
                  ),
                ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}

void showTrainingModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (_) => const TrainingModal(),
  );
}

Future<void> openWhatsApp(String phoneNumber, {String? text}) async {
  String url = "whatsapp://send?phone=$phoneNumber";
  if (text != null) {
    url += "&text=${Uri.encodeComponent(text)}";
  }

  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  }
}