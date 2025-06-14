import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/widgets/menu_card.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/account/edit_profile_screen.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/admin/admin_area.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final fetchedUser = UserModel(
      id: "123",
      email: "teste@gmail.com",
      name: "Djonathan Leonardo de Souza",
      cpf: "123.456.789-00",
      avatarUrl: "assets/images/selfieCarteirinha.png",
      role: "admin",
      registration: 12345678,
      validUntil: '31/12/2025',
    );
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      body: SafeArea(
        child:
            user == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.height *
                                        0.08,
                                    backgroundImage:
                                        user!.avatarUrl!.isNotEmpty
                                            ? AssetImage(user!.avatarUrl!)
                                            : const AssetImage(
                                                  "assets/images/emblema.png",
                                                )
                                                as ImageProvider,
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
                                          user!.name,
                                          maxLines: 3,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user!.cpf ?? 'CPF não disponível',
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
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
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

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
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
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
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
                            const SizedBox(height: 20),
                            MenuCard(
                              icon: Icons.badge,
                              title: "Carteirinha",
                              subtitle: "Sua carteirinha de associação",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            MembershipCardScreen(user: user!),
                                  ),
                                );
                              },
                            ),
                            if (user!.role != "admin") ...[
                              const SizedBox(height: 20),
                              MenuCard(
                                icon: Icons.support_agent,
                                title: "Suporte",
                                subtitle: "Fale com a atlética",
                                onTap: () {},
                              ),
                            ],
                            if (user != null && user!.role == "admin") ...[
                              const SizedBox(height: 20),
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
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
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
