import 'package:flutter/material.dart';
import 'package:app_atletica/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthMiddleware {
  // Verificação se usuário está logado e redirecionamento se não estiver
  static Future<bool> checkAuth(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      // Redireciona para tela de login
      Navigator.of(context).pushReplacementNamed('/login');
      return false;
    }
    return true;
  }
  
  // Verificação se usuário é administrador
  static Future<bool> checkAdmin(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      // Redireciona para tela de login
      Navigator.of(context).pushReplacementNamed('/login');
      return false;
    }
    
    if (!userProvider.isAdmin) {
      // Se não for administrador, exibe mensagem e redireciona
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você não tem permissão para acessar esta área'),
          backgroundColor: Colors.red,
        )
      );
      Navigator.of(context).pushReplacementNamed('/home');
      return false;
    }
    
    return true;
  }
  
  // Verificação se usuário é associado
  static Future<bool> checkAssociate(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    if (!userProvider.isLoggedIn) {
      // Redireciona para tela de login
      Navigator.of(context).pushReplacementNamed('/login');
      return false;
    }
    
    if (!userProvider.isAssociate) {
      // Se não for associado, exibe mensagem
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Esta funcionalidade é exclusiva para associados'),
          backgroundColor: Colors.orange,
        )
      );
      return false;
    }
    
    return true;
  }
  
  // Widget que verifica autenticação 
  static Widget authBuilder({
    required Widget child, 
    bool adminOnly = false, 
    bool associateOnly = false
  }) {
    return Builder(
      builder: (context) {
        Future<bool> checkFunction;
        
        if (adminOnly) {
          checkFunction = checkAdmin(context);
        } else if (associateOnly) {
          checkFunction = checkAssociate(context);
        } else {
          checkFunction = checkAuth(context);
        }
        
        return FutureBuilder<bool>(
          future: checkFunction,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (snapshot.data == true) {
              return child;
            }
            
            return Scaffold(
              body: Center(
                child: Text('Redirecionando...'),
              ),
            );
          },
        );
      },
    );
  }
}
