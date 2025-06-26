import 'package:app_atletica/screens/account/memberShipCard.dart';
import 'package:app_atletica/screens/account/tickets.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:app_atletica/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/widgets/custom_app_bar.dart';
import 'package:app_atletica/widgets/custom_bottom_nav_bar.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/services/user_service.dart';
import 'package:app_atletica/services/role_service.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:provider/provider.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});
  @override
  UsersListState createState() => UsersListState();
}

class UsersListState extends State<UsersList> {
  List<UserModel> allUsers = [];
  List<UserModel> filteredUsers = [];
  List<RoleModel> availableRoles = [];
  TextEditingController searchController = TextEditingController();
  String? selectedUserId;
  bool isLoading = true;
  bool isLoadingRoles = true;
  String? errorMessage;
  String? editingUserId; // ID do usuário cuja role está sendo editada

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterUsers);
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadUsers(),
      _loadRoles(),
    ]);
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await RoleService.getAllRoles(context);
      if (mounted) {
        setState(() {
          availableRoles = roles;
          isLoadingRoles = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoadingRoles = false;
        });
      }
    }
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final users = await UserService.getAllUsers(context);
      setState(() {
        allUsers = users;
        filteredUsers = users;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar usuários: $e';
        isLoading = false;
      });
    }
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
        backgroundColor: AppColors.white.withValues(alpha: 0.8),
        foregroundColor: AppColors.black,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildUserTile(UserModel user) {
    bool isExpanded = selectedUserId == user.id;
    final currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    final canEditRole = currentUser != null && _canEditUserRole(currentUser, user);

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                ? (user.avatarUrl!.startsWith('http') 
                    ? NetworkImage(user.avatarUrl!) 
                    : AssetImage(user.avatarUrl!) as ImageProvider)
                : const AssetImage("assets/images/emblema.png"),
          ),
          title: Text(user.name),
          subtitle: Text(user.email),
          trailing: _buildRoleDisplay(user, canEditRole),
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
                        if (user.isAssociate)
                          Expanded(
                            child: _userButton(
                              title: "Carteirinha",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => MembershipCardScreen(),
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
                                  builder: (_) => const TicketsScreen(),
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

  Future<void> _updateUserRole(String userId, RoleModel newRole) async {
    setState(() {
      editingUserId = userId;
    });

    try {
      final success = await RoleService.updateUserRole(context, userId, newRole.id);
      
      if (!mounted) return;
      
      if (success) {
        // Atualiza o usuário na lista local
        setState(() {
          final userIndex = allUsers.indexWhere((user) => user.id == userId);
          if (userIndex != -1) {
            allUsers[userIndex] = allUsers[userIndex].copyWith(
              role: newRole.name,
              roleDisplayName: newRole.displayName,
            );
          }
          
          final filteredUserIndex = filteredUsers.indexWhere((user) => user.id == userId);
          if (filteredUserIndex != -1) {
            filteredUsers[filteredUserIndex] = filteredUsers[filteredUserIndex].copyWith(
              role: newRole.name,
              roleDisplayName: newRole.displayName,
            );
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role atualizada para ${newRole.displayName}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar role'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          editingUserId = null;
        });
      }
    }
  }

  bool _canEditUserRole(UserModel currentUser, UserModel targetUser) {
    // Não pode editar a própria role
    if (currentUser.id == targetUser.id) return false;
    
    // Só admins e diretores podem editar roles
    return currentUser.isAdmin || currentUser.role == 'DIRECTOR';
  }

  Widget _buildRoleDisplay(UserModel user, bool canEditRole) {
    final currentRole = _getCurrentUserRole(user);
    
    if (canEditRole && !isLoadingRoles && editingUserId != user.id) {
      return GestureDetector(
        onTap: () => _showRoleDropdown(user),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: currentRole?.color ?? Colors.grey,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentRole?.color ?? Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                user.roleDisplayName ?? user.role ?? 'Usuário',
                style: TextStyle(
                  color: currentRole?.color ?? Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.edit,
                color: currentRole?.color ?? Colors.grey,
                size: 12,
              ),
            ],
          ),
        ),
      );
    } else if (editingUserId == user.id) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.yellow),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: currentRole?.color ?? Colors.grey,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: currentRole?.color ?? Colors.grey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              user.roleDisplayName ?? user.role ?? 'Usuário',
              style: TextStyle(
                color: currentRole?.color ?? Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
  }

  RoleModel? _getCurrentUserRole(UserModel user) {
    if (user.role == null) return null;
    return availableRoles.firstWhere(
      (role) => role.name == user.role,
      orElse: () => RoleModel(
        id: 'unknown',
        name: user.role!,
        displayName: user.roleDisplayName ?? user.role!,
      ),
    );
  }

  void _showRoleDropdown(UserModel user) {
    final currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (currentUser == null) return;

    final availableRolesForUser = RoleService.getAvailableRolesForUser(
      availableRoles,
      currentUser.role ?? 'NON_ASSOCIATE',
      user.role ?? 'NON_ASSOCIATE',
    );

    if (availableRolesForUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhuma role disponível para atribuir'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.blue,
        title: Text(
          'Alterar Cargo - ${user.name}',
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cargo atual: ${user.roleDisplayName ?? user.role ?? 'Usuário'}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            const Text(
              'Selecione o novo cargo:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            ...availableRolesForUser.map((role) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  _updateUserRole(user.id, role);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: role.color),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: role.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        role.displayName,
                        style: TextStyle(
                          color: role.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
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
            child: _buildUsersList(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(currentIndex: 4),
    );
  }

  Widget _buildUsersList() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.yellow,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white54,
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar usuários',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: Colors.black,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (filteredUsers.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.white54,
            ),
            SizedBox(height: 16),
            Text(
              'Nenhum usuário encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadUsers,
      color: AppColors.yellow,
      child: ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (_, index) {
          final user = filteredUsers[index];
          return _buildUserTile(user);
        },
      ),
    );
  }
}
