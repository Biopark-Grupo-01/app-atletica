import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_atletica/models/user_model.dart';

class AuthService {
  // Chaves para o SharedPreferences
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';
  static const String _keyIsLoggedIn = 'auth_is_logged_in';

  // Salva os dados do usuário após login
  static Future<void> saveUserSession(String token, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyUser, json.encode(user.toJson()));
    await prefs.setBool(_keyIsLoggedIn, true);
  }
  // Verifica se o usuário está logado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedInFlag = prefs.getBool(_keyIsLoggedIn) ?? false;
    
    // Verificação adicional: garante que temos um token válido
    if (isLoggedInFlag) {
      final token = prefs.getString(_keyToken);
      final userString = prefs.getString(_keyUser);
      // Só considera como logado se tivermos tanto o token quanto os dados do usuário
      return token != null && token.isNotEmpty && userString != null && userString.isNotEmpty;
    }
    
    return false;
  }

  // Obtém o token de autenticação
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  // Obtém o usuário atual
  static Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_keyUser);
    
    if (userString == null) {
      return null;
    }
    
    try {
      return UserModel.fromJson(json.decode(userString));
    } catch (e) {
      print('Erro ao deserializar usuário: $e');
      return null;
    }
  }

  // Efetua logout do usuário
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyUser);
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Atualiza os dados do usuário atual
  static Future<void> updateCurrentUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, json.encode(user.toJson()));
  }
  
  // Verifica se o usuário atual é administrador
  static Future<bool> isAdmin() async {
    final user = await getCurrentUser();
    return user?.role == 'ADMIN';
  }

  // Mock para autenticação durante desenvolvimento
  static Future<Map<String, dynamic>> mockLogin(String email, String password) async {
    // Simula um delay de rede
    await Future.delayed(Duration(seconds: 1));

    // Valores mockados
    if (email == 'admin@atletica.com' && password == 'admin123') {
      final user = UserModel(
        id: '1',
        email: email,
        role: 'ADMIN',
        registration: 12345,
        validUntil: '31/12/2025',
        name: "Djonathan Leonardo de Souza",
        cpf: "123.456.789-00",
        avatarUrl: "assets/images/selfieCarteirinha.png",
      );

      return {
        'success': true,
        'token': 'mock_admin_token_123456',
        'user': user,
      };
    } 
    else if (email == 'user@atletica.com' && password == 'user123') {
      final user = UserModel(
        id: '2',
        name: 'Estudante Usuário',
        email: email,
        cpf: '123.456.789-00',
        role: 'ASSOCIADO',
        registration: 54321,
        validUntil: '31/12/2025',
      );

      return {
        'success': true,
        'token': 'mock_user_token_654321',
        'user': user,
      };
    }
    
    // Falha de login
    return {
      'success': false,
      'message': 'Credenciais inválidas',
    };
  }

  // Mock para registro durante desenvolvimento
  static Future<Map<String, dynamic>> mockRegister(
    String name,
    String email,
    String password,
    String? cpf,
  ) async {
    // Simula um delay de rede
    await Future.delayed(Duration(seconds: 1));

    // Sucesso de registro
    final user = UserModel(
      id: '3',
      name: name,
      email: email,
      cpf: cpf,
      role: 'ASSOCIADO',
    );

    return {
      'success': true,
      'token': 'mock_register_token_789012',
      'user': user,
      'message': 'Registro realizado com sucesso',
    };
  }
}