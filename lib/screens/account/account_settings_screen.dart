import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/register/register_home.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/screens/account/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import './edit_profile_screen.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}


class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  // final userRepo = MockUserRepository(); // ← esse é nosso fake DB
  UserModel? user;


  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    // final fetchedUser = await userRepo.getUser();
    final fetchedUser = UserModel(
      id: "123",
      email: "teste@gmail.com",
      name: "Lucas",
      cpf: "123.456.789-00",
      avatarUrl: "https://example.com/avatar.png",
    );
    // print("User fetched: ${fetchedUser.name} - ${fetchedUser.cpf}");
    setState(() {
      user = fetchedUser;
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091B40),
      body: Column(
        children: [
          // Header com avatar, nome e editar perfil
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: MediaQuery.of(context).size.height * 0.05),
            width: double.infinity,
            color: Colors.yellow,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                CircleAvatar(
                  radius: 35,
                  // backgroundImage: AssetImage("assets/images/avatar_exemplo.png"),
                  backgroundImage: user?.avatarUrl != null
                      ? NetworkImage(user!.avatarUrl)
                      : const AssetImage("assets/images/logo_tigre.png")
                          as ImageProvider,
                ),
                const SizedBox(width: 16),
                // Nome e CPF
                Expanded(
                  child: user == null
                      ? const CircularProgressIndicator()
                      : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user!.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            user!.cpf ?? 'CPF não disponível',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                ),
                // Editar perfil
                // IconButton(
                //   icon: const Icon(Icons.edit),
                //   onPressed: () {
                //     // TODO: Navegar para tela de edição de perfil
                //   },
                // ),
                // Logout
                IconButton(
                  icon: const Icon(Icons.logout),
                    onPressed: () async {
                      // await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Opções da conta
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                buildOptionTile(
                  icon: Icons.confirmation_num,
                  title: "Ingressos",
                  subtitle: "Ingressos comprados",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const TicketsScreen(),
                      ),
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
                      MaterialPageRoute(
                      builder: (context) => const MembershipCardScreen(),
                      ),
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
                  subtitle: "Edite seu Perfil",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                buildOptionTile(
                    icon: Icons.add_circle,
                  title: "Cadastros",
                  subtitle: "Cadastrar Atividades",
                  onTap: () {
                    // Navigator.pushNamed(context, '/register_home');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const RegisterAccountScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          // Handle bottom navigation tap
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
    return Card(
      color: const Color(0xFF10285C),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.yellow),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.yellow),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}
