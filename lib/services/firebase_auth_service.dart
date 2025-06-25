import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app_atletica/services/auth_service.dart';
import 'package:app_atletica/models/user_model.dart';
import 'package:app_atletica/config/app_config.dart';

class FirebaseAuthService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final String _apiUrl = AppConfig.apiUrl;

  Future<auth.User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // O usuário cancelou o login
      return null;
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final auth.UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;

    if (user != null) {
      final idToken = await user.getIdToken();
      if (idToken == null) {
        throw Exception('Falha ao obter o token de autenticação do Firebase.');
      }

      final response = await http.post(
        Uri.parse('$_apiUrl/auth/login/google'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(json.decode(response.body));
        print('Salvando sessão do usuário: ${userModel.name}');
        await AuthService.saveUserSession(idToken, userModel);
        print('Sessão salva com sucesso');
      } else {
        final responseBody = json.decode(response.body);
        throw Exception(responseBody['message'] ?? 'Falha ao fazer login com o backend.');
      }
    }

    return user;
  }

  Future<auth.User?> signInWithEmailAndPassword(String email, String password) async {
    final auth.UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    if (user != null) {
      String? idToken;

      try {
        idToken = await user.getIdToken(true);
      } catch (e) {
        // Aguarda um pouco e tenta novamente
        await Future.delayed(const Duration(milliseconds: 500));
        final currentUser = _firebaseAuth.currentUser;
        if (currentUser == null) {
          throw Exception('Nenhum usuário atualmente logado no Firebase Auth após login por email.');
        }
        idToken = await currentUser.getIdToken();
      }

      if (idToken == null) {
        throw Exception('Falha ao obter o token de autenticação do Firebase.');
      }

      final response = await http.post(
        Uri.parse('$_apiUrl/auth/login/email'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
      );

      if (response.statusCode == 200) {
        final userModel = UserModel.fromJson(json.decode(response.body));
        await AuthService.saveUserSession(idToken, userModel);
      } else {
        final responseBody = json.decode(response.body);
        throw Exception(responseBody['message'] ?? 'Falha ao fazer login com o backend.');
      }
    }

    return user;
  }
  
  Future<auth.User?> registerWithEmailAndPassword(String name, String email, String password) async {
    final auth.UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    if (user != null) {
      await user.updateDisplayName(name);
      final idToken = await user.getIdToken();
      final response = await http.post(
        Uri.parse('$_apiUrl/auth/signup'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken',
        },
        body: json.encode({'name': name, 'email': email})
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await _firebaseAuth.signOut();
        return user;
      } else {
        final responseBody = json.decode(response.body);
        throw Exception(responseBody['message'] ?? 'Falha ao registrar no backend.');
      }
    }

    return user;
  }


  Future<void> signOut() async {
    print('Iniciando logout...');
    
    // Primeiro limpa a sessão local
    await AuthService.logout();
    print('Sessão local limpa');
    
    // Depois faz logout dos serviços externos
    await _googleSignIn.signOut();
    print('Google Sign-In logout concluído');
    
    // Por último, faz logout do Firebase Auth (isso dispara o authStateChanges)
    await _firebaseAuth.signOut();
    print('Firebase Auth logout concluído');
  }

  Stream<auth.User?> get authStateChanges => _firebaseAuth.authStateChanges();

  auth.User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }
}
