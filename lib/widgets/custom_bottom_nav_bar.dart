import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
  });
  final int currentIndex; // Índice do item atualmente selecionado

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        final routes = ['/home', '/trainings', '/store', '/events', '/profile'];
        if (index >= 0 && index < routes.length) {
          Navigator.pushNamed(context, routes[index]);
        }
      },
      selectedItemColor: AppColors.yellow,
      unselectedItemColor: AppColors.lightGrey,
      backgroundColor: AppColors.darkGrey,
      type:
          BottomNavigationBarType
              .fixed, // garante que os itens não se ajustem dinamicamente
      showSelectedLabels: false, // remove o texto do item selecionado
      showUnselectedLabels: false, // remove o texto dos itens não selecionados
      items: [
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.house),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.personRunning),
          label: 'Treinos e Amistosos',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.tag),
          label: 'Loja',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calendarDay),
          label: 'Eventos e Notícias',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidCircleUser),
          label: 'Perfil',
        ),
      ],
    );
  }
}