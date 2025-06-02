import 'package:flutter/material.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/forms/custom_title_forms.dart';
import 'package:app_atletica/widgets/menu_card.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/screens/account/register/register_home.dart';
import 'package:app_atletica/screens/admin/users_list.dart';

class AdminArea extends StatefulWidget {
  const AdminArea({super.key});

  @override
  State<AdminArea> createState() => _AdminAreaState();
}

class _AdminAreaState extends State<AdminArea> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: CustomAppBar(showBackButton: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: const CustomTitleForms(title: 'ÁREA DO ADMINISTRADOR'),
              ),
              Expanded(
                child: Column(
                  spacing: 25,
                  children: [
                    MenuCard(
                      icon: Icons.add_circle,
                      title: "Cadastros",
                      subtitle: "Cadastrar atividades",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterAccountScreen(),
                          ),
                        );
                      },
                    ),
                    MenuCard(
                      icon: Icons.manage_accounts,
                      title: "Usuários",
                      subtitle: "Lista de Usuários",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UsersList()),
                        );
                      },
                    ),
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
