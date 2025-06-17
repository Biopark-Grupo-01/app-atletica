import 'package:app_atletica/screens/account/edit_profile_screen.dart';
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
import 'package:app_atletica/screens/forms/product_registration.dart';
import 'package:provider/provider.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:flutter/services.dart';

import 'package:app_atletica/utils/error_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  // Cria o provedor de usuário uma vez para evitar problemas de inicialização
  final userProvider = UserProvider();

  // Aguarda a inicialização do provedor de usuário
  await userProvider.initializeAsync();

  // Execute o aplicativo dentro de uma zona com captura de erros
  GlobalErrorHandler.runWithCaptureErrors(() {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>.value(value: userProvider),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // Chave de navegação global que pode ser acessada de qualquer lugar no app
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // Inicializa o tema e configura rotas
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Verifica se ainda está carregando dados do usuário
        if (userProvider.isLoading) {
          return MaterialApp(
            theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.blue,
              primaryColor: AppColors.yellow,
            ),
            debugShowCheckedModeBanner: false,
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } // Log do estado de login
        print('Estado de login: ${userProvider.isLoggedIn}');
        // Define a rota inicial com base no estado de login
        final String initialRoute =
            userProvider.isLoggedIn ? '/events' : '/events';
        print(
          'Estado de login: ${userProvider.isLoggedIn}, Rota inicial: $initialRoute',
        );

        return MaterialApp(
          navigatorKey: MyApp.navigatorKey,
          theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: AppColors.blue,
            primaryColor: AppColors.yellow,
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute,
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
      },
    );
  }
}
