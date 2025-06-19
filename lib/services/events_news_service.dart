import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/event_model.dart';
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

  // URL base da API para eventos - usando seu IP local
  static String getBaseUrl() {
    if (kIsWeb) {
      return 'http://127.0.0.1:3001/api';
    } else if (Platform.isAndroid) {
      return 'http://192.168.3.108:3001/api';
    } else {
      return 'http://192.168.3.108:3001/api';
    }
  }

  static Future<Map<String, dynamic>> loadData(BuildContext context) async {
    try {
      // Tentativa de carregar dados reais do backend
      final eventsData = await getEvents(context);
      final newsMockData = _getMockNews();
      final trainingsMockData = _getMockTrainings();

      return {
        'news': newsMockData, // Ainda usando mock para notícias
        'events': eventsData, // Usando dados reais para eventos
        'trainings': trainingsMockData // Ainda usando mock para treinos
      };
    } catch (e) {
      print('Erro ao carregar dados reais: $e');
      print('Voltando para dados mockados...');
      
      // Em caso de falha, usamos os dados mockados
      return {
        'news': _getMockNews(),
        'events': _getMockEvents(),
        'trainings': _getMockTrainings()
      };
    }
  }

  // Método para buscar eventos reais do backend
  static Future<List<Map<String, dynamic>>> getEvents(BuildContext context) async {
    final baseUrl = getBaseUrl();
    final endpoint = '/events'; // Endpoint específico para eventos
    
    print('Fazendo requisição para eventos: $baseUrl$endpoint');
    
    try {
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(Uri.parse('$baseUrl$endpoint'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Status code (eventos): ${response.statusCode}');
      print('Response body (eventos): ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Extrair a lista de eventos da resposta
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> eventsData = responseData['data'];
          print('Eventos recebidos da API: ${eventsData.length}');

          // Convertendo para o formato esperado pela aplicação
          return List<Map<String, dynamic>>.from(eventsData);
        } else {
          print('Formato de resposta para eventos inesperado: ${response.body}');
          // Se o formato não for o esperado, retornamos dados mockados
          return _getMockEvents();
        }
      } else {
        print('Erro HTTP ao buscar eventos: ${response.statusCode}');
        throw Exception('Falha ao carregar eventos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      // Em caso de erro, retornamos dados mockados
      return _getMockEvents();
    }
  }

  // Dados mockados para notícias
  static List<Map<String, dynamic>> _getMockNews() {
    return [
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
  }
  
  // Dados mockados para eventos
  static List<Map<String, dynamic>> _getMockEvents() {
    return [
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
  }
  
  // Dados mockados para treinos
  static List<Map<String, dynamic>> _getMockTrainings() {
    return [
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
  }
}