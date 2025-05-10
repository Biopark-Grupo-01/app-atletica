import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/register/register_home.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/account/user_model.dart';
import './edit_profile_screen.dart';

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
      name: "Lucas Dreveck",
      cpf: "123.456.789-00",
      avatarUrl: "https://example.com/avatar.png",
    );
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: screenHeight * 0.3,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff21396a),
                      Color(0xFF091B40),
                    ],
                  ),
                ),
                child: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
                  title: user == null
                      ? const CircularProgressIndicator()
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: MediaQuery.of(context).size.width * 0.13,
                              backgroundImage: user?.avatarUrl == null
                                  ? NetworkImage(user!.avatarUrl)
                                  : const AssetImage("assets/images/emblema.png") as ImageProvider,
                            ),

                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user!.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    user!.cpf ?? 'CPF não disponível',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  color: Colors.white,
                  onPressed: () async {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),



            SliverList(
              delegate: SliverChildListDelegate(
                [
                  buildOptionTile(
                    icon: Icons.confirmation_num,
                    title: "Ingressos",
                    subtitle: "Ingressos comprados",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TicketsScreen()),
                      );
                    },
                  ),

                  buildOptionTile(
                    icon: Icons.badge,
                    title: "Carteirinha",
                    subtitle: "Sua carteirinha de associação",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MembershipCardScreen()),
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.support_agent,
                    title: "Suporte",
                    subtitle: "Fale com a atlética",
                    onTap: () {},
                  ),
                  buildOptionTile(
                    icon: Icons.person,
                    title: "Editar Perfil",
                    subtitle: "Edite seu perfil",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  buildOptionTile(
                    icon: Icons.add_circle,
                    title: "Cadastros",
                    subtitle: "Cadastrar atividades",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterAccountScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/trainings');
              break;
            case 2:
              Navigator.pushNamed(context, '/store');
              break;
            case 3:
              Navigator.pushNamed(context, '/events');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 1), 
      child: Card(
        color: const Color.fromARGB(128, 52, 90, 167),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: ListTile(
            leading: Icon(icon, color: Colors.yellow),
            title: Text(title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
            onTap: onTap,
          ),
        ),
      ),
    );
  }

}
