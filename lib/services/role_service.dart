import 'dart:convert';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/services/api_service.dart';

class RoleModel {
  final String id;
  final String name;
  final String displayName;
  final String? description;

  RoleModel({
    required this.id,
    required this.name,
    required this.displayName,
    this.description,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'],
      name: json['name'],
      displayName: json['displayName'],
      description: json['description'],
    );
  }

  // Define a hierarquia das roles
  int get hierarchyLevel {
    switch (name) {
      case 'ADMIN':
        return 4;
      case 'DIRECTOR':
        return 3;
      case 'ASSOCIATE':
        return 2;
      case 'NON_ASSOCIATE':
        return 1;
      default:
        return 0;
    }
  }

  // Define as cores das roles
  Color get color {
    switch (name) {
      case 'ASSOCIATE':
        return const Color.fromARGB(255, 49, 151, 234);
      case 'DIRECTOR':
        return AppColors.yellow;
      case 'NON_ASSOCIATE':
        return AppColors.lightGrey;
      case 'ADMIN':
        return const Color.fromARGB(255, 255, 77, 77);
      default:
        return AppColors.lightGrey;
    }
  }
}

class RoleService {
  static const String _rolesEndpoint = '/roles';
  static const String _usersEndpoint = '/users';

  /// Busca todas as roles disponíveis
  static Future<List<RoleModel>> getAllRoles(BuildContext context) async {
    try {
      print('Buscando roles da API...');
      
      final response = await ApiService.get(
        context,
        _rolesEndpoint,
        useCache: true,
        cacheKey: 'roles',
      );

      if (response.statusCode == 200) {
        final List<dynamic> rolesJson = json.decode(response.body);
        
        print('${rolesJson.length} roles encontradas');
        
        final List<RoleModel> roles = rolesJson
            .map((roleJson) => RoleModel.fromJson(roleJson))
            .toList();
        
        return roles;
      } else {
        print('Erro ao buscar roles: ${response.statusCode}');
        throw Exception('Falha ao carregar roles: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar roles: $e');
      // Em caso de erro, retorna roles mockadas
      return _getMockRoles();
    }
  }

  /// Filtra as roles que um usuário pode atribuir baseado em sua própria role
  static List<RoleModel> getAvailableRolesForUser(
    List<RoleModel> allRoles,
    String currentUserRole,
    String targetUserRole,
  ) {
    return allRoles.where((role) {
      // Não pode atribuir a própria role do usuário alvo
      if (role.name == targetUserRole) return false;
      
      // ADMINs podem atribuir qualquer role exceto ADMIN
      if (currentUserRole == 'ADMIN') {
        return role.name != 'ADMIN';
      }
      
      // DIRECTORs não podem atribuir ADMIN nem DIRECTOR
      if (currentUserRole == 'DIRECTOR') {
        return role.name != 'ADMIN' && role.name != 'DIRECTOR';
      }
      
      // Outros usuários não podem atribuir roles
      return false;
    }).toList();
  }

  /// Atualiza a role de um usuário
  static Future<bool> updateUserRole(
    BuildContext context,
    String userId,
    String roleId,
  ) async {
    try {
      print('Atualizando role do usuário $userId para role $roleId');
      
      final response = await ApiService.put(
        context,
        '$_usersEndpoint/$userId',
        body: {
          'roleId': roleId,
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('Role atualizada com sucesso');
        return true;
      } else {
        print('Erro ao atualizar role: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar role: $e');
      return false;
    }
  }

  /// Retorna roles mockadas em caso de falha na API
  static List<RoleModel> _getMockRoles() {
    return [
      RoleModel(
        id: '1',
        name: 'ADMIN',
        displayName: 'Administrador',
        description: 'Acesso total ao sistema',
      ),
      RoleModel(
        id: '2',
        name: 'DIRECTOR',
        displayName: 'Diretor',
        description: 'Gerenciamento da atlética',
      ),
      RoleModel(
        id: '3',
        name: 'ASSOCIATE',
        displayName: 'Associado',
        description: 'Membro associado',
      ),
      RoleModel(
        id: '4',
        name: 'NON_ASSOCIATE',
        displayName: 'Não Associado',
        description: 'Usuário não associado',
      ),
    ];
  }
}
