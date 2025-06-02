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

Widget _buildMenuCards(BuildContext context) {
  return Column(
    spacing: 25,
    children: [
      MenuCard(
        icon: FontAwesomeIcons.calendarDay,
        title: 'Eventos',
        subtitle: 'Cadastro de Eventos',
        onTap: () {
          Navigator.pushNamed(context, '/event_registration');
        },
      ),
      MenuCard(
        icon: FontAwesomeIcons.newspaper,
        title: 'Notícias',
        subtitle: 'Cadastro de Notícias',
        onTap: () {
          Navigator.pushNamed(context, '/news_registration');
        },
      ),
      MenuCard(
        icon: FontAwesomeIcons.personRunning,
        title: 'Treinos e Amistosos',
        subtitle: 'Cadastro de Treinos e Amistosos',
        onTap: () {
          Navigator.pushNamed(context, '/trainings_registration');
        },
      ),
      MenuCard(
        icon: FontAwesomeIcons.tag,
        title: 'Produtos',
        subtitle: 'Cadastro de Produtos',
        onTap: () {
          Navigator.pushNamed(context, '/product_registration');
        },
      ),
      MenuCard(
        icon: FontAwesomeIcons.solidCircleUser,
        title: 'Perfil',
        subtitle: 'Cadastro de Perfil',
        onTap: () {
          Navigator.pushNamed(context, '/profile_registration');
        },
      ),
    ],
  );
}

class _RegisterAccountScreenState extends State<RegisterAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Center(child: CustomTitleForms(title: 'CADASTRO')),
              Expanded(
                child: SingleChildScrollView(child: _buildMenuCards(context)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
