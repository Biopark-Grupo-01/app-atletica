import 'package:flutter/material.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/menu_card.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/account/edit_profile_screen.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/admin/admin_area.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:app_atletica/services/firebase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para ouvir mudanças no Provider
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.currentUser;

        // Se não há usuário logado, não renderiza nada - deixa o AuthWrapper gerenciar
        if (user == null) {
          return const SizedBox.shrink();
        }

        return Scaffold(
          backgroundColor: AppColors.blue,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff21396a), AppColors.blue],
                          ),
                        ),
                        child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      left: 16,
                                      right: 16,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            radius:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height *
                                                0.08,
                                            backgroundImage: _getAvatarImage(
                                              user.avatarUrl,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  user.name,
                                                  maxLines: 3,
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  user.role ??
                                                      'Cargo não disponível',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white70,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 10,
                                      right: 0,                      child: IconButton(
                        icon: const Icon(Icons.logout),
                        color: AppColors.white,
                        onPressed: () async {
                          try {
                            final firebaseAuthService = Provider.of<FirebaseAuthService>(context, listen: false);
                            
                            // Mostra loading durante logout
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(
                                child: CircularProgressIndicator(color: AppColors.yellow),
                              ),
                            );
                            
                            await firebaseAuthService.signOut();
                            
                            // Remove o dialog de loading se ainda está na tela
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            
                            if (context.mounted) {
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                '/',
                                (route) => false,
                              );
                            }
                            
                          } catch (e) {
                            // Remove o dialog se houver erro
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                            
                            // Mostra erro
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Erro ao fazer logout: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      ),
                                    ),
                                  ],
                                ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          children: [
                            buildClubeCheersCard(
                              icon: Icons.event_available,
                              title: "Treinos Inscritos",
                              subtitle: "Treinos que você está inscrito",
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/subscribedTrainings',
                                );
                              },
                            ),
                            buildClubeCheersCard(
                              icon: Icons.event_available,
                              title: "Interesses",
                              subtitle: "Notícias que você destacou",
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          spacing: MediaQuery.of(context).size.height * 0.025,
                          children: [
                            MenuCard(
                              icon: FontAwesomeIcons.solidCircleUser,
                              title: "Editar Perfil",
                              subtitle: "Edite seu perfil",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const EditProfileScreen(),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              icon: Icons.confirmation_num,
                              title: "Ingressos",
                              subtitle: "Ingressos comprados",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TicketsScreen(specificUserId: user.id),
                                  ),
                                );
                              },
                            ),
                            MenuCard(
                              icon: Icons.support_agent,
                              title: "Suporte",
                              subtitle: "Fale conosco pelo WhatsApp",
                              onTap: () {
                                openWhatsApp(
                                  '5544999719743',
                                  text: 'Olá! Preciso de suporte com o aplicativo da atlética.',
                                );
                              },
                            ),
                            // MenuCard(
                            //   icon: Icons.bookmark,
                            //   title: "Salvos",
                            //   subtitle: "Itens que você salvou",
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder:
                            //             (context) => const TicketsScreen(),
                            //       ),
                            //     );
                            //   },
                            // ),
                            if (userProvider.isAssociate) ...[
                              MenuCard(
                                icon: Icons.badge,
                                title: "Carteirinha",
                                subtitle: "Sua carteirinha de associação",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MembershipCardScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                            if (userProvider.isAdmin) ...[
                              MenuCard(
                                icon: FontAwesomeIcons.userTie,
                                title: "Administração",
                                subtitle: "Área do administrador",
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminArea(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
            ),
          ),
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
        );
      },
    );
  }

  // Método auxiliar para obter a imagem do avatar
  static ImageProvider _getAvatarImage(String? avatarUrl) {
    if (avatarUrl == null || avatarUrl.isEmpty) {
      return const AssetImage("assets/images/emblema.png");
    }

    if (avatarUrl.startsWith('http')) {
      return NetworkImage(avatarUrl);
    } else {
      return AssetImage(avatarUrl);
    }
  }
}

Widget buildClubeCheersCard({
  required IconData icon,
  required String title,
  required String subtitle,
  Color backgroundColor = const Color.fromARGB(128, 52, 90, 167),
  VoidCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 35),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
          Text(
            subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

void openWhatsApp(String phoneNumber, {String? text}) async {
  String url = "whatsapp://send?phone=$phoneNumber";
  if (text != null) {
    url += "&text=${Uri.encodeComponent(text)}";
  }

  await launchUrl(Uri.parse(url));
}
