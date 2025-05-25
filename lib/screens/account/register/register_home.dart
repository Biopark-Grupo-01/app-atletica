import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterAccountScreen extends StatefulWidget {
  const RegisterAccountScreen({super.key});

  @override
  State<RegisterAccountScreen> createState() => _RegisterAccountScreenState();
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(child: const CustomTitleForms(title: 'CADASTRO')),
                    MenuCard(
                      icon: FontAwesomeIcons.calendarDay,
                      title: 'Eventos',
                      subtitle: 'Cadastro de Eventos',
                      onTap: () {Navigator.pushNamed(context, '/event_registration');},
                    ),
                    const SizedBox(height: 20),
                    MenuCard(
                      icon: FontAwesomeIcons.newspaper,
                      title: 'Notícias',
                      subtitle: 'Cadastro de Notícias',
                      onTap: () {Navigator.pushNamed(context, '/news_registration');},
                    ),
                    const SizedBox(height: 20),
                    MenuCard(
                      icon: FontAwesomeIcons.personRunning,
                      title: 'Treinos e Amistosos',
                      subtitle: 'Cadastro de Treinos e Amistosos',
                      onTap: () {Navigator.pushNamed(context, '/trainings_registration');},
                    ),
                    const SizedBox(height: 20),
                    MenuCard(
                      icon: FontAwesomeIcons.tag,
                      title: 'Produtos',
                      subtitle: 'Cadastro de Produtos',
                      onTap: () {Navigator.pushNamed(context, '/product_registration');},
                    ),
                    const SizedBox(height: 20),
                    MenuCard(
                      icon: FontAwesomeIcons.solidCircleUser,
                      title: 'Perfil',
                      subtitle: 'Cadastro de Perfil',
                      onTap: () {Navigator.pushNamed(context, '/profile_registration');},
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation tap
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
