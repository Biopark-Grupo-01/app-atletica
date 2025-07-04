import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/services/api_service.dart';

class UserService {
  static const String _usersEndpoint = '/users';
  
  // Cache para armazenar usuários já carregados
  static Map<String, UserModel> _userCache = {};

  /// Busca todos os usuários da API
  static Future<List<UserModel>> getAllUsers(BuildContext context) async {
    try {
      print('Buscando usuários da API...');
      
      // Faz a requisição GET para o endpoint /users
      final response = await ApiService.get(
        context,
        _usersEndpoint,
        useCache: false, // Não usar cache para dados de usuários por questões de segurança
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        print('Response body: $responseBody');
        
        // A resposta é diretamente um array de usuários, não um objeto HATEOAS
        final List<dynamic> usersJson = json.decode(responseBody);
        
        print('${usersJson.length} usuários encontrados');
        
        // Converte cada item para UserModel
        final List<UserModel> users = usersJson
            .map((userJson) => UserModel.fromJson(userJson))
            .toList();
        
        return users;
      } else {
        print('Erro ao buscar usuários: ${response.statusCode}');
        throw Exception('Falha ao carregar usuários: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuários: $e');
      
      // Em caso de erro, retorna lista de usuários mockados
      return _getMockUsers();
    }
  }

  /// Busca um usuário específico por ID
  static Future<UserModel?> getUserById(String userId, BuildContext context) async {
    try {
      // Verifica se o usuário já está no cache
      if (_userCache.containsKey(userId)) {
        return _userCache[userId];
      }
      
      print('Buscando usuário $userId da API...');
      
      // Faz a requisição GET para o endpoint /users/{id}
      final response = await ApiService.get(
        context,
        '$_usersEndpoint/$userId',
        useCache: false,
      );

      if (response.statusCode == 200) {
        final responseBody = response.body;
        final Map<String, dynamic> userJson = json.decode(responseBody);
        
        final user = UserModel.fromJson(userJson);
        
        // Adiciona ao cache
        _userCache[userId] = user;
        
        print('Usuário encontrado: ${user.name}');
        return user;
      } else if (response.statusCode == 404) {
        print('Usuário $userId não encontrado');
        return null;
      } else {
        print('Erro ao buscar usuário $userId: ${response.statusCode}');
        throw Exception('Falha ao carregar usuário: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar usuário $userId: $e');
      
      // Verifica se existe nos usuários mockados
      final mockUsers = _getMockUsers();
      final mockUser = mockUsers.firstWhere(
        (user) => user.id == userId,
        orElse: () => UserModel(
          id: userId,
          name: 'Usuário #$userId',
          email: 'usuario$userId@email.com',
        ),
      );
      
      // Adiciona ao cache
      _userCache[userId] = mockUser;
      return mockUser;
    }
  }

  /// Limpa o cache de usuários
  static void clearCache() {
    _userCache.clear();
  }

  /// Retorna usuários mockados em caso de falha na API
  static List<UserModel> _getMockUsers() {
    return [
      UserModel(
        id: '1',
        name: 'Alice Santos',
        email: 'alice@email.com',
        avatarUrl: "assets/images/cartao_branco.png",
        cpf: "123.123.123-12",
        role: "ASSOCIATE",
        roleDisplayName: "Associado",
        registration: 12345678,
        validUntil: '31/12/2025',
      ),
      UserModel(
        id: '2',
        name: 'Bruno Lima',
        email: 'bruno@email.com',
        avatarUrl: "assets/images/emblema.png",
        role: "NON_ASSOCIATE",
        roleDisplayName: "Não Associado",
        cpf: "123.123.123-78",
        registration: 12345678,
        validUntil: '31/12/2025',
      ),
      UserModel(
        id: '3',
        name: 'Carla Dias',
        email: 'carla@email.com',
        avatarUrl: "assets/images/cartao.png",
        role: "ASSOCIATE",
        roleDisplayName: "Associado",
        cpf: "123.123.456-78",
        registration: 12345678,
        validUntil: '31/12/2025',
      ),
      UserModel(
        id: "4",
        email: "admin@atletica.com",
        name: "Administrador Sistema",
        cpf: "123.456.789-00",
        avatarUrl: "assets/images/selfieCarteirinha.png",
        role: "ADMIN",
        roleDisplayName: "Administrador",
        registration: 12345678,
        validUntil: '31/12/2025',
      ),
    ];
  }
}
