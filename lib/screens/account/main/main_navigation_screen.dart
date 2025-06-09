import 'package:app_atletica/screens/account/main/main_screen.dart';
import 'package:app_atletica/screens/news/news_screen_old.dart';
import 'package:app_atletica/screens/store/store_screen.dart';
import 'package:app_atletica/screens/trainings/trainings_screen.dart';
import 'package:app_atletica/screens/account/account_settings_screen.dart';
import 'package:flutter/material.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    MainScreen(),
    TrainingsScreen(),
    StoreScreen(),
    NewsScreen(),
    AccountSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey[400],
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 35),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, size: 35),
            label: 'Treinos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer, size: 35),
            label: 'Loja',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event, size: 35),
            label: 'Eventos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 35),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
