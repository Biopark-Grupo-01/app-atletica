import 'dart:convert';
import 'package:app_atletica/models/training_model.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/news_event_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';
import 'package:app_atletica/models/news_model.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class EventsNewsService {
  // Endpoints e cache keys
  static const String _newsEndpoint = '/news';
  static const String _newsCache = 'news_cache';
  static const String _eventsEndpoint = '/events';
  static const String _trainingsEndpoint = '/trainings';

  Future<Map<String, dynamic>> loadData(BuildContext context) async {
    try {
      // Obtém eventos e treinos
      final eventsList = _getMockEvents();
      final trainingsList = _getMockTrainings();
      
      // Converte eventos para Map<String, String>
      final formattedEvents = eventsList.map((event) => {
        'id': event.id,
        'imageUrl': event.imageUrl ?? '',
        'date': event.date,
        'location': event.location,
        'title': event.title,
        'description': event.description ?? '',
      }).toList();
      
      // Retorna os dados no formato esperado
      return {
        'events': formattedEvents,
        'trainings': trainingsList,
        'news': [], // Lista vazia para news já que foi removida
      };
    } catch (e) {
      print('Erro ao carregar dados: $e');
      return {
        'events': <Map<String, String>>[],
        'trainings': <Training>[],
        'news': <Map<String, String>>[],
      };
    }
  }

  // Método para carregar eventos com cache
  Future<List<EventModel>> getEvents(BuildContext context) async {
    try {
      if (ApiService.useMockData) {
        final mockData = _getMockEvents();
        // Salva os dados mockados no cache também
        await LocalStorageService.cacheEvents(mockData.map((e) => e.toJson()).toList());
        return mockData;
      } else {
        // Usa o sistema de cache do ApiService
        final response = await ApiService.get(
          context, 
          _eventsEndpoint,
          useCache: true,
          cacheKey: _newsCache,
        );
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => EventModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar eventos: $e');
      
      // Tenta obter dados do cache
      final cachedData = await LocalStorageService.getCachedEvents();
      if (cachedData != null) {
        return cachedData.map((item) => EventModel.fromJson(item)).toList();
      }
      
      // Se não há cache, retorna dados mockados
      return _getMockEvents();
    }
  }

    final List<Training> trainings = [
      Training(
        id: '1',
        title: 'Treino de Arremesso',
        description: 'Foco em fundamentos e agilidade.',
        modality: 'Basquete',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Ginásio Central',
        date: '03/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
      Training(
        id: '2',
        title: 'Amistoso com Raposa',
        description: 'Jogo preparatório para o torneio.',
        modality: 'Futebol',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Estádio Tigre',
        date: '05/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
      Training(
        id: '3',
        title: 'Amistoso com Raposa',
        description: 'Jogo preparatório para o torneio.',
        modality: 'Futebol',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Estádio Tigre',
        date: '05/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
    ];


    final List<Map<String, dynamic>> storeCategories = [
      // {
      //   'label': 'Canecas', 
      //   'icon': Icons.local_drink, 
      //   'category': 'CANECAS'
      // },
      // {
      //   'label': 'Roupas', 
      //   'icon': Icons.checkroom, 
      //   'category': 'ROUPAS'
      // },
      // {
      //   'label': 'Chaveiros', 
      //   'icon': Icons.key, 
      //   'category': 'CHAVEIROS'
      // },
      // {
      //   'label': 'Tatuagens', 
      //   'icon': Icons.brush, 
      //   'category': 'TATUAGENS'
      // },
    ];

  // Método para adicionar ou atualizar um evento
  Future<bool> saveEvent(BuildContext context, EventModel event) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final endpoint = event.id.isNotEmpty ? '$_eventsEndpoint/${event.id}' : _eventsEndpoint;
        final method = event.id.isNotEmpty ? 'put' : 'post';
        
        if (method == 'put') {
          await ApiService.put(context, endpoint, body: event.toJson());
        } else {
          await ApiService.post(context, endpoint, body: event.toJson());
        }
        
        return true;
      }
    } catch (e) {
      print('Erro ao salvar evento: $e');
      return false;
    }
  }

  // Método para adicionar ou atualizar um treino
  Future<bool> saveTraining(BuildContext context, Training training) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final endpoint = training.id.isNotEmpty ? '$_trainingsEndpoint/${training.id}' : _trainingsEndpoint;
        final method = training.id.isNotEmpty ? 'put' : 'post';
        
        if (method == 'put') {
          await ApiService.put(context, endpoint, body: training.toMapForUI());
        } else {
          await ApiService.post(context, endpoint, body: training.toMapForUI());
        }
        
        return true;
      }
    } catch (e) {
      print('Erro ao salvar treino: $e');
      return false;
    }
  }

  // Método para obter eventos como uma lista de Map<String, String>
  Future<List<Map<String, String>>> getEventsAsDisplayMap(BuildContext context) async {
    try {
      final eventsList = await getEvents(context);
      return eventsList.map((event) => {
        'id': event.id,
        'imageUrl': event.imageUrl ?? '',
        'date': event.date,
        'location': event.location,
        'title': event.title,
        'description': event.description ?? '',
      }).toList();
    } catch (e) {
      print('Erro ao converter eventos para DisplayMap: $e');
      return [];
    }
  }

  // Remover este método antigo createNews
  // Dados mockados para eventos
  List<EventModel> _getMockEvents() {
    return [
      EventModel(
        id: '1',
        imageUrl: 'https://picsum.photos/302/150',
        date: '09/05/2025',
        location: 'Toledo',
        title: 'Confraternização Semana Acadêmica',
        description: 'Ocorrerá uma festa para o fim da semana acadêmica',
        price: '25,00',
      ),
      EventModel(
        id: '2',
        imageUrl: 'https://picsum.photos/303/150',
        date: '30/05/2025',
        location: 'Toledo',
        title: 'Evento da API',
        description: 'Evento vindo do back-end.',
        price: '50,00',
      ),
      EventModel(
        id: '3',
        imageUrl: 'https://picsum.photos/305/150',
        date: '15/06/2025',
        location: 'Toledo',
        title: 'Festa Junina da Atlética',
        description: 'Tradicional festa com comidas típicas, música e muita diversão.',
        price: '35,00',
      ),
    ];
  }

  // Dados mockados para treinos
  List<Training> _getMockTrainings() {
    return [
      Training(
        id: '1',
        title: 'Treino de Arremesso',
        description: 'Foco em fundamentos e agilidade.',
        modality: 'Basquete',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Ginásio Central',
        date: '03/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
      Training(
        id: '2',
        title: 'Amistoso com Raposa',
        description: 'Jogo preparatório para o torneio.',
        modality: 'Futebol',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Estádio Tigre',
        date: '05/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
      Training(
        id: '3',
        title: 'Amistoso com Raposa',
        description: 'Jogo preparatório para o torneio.',
        modality: 'Futebol',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Estádio Tigre',
        date: '05/05/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
      Training(
        id: '4',
        title: 'Treino de Manchete',
        description: 'Aprimoramento de técnicas de defesa e recepção.',
        modality: 'Vôlei',
        coach: 'Não informado',
        responsible: 'Não informado',
        place: 'Quadra Poliesportiva',
        date: '12/06/2025',
        time: '00:00:00',
        isSubscribed: false,
      ),
    ];
  }

  Future<bool> createNews({
    required String title,
    required String description,
    required String author,
    String? imageUrl,
    String? date,
    String? time,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final nowLocal = DateTime.now();
      // Monta a data no formato yyyy-MM-dd HH:mm:ss
      String dateTimeStr;
      if (date != null && time != null) {
        dateTimeStr = "$date $time";
      } else {
        dateTimeStr =
            "${nowLocal.year.toString().padLeft(4, '0')}-"
            "${nowLocal.month.toString().padLeft(2, '0')}-"
            "${nowLocal.day.toString().padLeft(2, '0')} "
            "${nowLocal.hour.toString().padLeft(2, '0')}:"
            "${nowLocal.minute.toString().padLeft(2, '0')}:"
            "${nowLocal.second.toString().padLeft(2, '0')}";
      }
      print('[createNews] Enviando: date=$dateTimeStr, nowLocal=$nowLocal');
      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'author': author,
          'imageUrl': imageUrl,
          'date': dateTimeStr,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao criar notícia: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar notícia: $e');
      return false;
    }
  }

  // Método para buscar eventos do backend
  Future<List<Map<String, String>>> getEventsFromBackend() async {
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.get(Uri.parse('$baseUrl/events'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map<Map<String, String>>((item) {
          return {
            'id': item['id'] ?? '',
            'title': item['title'] ?? '',
            'description': item['description'] ?? '',
            'date': item['date'] ?? '', // MANTÉM formato ISO
            'location': item['location'] ?? '',
            'price': item['price'] ?? '',
            'type': item['type'] ?? '',
            'imageUrl': '', // Adapte se houver imagem no futuro
          };
        }).toList();
      } else {
        print('Erro ao buscar eventos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar eventos: $e');
      return [];
    }
  }

  // Método para buscar notícias do backend
  Future<List<Map<String, String>>> getNewsFromBackend() async {
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.get(Uri.parse('$baseUrl/news'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final List<dynamic> data = json['data'] ?? [];
        return data.map<Map<String, String>>((item) {
          return {
            'id': item['id'] ?? '',
            'title': item['title'] ?? '',
            'description': item['description'] ?? '',
            'date': item['date'] ?? '', // MANTÉM formato ISO
            'author': item['author'] ?? '',
            'imageUrl': '', // Adapte se houver imagem
            'location': '', // Adapte se houver local
          };
        }).toList();
      } else {
        print('Erro ao buscar notícias: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias: $e');
      return [];
    }
  }
}