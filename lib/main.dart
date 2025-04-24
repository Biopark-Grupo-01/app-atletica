import 'package:flutter/material.dart';
import 'package:app_atletica/screens/login/login_screen.dart';
import 'package:app_atletica/screens/login/password_recovery_screen.dart';
import 'package:app_atletica/screens/login/register_screen.dart';
import 'package:app_atletica/screens/home/home_screen.dart';
import 'package:app_atletica/screens/events/events_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 1, 28, 58),
        primaryColor: const Color.fromARGB(255, 234, 194, 49),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/password_recovery': (context) => PasswordRecoveryScreen(),
        '/home': (context) => HomeScreen(),
        '/events': (context) => EventsScreen(),
      },
    );
  }
}