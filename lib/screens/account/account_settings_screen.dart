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
    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                width: double.infinity,
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
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
                child: user == null
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
                                  radius: MediaQuery.of(context).size.height * 0.09,
                                  backgroundImage: user!.avatarUrl.isEmpty
                                      ? NetworkImage(user!.avatarUrl)
                                      : const AssetImage("assets/images/emblema.png") as ImageProvider,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user!.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                              color: Colors.white,
                              onPressed: () async {
                                Navigator.pushReplacementNamed(context, '/login');
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
                    // outros cards
                  ],
                ),
              ),
              const SizedBox(height: 16),
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

Widget buildClubeCheersCard({
  required IconData icon,
  required String title,
  required String subtitle,
  Color backgroundColor = const Color(0xFFA60000),
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
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
        Text(
          subtitle,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
