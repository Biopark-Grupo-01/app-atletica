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

class AccountSettingsScreen extends StatelessWidget {
  const AccountSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos Consumer para ouvir mudanças no Provider
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.currentUser;

        return Scaffold(
          backgroundColor: AppColors.blue,
          body: SafeArea(
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
                  child:
                      user == null
                          ? const Center(child: CircularProgressIndicator())
                          : Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 16,
                                right: 16,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius:
                                          MediaQuery.of(context).size.height *
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
                                            // overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            user.cpf ?? 'CPF não disponível',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white70,
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
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.logout),
                                  color: AppColors.white,
                                  onPressed: () async {
                                    // Deslogar o usuário usando o Provider
                                    await userProvider.logout();
                                    if (context.mounted) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      );
                                    }
                                  },
                                ),
                              ),
                              // Positioned(
                              //   bottom: 10,
                              //   right: 0,
                              //   child: IconButton(
                              //     icon: const Icon(Icons.edit),
                              //     color: AppColors.white,
                              //     onPressed: () {
                              //       Navigator.pushNamed(context, '/edit_profile');
                              //     },
                              //   ),
                              // ),
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
                        title: "Eventos Inscritos",
                        subtitle: "Eventos que você está inscrito",
                      ),
                      buildClubeCheersCard(
                        icon: Icons.event_available,
                        title: "Interesses",
                        subtitle: "Notícias que você destacou",
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      spacing: 25,
                      children: [
                        MenuCard(
                          icon: FontAwesomeIcons.solidCircleUser,
                          title: "Editar Perfil",
                          subtitle: "Edite seu perfil",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditProfileScreen(),
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
                                    (context) => TicketsScreen(user: user!),
                              ),
                            );
                          },
                        ),
                        MenuCard(
                          icon: Icons.bookmark,
                          title: "Salvos",
                          subtitle: "Itens que você salvou",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => TicketsScreen(user: user!),
                              ),
                            );
                          },
                        ),
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
                        if (!userProvider.isAdmin) ...[
                          MenuCard(
                            icon: Icons.support_agent,
                            title: "Suporte",
                            subtitle: "Fale com a atlética",
                            onTap: () {},
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
                ),
              ],
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
}) {
  return Container(
    width: 200,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
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
  );
}
