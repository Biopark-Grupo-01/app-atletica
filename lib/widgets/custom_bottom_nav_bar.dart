import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_atletica/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex; // Índice do item atualmente selecionado
  final Function(int) onTap; // Função chamada quando um item é tocado

  @override
  Widget build(BuildContext context) {
    final double iconSize = 30;
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
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
          icon: Icon(FontAwesomeIcons.house, size: iconSize),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.personRunning, size: iconSize),
          label: 'Treinos e Amistosos',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.tag, size: iconSize),
          label: 'Loja',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.calendarDay, size: iconSize),
          label: 'Eventos e Notícias',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.solidCircleUser, size: iconSize),
          label: 'Perfil',
        ),
      ],
    );
  }
}