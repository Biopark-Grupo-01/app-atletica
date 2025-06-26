import 'package:flutter/material.dart';
import 'package:app_atletica/services/firebase_messaging_service.dart';
import 'package:app_atletica/theme/app_colors.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => isLoading = true);
    
    final notificationsList = await FirebaseMessagingService.getNotificationHistory();
    
    setState(() {
      notifications = notificationsList;
      isLoading = false;
    });
  }

  Future<void> _markAsRead(String notificationId) async {
    await FirebaseMessagingService.markNotificationAsRead(notificationId);
    _loadNotifications();
  }

  Future<void> _clearAll() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpar Notificações'),
        content: const Text('Tem certeza que deseja limpar todas as notificações?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseMessagingService.clearNotificationHistory();
              _loadNotifications();
            },
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        backgroundColor: AppColors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (notifications.isNotEmpty)
            IconButton(
              onPressed: _clearAll,
              icon: const Icon(Icons.clear_all),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Nenhuma notificação',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  child: ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      final isRead = notification['read'] ?? false;
                      final receivedAt = DateTime.parse(notification['receivedAt']);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isRead ? Colors.grey : AppColors.blue,
                            child: Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: isRead ? 20 : 24,
                            ),
                          ),
                          title: Text(
                            notification['title'] ?? 'Notificação',
                            style: TextStyle(
                              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (notification['body'] != null)
                                Text(
                                  notification['body'],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(receivedAt),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: !isRead
                              ? const Icon(
                                  Icons.fiber_manual_record,
                                  color: Colors.blue,
                                  size: 12,
                                )
                              : null,
                          onTap: () {
                            if (!isRead) {
                              _markAsRead(notification['id']);
                            }
                            
                            // Aqui você pode navegar para a tela específica
                            // baseado no tipo de notificação
                            final data = notification['data'] as Map<String, dynamic>? ?? {};
                            final type = data['type'];
                            final targetId = data['targetId'];
                            
                            // Implementar navegação baseada no tipo
                            switch (type) {
                              case 'training':
                                // Navigator.pushNamed(context, '/training-details', arguments: targetId);
                                break;
                              case 'event':
                                // Navigator.pushNamed(context, '/event-details', arguments: targetId);
                                break;
                              default:
                                break;
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
