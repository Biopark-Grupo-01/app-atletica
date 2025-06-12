// import 'dart:convert';
import 'package:app_atletica/models/training_model.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/news_event_model.dart';
import 'package:app_atletica/models/training_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';

class EventsNewsService {
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

  // Método para carregar notícias com cache
  static Future<List<NewsModel>> getNews(BuildContext context) async {
    try {
      if (ApiService.useMockData) {
        final mockData = _getMockNews();
        // Salva os dados mockados no cache também
        await LocalStorageService.cacheNews(mockData.map((e) => e.toJson()).toList());
        return mockData;
      } else {
        // Usa o sistema de cache do ApiService
        final response = await ApiService.get(
          context, 
          _newsEndpoint,
          useCache: true,
          cacheKey: _newsCache,
        );
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => NewsModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar notícias: $e');
      
      // Tenta obter dados do cache
      final cachedData = await LocalStorageService.getCachedNews();
      if (cachedData != null) {
        return cachedData.map((item) => NewsModel.fromJson(item)).toList();
      }
      
      // Se não há cache, retorna dados mockados
      return _getMockNews();
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

  // Método para adicionar ou atualizar uma notícia
  static Future<bool> saveNews(BuildContext context, NewsModel news) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final endpoint = news.id.isNotEmpty ? '$_newsEndpoint/${news.id}' : _newsEndpoint;
        final method = news.id.isNotEmpty ? 'put' : 'post';
        
        if (method == 'put') {
          await ApiService.put(context, endpoint, body: news.toJson());
        } else {
          await ApiService.post(context, endpoint, body: news.toJson());
        }
        
        return true;
      }
    } catch (e) {
      print('Erro ao salvar notícia: $e');
      return false;
    }
  }

  // Método para adicionar ou atualizar um evento
  static Future<bool> saveEvent(BuildContext context, EventModel event) async {
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
  static Future<bool> saveTraining(BuildContext context, TrainingModel training) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final endpoint = training.id.isNotEmpty ? '$_trainingsEndpoint/${training.id}' : _trainingsEndpoint;
        final method = training.id.isNotEmpty ? 'put' : 'post';
        
        if (method == 'put') {
          await ApiService.put(context, endpoint, body: training.toJson());
        } else {
          await ApiService.post(context, endpoint, body: training.toJson());
        }
        
        return true;
      }
    } catch (e) {
      print('Erro ao salvar treino: $e');
      return false;
    }
  }

  // Dados mockados para notícias
  static List<NewsModel> _getMockNews() {
    return [
      NewsModel(
        id: '1',
        imageUrl: 'https://picsum.photos/300/150',
        date: '15/05/2025',
        location: 'Toledo',
        title: 'Acesso Rápido',
        description: 'Foi realizado alterações nos botões de acesso rápido',
      ),
      NewsModel(
        id: '2',
        imageUrl: 'https://picsum.photos/301/150',
        date: '22/05/2025',
        location: 'Toledo',
        title: 'Notícia do Backend',
        description: 'Essa notícia veio da API.',
      ),
      NewsModel(
        id: '3',
        imageUrl: 'https://picsum.photos/304/150',
        date: '04/06/2025',
        location: 'Toledo',
        title: 'Nova Integração',
        description: 'Sistema integrado com back-end para comunicação mais efetiva.',
      ),
    ];
  }

  // Dados mockados para eventos
  static List<EventModel> _getMockEvents() {
    return [
      EventModel(
        id: '1',
        imageUrl: 'https://picsum.photos/302/150',
        date: '09/05/2025',
        location: 'Toledo',
        title: 'Confraternização Semana Acadêmica',
        description: 'Ocorrerá uma festa para o fim da semana acadêmica',
      ),
      EventModel(
        id: '2',
        imageUrl: 'https://picsum.photos/303/150',
        date: '30/05/2025',
        location: 'Toledo',
        title: 'Evento da API',
        description: 'Evento vindo do back-end.',
      ),
      EventModel(
        id: '3',
        imageUrl: 'https://picsum.photos/305/150',
        date: '15/06/2025',
        location: 'Toledo',
        title: 'Festa Junina da Atlética',
        description: 'Tradicional festa com comidas típicas, música e muita diversão.',
      ),
    ];
  }

  // Dados mockados para treinos
  static List<TrainingModel> _getMockTrainings() {
    return [
      TrainingModel(
        id: '1',
        type: 'TREINOS',
        category: 'Basquete',
        date: '03/05/2025',
        location: 'Ginásio Central',
        title: 'Treino de Arremesso',
        description: 'Foco em fundamentos e agilidade.',
      ),
      TrainingModel(
        id: '2',
        type: 'AMISTOSOS',
        category: 'Futebol',
        date: '05/05/2025',
        location: 'Estádio Tigre',
        title: 'Amistoso com Raposa',
        description: 'Jogo preparatório para o torneio.',
      ),
      TrainingModel(
        id: '3',
        type: 'AMISTOSOS',
        category: 'Futsal',
        date: '10/06/2025',
        location: 'Ginásio de Esportes',
        title: 'Amistoso de Integração',
        description: 'Jogo amistoso entre turmas do curso.',
      ),
      TrainingModel(
        id: '4',
        type: 'TREINOS',
        category: 'Vôlei',
        date: '12/06/2025',
        location: 'Quadra Poliesportiva',
        title: 'Treino de Manchete',
        description: 'Aprimoramento de técnicas de defesa e recepção.',
      ),
    ];
  }
}