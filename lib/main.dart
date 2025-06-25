import 'package:app_atletica/screens/account/edit_profile_screen.dart';
import 'package:app_atletica/screens/forms/profile_registration.dart';
import 'package:app_atletica/screens/forms/trainings_registration.dart';
import 'package:app_atletica/screens/account/account_settings_screen.dart';
import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/store/store_screen.dart';
import 'package:app_atletica/screens/store/product.dart';
import 'package:app_atletica/screens/trainings/subscribed_trainings_screen.dart';
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
import 'package:app_atletica/screens/forms/product_registration.dart';
import 'package:provider/provider.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:app_atletica/services/firebase_auth_service.dart';


import 'package:app_atletica/utils/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Define o idioma das mensagens de erro do Firebase Auth
  await auth.FirebaseAuth.instance.setLanguageCode("pt-BR");

  // Configura um handler global para capturar erros de Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    print('ERRO FLUTTER: ${details.exception}');
    print('STACK TRACE: ${details.stack}');
    FlutterError.presentError(details);
  };

  // Inicializa o handler global de erros
  GlobalErrorHandler.initialize();

  // Configurar orientação de tela para retrato apenas
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Execute o aplicativo dentro de uma zona com captura de erros
  GlobalErrorHandler.runWithCaptureErrors(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          Provider<FirebaseAuthService>(
            create: (_) => FirebaseAuthService(),
          ),
          StreamProvider<auth.User?>(
            create: (context) =>
                context.read<FirebaseAuthService>().authStateChanges,
            initialData: null,
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        print('AuthWrapper rebuild - isLoading: ${userProvider.isLoading}, isLoggedIn: ${userProvider.isLoggedIn}, currentUser: ${userProvider.currentUser?.name}');
        
        if (userProvider.isLoading) {
          print('AuthWrapper showing loading');
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (userProvider.isLoggedIn) {
          print('AuthWrapper navigating to HomeScreen');
          return HomeScreen();
        }

        print('AuthWrapper navigating to LoginScreen');
        return LoginScreen();
      },
    );
  }
}


class MyApp extends StatelessWidget {
  // Chave de navegação global que pode ser acessada de qualquer lugar no app
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.blue,
        primaryColor: AppColors.yellow,
        colorScheme: ColorScheme.dark(
          primary: AppColors.yellow,
          secondary: AppColors.yellow,
        ),
      ),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      // A home agora é o AuthWrapper, que decide qual tela mostrar.
      // A rota inicial é removida para evitar conflitos.
      home: const AuthWrapper(),
      routes: {
        // Rotas públicas (sem autenticação)
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/password_recovery': (context) => PasswordRecoveryScreen(),

        // Dashboard (substituindo a antiga rota home)
        '/home': (context) => HomeScreen(),

        // Rotas protegidas por autenticação
        '/events': (context) => EventsScreen(),
        '/trainings': (context) => TrainingsScreen(),
        '/trainingDetail': (context) => TreinoDetalhesScreen(),
        '/store': (context) => StoreScreen(),
        '/productDetail': (context) => ProductScreen(),
        '/subscribedTrainings': (context) => SubscribedTrainingsScreen(),
        '/profile': (context) => AccountSettingsScreen(),
        '/edit_profile': (context) => EditProfileScreen(),
        '/tickets': (context) => const TicketsScreen(),
        '/membership': (context) => const MembershipCardScreen(),
        '/profile_registration': (context) => ProfileRegistrationForm(),

        // Rotas de administrador
        '/event_registration': (context) => EventRegistrationForm(),
        '/product_registration': (context) => ProductRegistrationForm(),
        '/trainings_registration': (context) => TrainingsRegistrationForm(),
      }, // Observador de navegação para verificar autenticação
      navigatorObservers: [
        NavigatorObserver(),
      ], // Configuração simplificada para manipular rotas não encontradas
      onUnknownRoute: (RouteSettings settings) {
        print('Rota não encontrada: ${settings.name}');
        return MaterialPageRoute(
          builder:
              (context) => Scaffold(
                appBar: AppBar(title: Text('Página não encontrada')),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'A página "${settings.name}" não foi encontrada.',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Voltar'),
                      ),
                    ],
                  ),
                ),
              ),
        );
      },
    );
  }
}
