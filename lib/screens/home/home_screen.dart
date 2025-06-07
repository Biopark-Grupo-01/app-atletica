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
  List<Map<String, String>> news = [];
  List<Map<String, String>> events = [];
  List<Map<String, String>> trainings = [];

  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await EventsNewsService.loadData(context);
      setState(() {
        news = data['news'] ?? [];
        events = data['events'] ?? [];
        trainings = data['trainings'] ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        openWhatsApp("5544999719743", text: "Olá! Preciso de suporte com o app da Atlética.");
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomTitle(title: 'EVENTOS'),

                CarouselItem(
                  items: events,
                  useCarousel: true,
                  itemBuilder: (item) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                      context,
                      '/trainingDetail',
                      arguments: item,
                      );
                    },
                    child: EventItem(
                      imageUrl: item['imageUrl'] ?? '',
                      date: item['date'] ?? '',
                      location: item['location'] ?? '',
                      title: item['title'] ?? '',
                      description: item['description'] ?? '',
                    ),
                  ),
                ),

                CustomTitle(title: 'NOTÍCIAS'),

                CarouselItem(
                  items: news,
                  useCarousel: true,
                  itemBuilder: (item) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                      context,
                      '/trainingDetail',
                      arguments: item,
                      );
                    },
                    child: EventItem(
                      imageUrl: item['imageUrl'] ?? '',
                      date: item['date'] ?? '',
                      location: item['location'] ?? '',
                      title: item['title'] ?? '',
                      description: item['description'] ?? '',
                    ),
                  ),
                ),

                
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
                            showTrainingModal(context);
                        },
                        child: TrainingMatchItem(
                          title: training['title'] ?? '',
                          description: training['description'] ?? '',
                          date: training['date'] ?? '',
                          location: training['location'] ?? '',
                          category: training['category'] ?? '',
                          type: training['type'] ?? '',
                        ),
                      ),

                    );
                  },
                ),
              ],
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

void openWhatsApp(String phoneNumber, {String? text}) async {
  String url = "whatsapp://send?phone=$phoneNumber";
  if (text != null) {
    url += "&text=${Uri.encodeComponent(text)}";
  }

  if (await launch(url)) {
    await launch(url);
  } else {
    // Não há suporte para este tipo de URL
  }
}