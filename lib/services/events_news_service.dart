import 'dart:convert';
import 'dart:io';
import 'package:app_atletica/models/training_model.dart';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/news_event_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EventsNewsService {
  // Endpoints e cache keys
  static const String _newsCache = 'news_cache';
  static const String _eventsEndpoint = '/events';
  static const String _trainingsEndpoint = '/trainings';

  Future<Map<String, dynamic>> loadData(BuildContext context) async {
    try {
      // Obtém eventos do backend e treinos mockados
      final eventsList = await getEventsFromBackend();
      final trainingsList = _getMockTrainings();
      
      // Retorna os dados no formato esperado
      return {
        'events': eventsList,
        'trainings': trainingsList,
        'news': [], // Lista vazia para news já que foi removida
      };
    } catch (e) {
      print('Erro ao carregar dados: $e');
      // Se falhar, usa dados mockados como fallback
      final eventsList = _getMockEvents();
      final trainingsList = _getMockTrainings();
      
      // Converte eventos mockados para Map<String, String>
      final formattedEvents = eventsList.map((event) => {
        'id': event.id,
        'imageUrl': event.imageUrl ?? '',
        'date': event.date,
        'location': event.location,
        'title': event.title,
        'description': event.description ?? '',
        'price': '', // Eventos mockados não têm preço
      }).toList();
      
      return {
        'events': formattedEvents,
        'trainings': trainingsList,
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

  // Métodos CRUD para Eventos
  Future<bool> createEvent({
    required String title,
    String? description,
    required String date,
    required String location,
    String? price,
    String? type,
    String? imageUrl,
  }) async {
    try {
      final baseUrl = ApiService.baseUrl;
      
      final Map<String, dynamic> eventData = {
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'price': price,
        'type': type ?? 'party',
      };

      // Adiciona imageUrl apenas se foi fornecida
      if (imageUrl != null && imageUrl.isNotEmpty) {
        eventData['imageUrl'] = imageUrl;
      }

      print('=== CRIANDO EVENTO ===');
      print('Dados do evento: $eventData');

      final response = await http.post(
        Uri.parse('$baseUrl/events'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(eventData),
      );
      
      print('Status Code: ${response.statusCode}');
      print('Resposta: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Evento criado com sucesso!');
        return true;
      } else {
        print('Erro ao criar evento: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar evento: $e');
      return false;
    }
  }

  Future<bool> updateEvent({
    required String eventId,
    required String title,
    required String description,
    required String date,
    required String location,
    String? price,
    String? type,
    String? imageUrl,
  }) async {
    try {
      final baseUrl = ApiService.baseUrl;
      
      final Map<String, dynamic> eventData = {
        'title': title,
        'description': description,
        'date': date,
        'location': location,
        'price': price,
        'type': type ?? 'party',
      };

      // Adiciona imageUrl apenas se foi fornecida
      if (imageUrl != null && imageUrl.isNotEmpty) {
        eventData['imageUrl'] = imageUrl;
      }

      print('=== ATUALIZANDO EVENTO ===');
      print('ID do evento: $eventId');
      print('Dados do evento: $eventData');

      final response = await http.put(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(eventData),
      );
      
      print('Status Code: ${response.statusCode}');
      print('Resposta: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Evento atualizado com sucesso!');
        return true;
      } else {
        print('Erro ao atualizar evento: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar evento: $e');
      return false;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    if (eventId.isEmpty) {
      print('Erro: ID do evento não pode estar vazio');
      return false;
    }
    
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.delete(
        Uri.parse('$baseUrl/events/$eventId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao excluir evento: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao excluir evento: $e');
      return false;
    }
  }

  // Métodos CRUD para Notícias
  Future<bool> createNews({
    required String title,
    String? description,
    required String date,
    String? author,
  }) async {
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'date': date,
          'author': author,
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

  Future<bool> updateNews({
    required String newsId,
    required String title,
    required String description,
    required String date,
    String? author,
  }) async {
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.put(
        Uri.parse('$baseUrl/news/$newsId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'date': date,
          'author': author,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao atualizar notícia: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar notícia: $e');
      return false;
    }
  }

  Future<bool> deleteNews(String newsId) async {
    if (newsId.isEmpty) {
      print('Erro: ID da notícia não pode estar vazio');
      return false;
    }
    
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.delete(
        Uri.parse('$baseUrl/news/$newsId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao excluir notícia: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao excluir notícia: $e');
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
            'imageUrl': item['imageUrl'] ?? '', // Campo de imagem do backend
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
        
        final newsList = data.map<Map<String, String>>((item) {
          return <String, String>{
            'id': (item['id'] ?? '').toString(),
            'title': (item['title'] ?? '').toString(),
            'description': (item['description'] ?? '').toString(),
            'date': (item['date'] ?? '').toString(), // MANTÉM formato ISO
            'author': (item['author'] ?? '').toString(),
            'imageUrl': (item['imageUrl'] ?? '').toString(), // Campo de imagem do backend
            'location': '', // Adapte se houver local
          };
        }).toList();
        
        return newsList;
      } else {
        print('Erro ao buscar notícias: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar notícias: $e');
      return [];
    }
  }
  // Método para buscar evento específico por ID
  Future<Map<String, String>?> getEventById(String eventId) async {
    try {
      final baseUrl = ApiService.baseUrl;
      final response = await http.get(Uri.parse('$baseUrl/events/$eventId'));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final Map<String, dynamic> data = json['data'] ?? {};
        return {
          'id': data['id']?.toString() ?? '',
          'title': data['title']?.toString() ?? '',
          'description': data['description']?.toString() ?? '',
          'date': data['date']?.toString() ?? '',
          'location': data['location']?.toString() ?? '',
          'price': data['price']?.toString() ?? '',
          'type': data['type']?.toString() ?? '',
          'imageUrl': data['imageUrl']?.toString() ?? '',
        };
      } else {
        print('Erro ao buscar evento $eventId: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar evento $eventId: $e');
      return null;
    }
  }

  // ========== MÉTODOS DE UPLOAD DE IMAGEM ==========
  
  // Método para fazer upload de imagem - Específico para o seu backend (Notícias)
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Valida se o arquivo é uma imagem válida
      if (!_isValidImageFile(imageFile.path)) {
        print('Arquivo não é uma imagem válida: ${imageFile.path}');
        return null;
      }
      
      final baseUrl = ApiService.baseUrl;
      print('=== UPLOAD DE IMAGEM (NOTÍCIA) ===');
      print('BaseURL: $baseUrl');
      print('URL completa: $baseUrl/upload/news-image');
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/news-image'));
      
      // Adiciona o arquivo à requisição usando o campo 'file' como especificado
      final contentType = _getContentType(imageFile.path);
      
      // Como fallback, força JPEG se não conseguiu detectar o tipo
      final finalContentType = contentType.mimeType == 'image/jpeg' && 
          !imageFile.path.toLowerCase().contains('.jpg') && 
          !imageFile.path.toLowerCase().contains('.jpeg') 
        ? MediaType('image', 'jpeg')
        : contentType;
      
      final multipartFile = await http.MultipartFile.fromPath(
        'file', // Campo específico do seu backend
        imageFile.path,
        contentType: finalContentType,
        filename: 'image.jpg', // Nome explícito com extensão
      );
      
      print('ContentType definido: ${finalContentType.mimeType}');
      print('Nome do arquivo original: ${imageFile.path.split('/').last}');
      print('Nome do arquivo enviado: image.jpg');
      
      request.files.add(multipartFile);
      
      // Adiciona headers
      request.headers.addAll({
        'Accept': 'application/json',
      });
      
      print('Enviando imagem para: $baseUrl/upload/news-image');
      print('Arquivo: ${imageFile.path}');
      
      final response = await request.send();
      
      print('Status Code: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        
        print('Resposta do upload: $jsonData');
        
        // Extrai a URL conforme a estrutura do seu backend
        String? imageUrl = jsonData['data']?['url'];
        
        if (imageUrl != null) {
          print('Upload bem-sucedido. URL da imagem: $imageUrl');
          return imageUrl; // Retorna "/uploads/news/filename.jpg"
        } else {
          print('URL da imagem não encontrada na resposta');
          return null;
        }
      } else {
        print('Erro no upload da imagem: ${response.statusCode}');
        final responseData = await response.stream.bytesToString();
        print('Resposta de erro: $responseData');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  // Método para fazer upload de imagem de evento - Específico para eventos
  Future<String?> uploadEventImage(File imageFile) async {
    try {
      // Valida se o arquivo é uma imagem válida
      if (!_isValidImageFile(imageFile.path)) {
        print('Arquivo não é uma imagem válida: ${imageFile.path}');
        return null;
      }
      
      final baseUrl = ApiService.baseUrl;
      print('=== UPLOAD DE IMAGEM (EVENTO) ===');
      print('BaseURL: $baseUrl');
      print('URL completa: $baseUrl/upload/event-image');
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/event-image'));
      
      // Adiciona o arquivo à requisição usando o campo 'file' como especificado
      final contentType = _getContentType(imageFile.path);
      
      // Como fallback, força JPEG se não conseguiu detectar o tipo
      final finalContentType = contentType.mimeType == 'image/jpeg' && 
          !imageFile.path.toLowerCase().contains('.jpg') && 
          !imageFile.path.toLowerCase().contains('.jpeg') 
        ? MediaType('image', 'jpeg')
        : contentType;
      
      final multipartFile = await http.MultipartFile.fromPath(
        'file', // Campo específico do seu backend
        imageFile.path,
        contentType: finalContentType,
        filename: 'event_image.jpg', // Nome explícito com extensão
      );
      
      print('ContentType definido: ${finalContentType.mimeType}');
      print('Nome do arquivo original: ${imageFile.path.split('/').last}');
      print('Nome do arquivo enviado: event_image.jpg');
      
      request.files.add(multipartFile);
      
      // Adiciona headers
      request.headers.addAll({
        'Accept': 'application/json',
      });
      
      print('Enviando imagem para: $baseUrl/upload/event-image');
      print('Arquivo: ${imageFile.path}');
      
      final response = await request.send();
      
      print('Status Code: ${response.statusCode}');
      
      if (response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final jsonData = json.decode(responseData);
        
        print('Resposta do upload: $jsonData');
        
        // Extrai a URL conforme a estrutura do seu backend
        String? imageUrl = jsonData['data']?['url'];
        
        if (imageUrl != null) {
          print('Upload bem-sucedido. URL da imagem do evento: $imageUrl');
          return imageUrl; // Retorna "/uploads/events/filename.jpg"
        } else {
          print('URL da imagem não encontrada na resposta');
          return null;
        }
      } else {
        print('Erro no upload da imagem do evento: ${response.statusCode}');
        final responseData = await response.stream.bytesToString();
        print('Resposta de erro: $responseData');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem do evento: $e');
      return null;
    }
  }

  // Método atualizado para criar notícia com imagem
  Future<bool> createNewsWithImage({
    required String title,
    String? description,
    required String date,
    String? author,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      
      // Faz upload da imagem primeiro, se fornecida
      if (imageFile != null) {
        print('Iniciando upload da imagem...');
        imageUrl = await uploadImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da imagem - continuando sem imagem');
          // Continua sem a imagem se o upload falhar
        } else {
          print('Upload da imagem bem-sucedido: $imageUrl');
        }
      }
      
      final baseUrl = ApiService.baseUrl;
      
      print('=== CRIAR NOTÍCIA ===');
      print('BaseURL: $baseUrl');
      print('URL completa: $baseUrl/news');
      
      // Monta o body da requisição conforme especificação do seu backend
      Map<String, dynamic> requestBody = {
        'title': title,
        'description': description,
        'date': date,
        'author': author,
      };
      
      // Adiciona imageUrl apenas se o upload foi bem-sucedido
      if (imageUrl != null) {
        requestBody['imageUrl'] = imageUrl;
      }
      
      print('Criando notícia com dados: $requestBody');
      
      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Notícia criada com sucesso');
        return true;
      } else {
        print('Erro ao criar notícia: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar notícia: $e');
      return false;
    }
  }

  // Método atualizado para atualizar notícia com imagem
  Future<bool> updateNewsWithImage({
    required String newsId,
    required String title,
    required String description,
    required String date,
    String? author,
    File? imageFile,
  }) async {
    try {
      String? imageUrl;
      
      // Faz upload da nova imagem, se fornecida
      if (imageFile != null) {
        print('Iniciando upload da nova imagem...');
        imageUrl = await uploadImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da nova imagem - continuando sem atualizar a imagem');
          // Continua sem atualizar a imagem se o upload falhar
        } else {
          print('Upload da nova imagem bem-sucedido: $imageUrl');
        }
      }
      
      final baseUrl = ApiService.baseUrl;
      
      // Monta o body da requisição conforme especificação do seu backend
      Map<String, dynamic> requestBody = {
        'title': title,
        'description': description,
        'date': date,
        'author': author,
      };
      
      // Adiciona imageUrl apenas se foi feito upload de uma nova imagem
      if (imageUrl != null) {
        requestBody['imageUrl'] = imageUrl;
      }
      
      print('Atualizando notícia $newsId com dados: $requestBody');
      
      final response = await http.put(
        Uri.parse('$baseUrl/news/$newsId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Notícia atualizada com sucesso');
        return true;
      } else {
        print('Erro ao atualizar notícia: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar notícia: $e');
      return false;
    }
  }

  // Método para construir URL completa da imagem
  String getFullImageUrl(String imageUrl) {
    final baseUrl = ApiService.baseUrl;
    
    if (imageUrl.startsWith('http')) {
      return imageUrl; // Já é uma URL completa
    }
    
    // Remove '/api' do baseUrl para imagens, pois elas são servidas diretamente pelo servidor
    // Exemplo: baseUrl = "http://192.168.1.2:3001/api" -> "http://192.168.1.2:3001"
    final baseUrlWithoutApi = baseUrl.replaceAll('/api', '');
    final fullUrl = '$baseUrlWithoutApi$imageUrl';
    
    return fullUrl;
  }

  // Método auxiliar para determinar o contentType baseado na extensão do arquivo
  MediaType _getContentType(String filePath) {
    // Usa o pacote mime para detectar automaticamente o tipo
    final mimeType = lookupMimeType(filePath);
    
    if (mimeType != null) {
      final parts = mimeType.split('/');
      return MediaType(parts[0], parts[1]);
    }
    
    // Fallback manual baseado na extensão
    final extension = filePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      default:
        return MediaType('image', 'jpeg'); // Fallback para JPEG
    }
  }

  // Método auxiliar para validar se o arquivo é uma imagem válida
  bool _isValidImageFile(String filePath) {
    final validExtensions = ['jpg', 'jpeg', 'png', 'gif'];
    final extension = filePath.toLowerCase().split('.').last;
    
    // Verifica extensão
    if (!validExtensions.contains(extension)) {
      return false;
    }
    
    // Verifica MIME type
    final mimeType = lookupMimeType(filePath);
    if (mimeType == null || !mimeType.startsWith('image/')) {
      return false;
    }
    
    return true;
  }

  // Método para criar evento com upload de imagem
  Future<bool> createEventWithImage({
    required String title,
    String? description,
    required String date,
    required String location,
    String? price,
    String? type,
    File? imageFile,
  }) async {
    String? imageUrl;
    
    try {
      // Faz upload da imagem primeiro, se fornecida
      if (imageFile != null) {
        print('Iniciando upload da imagem do evento...');
        imageUrl = await uploadEventImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da imagem - continuando sem imagem');
          // Continua sem a imagem se o upload falhar
        } else {
          print('Upload da imagem bem-sucedido: $imageUrl');
        }
      }

      // Cria o evento (com ou sem imagem)
      return await createEvent(
        title: title,
        description: description,
        date: date,
        location: location,
        price: price,
        type: type,
        imageUrl: imageUrl,
      );

    } catch (e) {
      print('Erro ao criar evento com imagem: $e');
      return false;
    }
  }

  // Método para atualizar evento com upload de imagem
  Future<bool> updateEventWithImage({
    required String eventId,
    required String title,
    required String description,
    required String date,
    required String location,
    String? price,
    String? type,
    File? imageFile,
  }) async {
    String? imageUrl;
    
    try {
      // Faz upload da nova imagem, se fornecida
      if (imageFile != null) {
        print('Iniciando upload da nova imagem do evento...');
        imageUrl = await uploadEventImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da nova imagem - mantendo imagem anterior');
          // Continua sem atualizar a imagem se o upload falhar
        } else {
          print('Upload da nova imagem bem-sucedido: $imageUrl');
        }
      }

      // Atualiza o evento (com ou sem nova imagem)
      return await updateEvent(
        eventId: eventId,
        title: title,
        description: description,
        date: date,
        location: location,
        price: price,
        type: type,
        imageUrl: imageUrl,
      );

    } catch (e) {
      print('Erro ao atualizar evento com imagem: $e');
      return false;
    }
  }
}