import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/utils/utils.dart';

class EventsNewsService {
  static Future<Map<String, List<Map<String, String>>>> loadData(BuildContext context) async {
    // Mock data for now
    final news = [
      {
        'imageUrl': 'https://picsum.photos/300/150',
        'date': '23/04/2025',
        'location': 'Porto Alegre',
        'title': 'Título Notícia',
        'description': 'Descrição da notícia',
      },
      {
        'imageUrl': 'https://picsum.photos/301/150',
        'date': '22/04/2025',
        'location': 'São Paulo',
        'title': 'Notícia do Backend',
        'description': 'Essa notícia veio da API.',
      },
    ];

    final events = [
      {
        'imageUrl': 'https://picsum.photos/302/150',
        'date': '31/04/2025',
        'location': 'Curitiba',
        'title': 'Título Evento',
        'description': 'Descrição do evento',
      },
      {
        'imageUrl': 'https://picsum.photos/303/150',
        'date': '30/04/2025',
        'location': 'Rio de Janeiro',
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