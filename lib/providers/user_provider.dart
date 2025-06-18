import 'package:flutter/material.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _currentUser?.role == 'ADMIN';  UserProvider() {
    // Inicialização padrão, chama _loadUser
    mockLoginUser(); // Simula usuário logado automaticamente ao iniciar
  }
  
  /// Inicializa o provider de forma assíncrona e retorna quando concluído
  Future<void> initializeAsync() async {
    await _loadUser();
  }// Carregar usuário salvo no SharedPreferences
  Future<void> _loadUser() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('Carregando informações de usuário...');
      
      // Verificar status de login usando o serviço
      _isLoggedIn = await AuthService.isLoggedIn();
      print('Usuário está logado: $_isLoggedIn');
      
      // Carregar dados do usuário se estiver logado
      if (_isLoggedIn) {
        _currentUser = await AuthService.getCurrentUser();
        print('Usuário carregado: ${_currentUser?.name ?? "null"}');
        
        // Se não conseguir recuperar o usuário, deslogar
        if (_currentUser == null) {
          print('Dados do usuário não encontrados ou inválidos, deslogando');
          _isLoggedIn = false;
          await AuthService.logout(); // Limpa os dados de sessão
        }
      }
    } catch (e) {
      print('Erro ao carregar usuário: $e');
      _errorMessage = 'Erro ao carregar usuário: $e';
      _isLoggedIn = false;
    } finally {
      _isLoading = false;
      notifyListeners();
      print('Carregamento de usuário concluído. isLoggedIn: $_isLoggedIn');
    }
  }

  // Login de usuário
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.mockLogin(email, password);

      if (result['success']) {
        _currentUser = result['user'];
        await AuthService.saveUserSession(result['token'], _currentUser!);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro durante o login: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Registro de usuário
  Future<bool> register(
    String name,
    String email,
    String password,
    String? cpf,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.mockRegister(name, email, password, cpf);

      if (result['success']) {
        _currentUser = result['user'];
        await AuthService.saveUserSession(result['token'], _currentUser!);
        _isLoggedIn = true;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro durante o registro: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Logout de usuário
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await AuthService.logout();
      _currentUser = null;
      _isLoggedIn = false;
    } catch (e) {
      _errorMessage = 'Erro durante o logout: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualizar perfil do usuário
  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simula um atraso de rede
      await Future.delayed(Duration(seconds: 1));

      // Atualiza o usuário localmente
      _currentUser = updatedUser;
      await AuthService.updateCurrentUser(_currentUser!);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao atualizar perfil: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Limpar mensagem de erro
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Método para simular um usuário logado (apenas para testes)
  void mockLoginUser() {
    _currentUser = UserModel(
      id: '1',
      name: 'Usuário Teste',
      email: 'teste@email.com',
      cpf: '123.456.789-00',
      avatarUrl: '',
      role: 'ADMIN',
      registration: 12345,
      validUntil: '2025-12-31',
    );
    _isLoggedIn = true;
    notifyListeners();
  }
}
