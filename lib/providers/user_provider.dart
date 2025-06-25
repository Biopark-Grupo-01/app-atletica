import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = true;
  String? _errorMessage;
  late StreamSubscription<auth.User?> _authSubscription;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin =>
      _currentUser?.role == 'ADMIN' || _currentUser?.role == 'DIRECTOR';

  UserProvider() {
    _authSubscription =
        auth.FirebaseAuth.instance.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> _onAuthStateChanged(auth.User? firebaseUser) async {
    print('Auth state changed: ${firebaseUser?.uid}');
    
    if (firebaseUser == null) {
      print('Firebase user é null, fazendo logout local');
      _currentUser = null;
      _isLoading = false;
      _errorMessage = null; // Limpa qualquer erro anterior
      notifyListeners();
      await AuthService.logout();
    } else {
      try {
        // Aguarda um pouco para garantir que a sessão foi salva
        await Future.delayed(const Duration(milliseconds: 100));
        _currentUser = await AuthService.getCurrentUser();
        
        // Se não temos dados locais, aguarda mais um pouco e tenta novamente
        if (_currentUser == null) {
          print('Usuário não encontrado localmente, aguardando...');
          await Future.delayed(const Duration(milliseconds: 500));
          _currentUser = await AuthService.getCurrentUser();
        }
        
        // Só faz logout se ainda não temos dados após as tentativas
        if (_currentUser == null) {
          print('Usuário ainda não encontrado após tentativas, fazendo logout');
          await auth.FirebaseAuth.instance.signOut();
        } else {
          print('Usuário carregado: ${_currentUser?.name}');
        }
      } catch (e) {
        print('Erro ao sincronizar usuário: $e');
        _errorMessage = 'Erro ao sincronizar usuário: $e';
        _currentUser = null;
        await auth.FirebaseAuth.instance.signOut();
      }
    }
    
    // Garante que sempre remove o loading e notifica
    if (_isLoading) {
      _isLoading = false;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }

  Future<bool> updateProfile(UserModel updatedUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1));
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

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Método para forçar atualização do estado (útil para debugging)
  void forceRefresh() {
    _isLoading = false;
    notifyListeners();
    print('UserProvider state forced refresh - isLoggedIn: $isLoggedIn, isLoading: $_isLoading');
  }
}
