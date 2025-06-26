import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app_atletica/services/local_storage_service.dart';
import 'package:flutter/material.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  /// Inicializa o serviço de mensagens do Firebase
  static Future<void> initialize() async {
    try {
      // Solicita permissão para notificações
      await requestPermission();
      
      // Obtém o token FCM
      final token = await getToken();
      print('FCM Token: $token');
      
      // Salva o token localmente
      if (token != null) {
        await LocalStorageService.saveData('fcm_token', token);
      }
      
      // Configura handlers para mensagens
      await setupMessageHandlers();
      
      // Monitora mudanças no token
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        print('FCM Token refreshed: $newToken');
        LocalStorageService.saveData('fcm_token', newToken);
        // Aqui você pode enviar o novo token para seu backend
        _sendTokenToBackend(newToken);
      });
      
    } catch (e) {
      print('Erro ao inicializar Firebase Messaging: $e');
    }
  }
  
  /// Solicita permissão para notificações
  static Future<void> requestPermission() async {
    try {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      print('Permissão de notificação: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('Usuário concedeu permissão para notificações');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        print('Usuário concedeu permissão provisória');
      } else {
        print('Usuário negou permissão para notificações');
      }
    } catch (e) {
      print('Erro ao solicitar permissão: $e');
    }
  }
  
  /// Obtém o token FCM
  static Future<String?> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      print('Token FCM obtido: $token');
      return token;
    } catch (e) {
      print('Erro ao obter token FCM: $e');
      return null;
    }
  }
  
  /// Configura handlers para diferentes tipos de mensagens
  static Future<void> setupMessageHandlers() async {
    // Handler para quando app está em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Mensagem recebida em foreground: ${message.messageId}');
      print('Título: ${message.notification?.title}');
      print('Corpo: ${message.notification?.body}');
      print('Dados: ${message.data}');
      
      // Aqui você pode mostrar uma notificação local ou um dialog
      _handleForegroundMessage(message);
    });
    
    // Handler para quando usuário toca na notificação (app estava em background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notificação tocada - app estava em background: ${message.messageId}');
      print('Dados: ${message.data}');
      
      // Navegar para tela específica baseado nos dados da mensagem
      _handleNotificationTap(message);
    });
    
    // Verifica se app foi aberto através de uma notificação (app estava fechado)
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      print('App aberto através de notificação: ${initialMessage.messageId}');
      _handleNotificationTap(initialMessage);
    }
  }
  
  /// Manipula mensagens recebidas quando app está em foreground
  static void _handleForegroundMessage(RemoteMessage message) {
    // Salva a notificação localmente para histórico
    _saveNotificationLocally(message);
    
    // Aqui você pode mostrar um SnackBar, Dialog ou notificação local
    // Exemplo de como você poderia fazer:
    /*
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'Nova notificação'),
        content: Text(message.notification?.body ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
    */
  }
  
  /// Manipula quando usuário toca na notificação
  static void _handleNotificationTap(RemoteMessage message) {
    // Salva a notificação localmente
    _saveNotificationLocally(message);
    
    // Navega baseado no tipo de notificação
    final notificationType = message.data['type'];
    final targetId = message.data['targetId'];
    
    switch (notificationType) {
      case 'training':
        // Navegar para tela de treinos ou treino específico
        print('Navegar para treino: $targetId');
        break;
      case 'event':
        // Navegar para tela de eventos ou evento específico
        print('Navegar para evento: $targetId');
        break;
      case 'general':
      default:
        // Navegar para tela principal ou de notificações
        print('Navegar para home ou notificações');
        break;
    }
  }
  
  /// Salva notificação localmente para histórico
  static Future<void> _saveNotificationLocally(RemoteMessage message) async {
    try {
      final notification = {
        'id': message.messageId,
        'title': message.notification?.title,
        'body': message.notification?.body,
        'data': message.data,
        'receivedAt': DateTime.now().toIso8601String(),
        'read': false,
      };
      
      // Obtém notificações existentes
      final existingNotifications = await LocalStorageService.getData('notifications') ?? [];
      
      // Adiciona nova notificação
      existingNotifications.insert(0, notification);
      
      // Mantém apenas as últimas 50 notificações
      if (existingNotifications.length > 50) {
        existingNotifications.removeRange(50, existingNotifications.length);
      }
      
      // Salva de volta
      await LocalStorageService.saveData('notifications', existingNotifications);
      
    } catch (e) {
      print('Erro ao salvar notificação localmente: $e');
    }
  }
  
  /// Envia o token FCM para o backend
  static Future<void> _sendTokenToBackend(String token) async {
    try {
      // Aqui você implementaria a chamada para seu backend
      // Exemplo:
      /*
      final response = await ApiService.post(
        '/users/fcm-token',
        body: {'fcmToken': token},
      );
      */
      
      print('Token FCM enviado para backend: $token');
    } catch (e) {
      print('Erro ao enviar token para backend: $e');
    }
  }
  
  /// Obtém o token FCM salvo localmente
  static Future<String?> getSavedToken() async {
    try {
      return await LocalStorageService.getData('fcm_token');
    } catch (e) {
      print('Erro ao obter token salvo: $e');
      return null;
    }
  }
  
  /// Obtém histórico de notificações
  static Future<List<Map<String, dynamic>>> getNotificationHistory() async {
    try {
      final notifications = await LocalStorageService.getData('notifications');
      return List<Map<String, dynamic>>.from(notifications ?? []);
    } catch (e) {
      print('Erro ao obter histórico de notificações: $e');
      return [];
    }
  }
  
  /// Marca notificação como lida
  static Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final notifications = await getNotificationHistory();
      final index = notifications.indexWhere((n) => n['id'] == notificationId);
      
      if (index != -1) {
        notifications[index]['read'] = true;
        await LocalStorageService.saveData('notifications', notifications);
      }
    } catch (e) {
      print('Erro ao marcar notificação como lida: $e');
    }
  }
  
  /// Limpa histórico de notificações
  static Future<void> clearNotificationHistory() async {
    try {
      await LocalStorageService.saveData('notifications', []);
    } catch (e) {
      print('Erro ao limpar histórico: $e');
    }
  }
}

/// Handler para mensagens em background (função top-level obrigatória)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Mensagem recebida em background: ${message.messageId}');
  print('Título: ${message.notification?.title}');
  print('Corpo: ${message.notification?.body}');
  
  // Aqui você pode processar a mensagem mesmo com app em background
  // Mantenha o processamento leve para não impactar performance
}
