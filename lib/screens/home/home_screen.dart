import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/screens/trainings/training-modal.dart';
import 'package:app_atletica/widgets/custom_square_button.dart';
import 'package:app_atletica/widgets/training_match_item.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<Training> trainings = [];

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
      final service = EventsNewsService();
      final data = await service.loadData(context);
      setState(() {
        news = List<Map<String, String>>.from(data['news'] ?? []);
        events = List<Map<String, String>>.from(data['events'] ?? []);
        trainings = List<Training>.from(data['trainings'] ?? []);
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoadingView();
    if (error != null) return _buildErrorView();
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: ListView(
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
                    Navigator.pushNamed(context, '/home');
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
            CustomTitle(title: 'NOTÍCIAS'),
            news.isNotEmpty
                ? CarouselItem(
                  items: news,
                  useCarousel: true,
                  itemBuilder: (item) => NewsItem(
                    imageUrl: item['imageUrl'] ?? '',
                    date: item['date'] ?? '',
                    // location: item['location'] ?? '',
                    title: item['title'] ?? '',
                    description: item['description'] ?? '',
                  ),
                )
                : _buildEmptySection('Nenhuma notícia disponível no momento'),
            CustomTitle(title: 'TREINOS E AMISTOSOS'),
            trainings.isNotEmpty
                ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: trainings.length,
                  itemBuilder: (context, index) {
                    final training = trainings[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          showTrainingModal(context, training);
                        },
                        child: TrainingMatchItem(
                          title: training.title,
                          description: training.description,
                          date: training.date,
                          location: training.place,
                          modality: training.modality,
                          isMatch: false, // ou true se for amistoso
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
}

void showTrainingModal(BuildContext context, Training training) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (_) => TrainingModal(training: training, isSubscribed: true),
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
