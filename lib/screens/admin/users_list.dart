import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/utils/utils.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/models/user_model.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});
  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  final List<UserModel> allUsers = [
    UserModel(
      id: '1',
      name: 'Alice Santos',
      email: 'alice@email.com',
      avatarUrl: "assets/images/cartao_branco.png",
      cpf: "123.123.123-12",
      registration: 12345678,
      validUntil: '31/12/2025',
    ),
    UserModel(
      id: '2',
      name: 'Bruno Lima',
      email: 'bruno@email.com',
      avatarUrl: "assets/images/emblema.png",
      role: "Não Assiociado",
      cpf: "123.123.123-78",
      registration: 12345678,
      validUntil: '31/12/2025',
    ),
    UserModel(
      id: '3',
      name: 'Carla Dias',
      email: 'carla@email.com',
      avatarUrl: "assets/images/cartao.png",
      role: "Associado",
      cpf: "123.123.456-78",
      registration: 12345678,
      validUntil: '31/12/2025',
    ),
    UserModel(
      id: "123",
      email: "teste@gmail.com",
      name: "Djonathan Leonardo de Souza",
      cpf: "123.456.789-00",
      avatarUrl: "assets/images/selfieCarteirinha.png",
      role: "Diretoria",
      registration: 12345678,
      validUntil: '31/12/2025',
    ),
  ];

  List<UserModel> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  String? selectedUserId;

  @override
  void initState() {
    super.initState();
    filteredUsers = allUsers;
    searchController.addListener(_filterUsers);
  }

  void _filterUsers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers =
          allUsers.where((user) {
            return user.name.toLowerCase().contains(query) ||
                user.email.toLowerCase().contains(query);
          }).toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _userButton({required String title, VoidCallback? onTap}) {
    return ElevatedButton.icon(
      label: Text(title),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        visualDensity: VisualDensity.comfortable,
        backgroundColor: AppColors.white.withOpacity(0.8),
        foregroundColor: AppColors.black,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildUserTile(UserModel user) {
    bool isExpanded = selectedUserId == user.id;

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(user.avatarUrl!)),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: Chip(
            label: Text(
              user.role ?? 'Usuário',
              style: TextStyle(color: roleColor(user.role ?? 'user')),
            ),
            backgroundColor: AppColors.blue,
            shape: StadiumBorder(
              side: BorderSide(color: roleColor(user.role ?? 'user')),
            ),
          ),
          onTap: () {
            setState(() {
              selectedUserId = isExpanded ? null : user.id;
            });
          },
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child:
              isExpanded
                  ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        if (user.role == "Associado" ||
                            user.role == "Diretoria")
                          Expanded(
                            child: _userButton(
                              title: "Carteirinha",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MembershipCardScreen(user: user),
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: _userButton(
                            title: "Ingressos",
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TicketsScreen(user: user),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CustomSearchBar(
              hintText: 'Buscar usuários',
              controller: searchController,
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (_, index) {
                final user = filteredUsers[index];
                return _buildUserTile(user);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }
}
