import 'package:app_atletica/screens/trainings/training-modal.dart';
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
      setState(() {
        news = List<Map<String, String>>.from(data['news'] ?? []);
        events = List<Map<String, String>>.from(data['events'] ?? []);
        trainings = List<Map<String, String>>.from(data['trainings'] ?? []);
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
                
                CustomTitle(title: 'TREINOS E AMISTOSOS'),
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                      NeverScrollableScrollPhysics(), // Para evitar rolagem dupla
                  itemCount:
                      trainings
                          .length, // Supondo que você tenha uma lista de treinos
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
                          isMatch: false, // ou true, se for amistoso
                        )
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
                              location: item['location'] ?? '',
                              title: item['title'] ?? '',
                              description: item['description'] ?? '',
                            ),
                          )
                        : _buildEmptySection('Nenhuma notícia disponível no momento'),
                      CustomTitle(title: 'TREINOS E AMISTOSOS'),
                      trainings.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: trainings.length,
                            itemBuilder: (context, index) {
                              final training = trainings[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: TrainingMatchItem(
                                  title: training['title'] ?? '',
                                  description: training['description'] ?? '',
                                  date: training['date'] ?? '',
                                  location: training['location'] ?? '',
                                  category: training['category'] ?? '',
                                  type: training['type'] ?? '',
                                ),
                              );
                            },
                          )
                        : _buildEmptySection('Nenhum treino disponível no momento'),                    ],
                  ),
                ),
              ),
            ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
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

  // if (await launch(url)) {
    await launch(url);
  // } else {
  //   // Não há suporte para este tipo de URL
  // }
}