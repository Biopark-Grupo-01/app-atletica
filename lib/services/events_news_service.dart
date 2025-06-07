// import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:app_atletica/utils/utils.dart';

class EventsNewsService {
  static Future<Map<String, List<Map<String, String>>>> loadData(BuildContext context) async {
    // Mock data for now
    final news = [
      {
        'imageUrl': 'https://picsum.photos/300/150',
        'date': '15/05/2025',
        'location': 'Toledo',
        'title': 'Acesso Rápido',
        'description': 'Foi realizado alterações nos botões de acesso rápido',
      },
      {
        'imageUrl': 'https://picsum.photos/301/150',
        'date': '22/05/2025',
        'location': 'Toledo',
        'title': 'Notícia do Backend',
        'description': 'Essa notícia veio da API.',
      },
    ];

    final events = [
      {
        'imageUrl': 'https://picsum.photos/302/150',
        'date': '09/05/2025',
        'location': 'Toledo',
        'title': 'Confraternização Semana Acadêmica',
        'description': 'Ocorrera uma festa para o fim da semana acadêmica',
      },
      {
        'imageUrl': 'https://picsum.photos/303/150',
        'date': '30/05/2025',
        'location': 'Toledo',
        'title': 'Evento da API',
        'description': 'Evento vindo do back-end.',
      },
    ];

    final trainings = [
      {
        'type': 'TREINOS',
        'category': 'Basquete',
        'date': '03/05/2025',
        'location': 'Ginásio Central',
        'title': 'Treino de Arremesso',
        'description': 'Foco em fundamentos e agilidade.',
      },
      {
        'type': 'AMISTOSOS',
        'category': 'Futebol',
        'date': '05/05/2025',
        'location': 'Estádio Tigre',
        'title': 'Amistoso com Raposa',
        'description': 'Jogo preparatório para o torneio.',
      },
      {
        'type': 'AMISTOSOS',
        'category': 'Futebol',
        'date': '05/05/2025',
        'location': 'Estádio Tigre',
        'title': 'Amistoso com Raposa',
        'description': 'Jogo preparatório para o torneio.',
      },
    ];

    final List<Map<String, dynamic>> storeCategories = [
      {
        'label': 'Canecas', 
        'icon': Icons.local_drink, 
        'category': 'CANECAS'
      },
      {
        'label': 'Roupas', 
        'icon': Icons.checkroom, 
        'category': 'ROUPAS'
      },
      {
        'label': 'Chaveiros', 
        'icon': Icons.key, 
        'category': 'CHAVEIROS'
      },
      {
        'label': 'Tatuagens', 
        'icon': Icons.brush, 
        'category': 'TATUAGENS'
      },
    ];

    final List<Map<String, String>> storeProducts = [
      {
        'name': 'Caneca Oficial', 
        'category': 'CANECAS', 
        'price': '25,00', 
        'image': 'assets/images/caneca_oficial.png'
      },
      {
        'name': 'Camiseta Masculina', 
        'category': 'ROUPAS', 
        'price': '50,00', 
        'image': 'assets/images/camisetaa_masculina.png'
      },
      {
        'name': 'Camiseta Feminina', 
        'category': 'ROUPAS', 
        'price': '50,00', 
        'image': 'assets/images/camiseta_feminina_1.png'
      },
      {
        'name': 'Chaveiro Tigre', 
        'category': 'CHAVEIROS', 
        'price': '15,00', 
        'image': 'assets/images/chaveiro.jpeg'
      },
      {
        'name': 'Tatuagem Temporária', 
        'category': 'TATUAGENS', 
        'price': '10,00', 
        'image': 'assets/images/tatuagens_temporarias.jpeg'
      },
      {
        'name': 'Caneca Personalizada', 
        'category': 'CANECAS', 
        'price': '30,00', 
        'image': 'assets/images/caneca_personalizada.jpeg'
      },
      {
        'name': 'Caneca Estampada Premium', 
        'category': 'CANECAS', 
        'price': '35,00', 
        'image': 'assets/images/caneca_estampa_premium.jpeg'
      },
      {
        'name': 'Boné Oficial', 
        'category': 'ROUPAS', 
        'price': '40,00', 
        'image': 'assets/images/bone.jpeg'
      },
    ];

    // Uncomment this when you're ready to use the real API
    // try {
    //   final newsResponse = await makeHttpRequest(context, "/news");
    //   final eventsResponse = await makeHttpRequest(context, "/events");
    //
    //   if (newsResponse.statusCode == 200 && eventsResponse.statusCode == 200) {
    //     return {
    //       'news': json.decode(newsResponse.body),
    //       'events': json.decode(eventsResponse.body),
    //     };
    //   } else {
    //     throw Exception("Erro ao carregar dados do servidor");
    //   }
    // } catch (e) {
    //   throw e;
    // }

    // Return mock data for now
    return {
      'news': news,
      'events': events,
      'trainings': trainings,
    };
  }
}