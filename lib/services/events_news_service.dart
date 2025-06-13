import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/news_event_model.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';

class EventsNewsService {
  // URLs dos endpoints
  static const String _newsEndpoint = '/api/news';
  static const String _eventsEndpoint = '/api/events';
  static const String _trainingsEndpoint = '/api/trainings';
  
  // Chaves para cache
  static const String _newsCache = 'news_cache';
  static const String _eventsCache = 'events_cache';
  static const String _trainingsCache = 'trainings_cache';

  static Future<Map<String, dynamic>> loadData(BuildContext context) async {
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
        'description': 'Ocorrerá uma festa para o fim da semana acadêmica',
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
        'id': '1',
        'title': 'Treino de Arremesso',
        'description': 'Foco em fundamentos e agilidade.',
        'type': 'TREINOS',
        'category': 'Basquete',
        'date': '03/05/2025',
        'location': 'Ginásio Central',
      },
      {
        'id': '2',
        'title': 'Amistoso com Raposa',
        'description': 'Jogo preparatório para o torneio.',
        'type': 'AMISTOSOS',
        'category': 'Futebol',
        'date': '05/05/2025',
        'location': 'Estádio Tigre',
      },
    ];

    return {
      'news': news,
      'events': events, 
      'trainings': trainings
    };
  }
}