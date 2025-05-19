import 'package:app_atletica/screens/forms/profile_registration.dart';
import 'package:app_atletica/screens/forms/trainings_registration.dart';
import 'package:app_atletica/screens/account/account_settings_screen.dart';
import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/store/store_screen.dart';
import 'package:app_atletica/screens/store/product.dart';
import 'package:app_atletica/screens/trainings/training-details_screen.dart';
import 'package:app_atletica/screens/trainings/trainings_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/screens/login/login_screen.dart';
import 'package:app_atletica/screens/login/password_recovery_screen.dart';
import 'package:app_atletica/screens/login/register_screen.dart';
import 'package:app_atletica/screens/home/home_screen.dart';
import 'package:app_atletica/screens/events/events_screen.dart';
import 'package:app_atletica/screens/forms/event_registration.dart';
import 'package:app_atletica/screens/forms/news_registration.dart';
import 'package:app_atletica/screens/forms/product_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.blue,
        primaryColor: AppColors.yellow,
      ),
      initialRoute: '/home',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/password_recovery': (context) => PasswordRecoveryScreen(),
        '/home': (context) => HomeScreen(),
        '/events': (context) => EventsScreen(),
        '/trainings': (context) => TrainingsScreen(),
        '/trainingDetail': (context) => TreinoDetalhesScreen(),
        '/store': (context) => StoreScreen(),
        '/productDetail': (context) => ProductScreen(),
        '/profile': (context) => AccountSettingsScreen(),
        '/event_registration': (context) => EventRegistrationForm(),
        '/news_registration': (context) => NewsRegistrationForm(),
        '/product_registration': (context) => ProductRegistrationForm(),
        '/trainings_registration': (context) => TrainingsRegistrationForm(),
        '/profile_registration': (context) => ProfileRegistrationForm(),
        '/tickets': (context) => const TicketsScreen(),
        '/membership': (context) => const MembershipCardScreen(),
      },
    );
  }
}