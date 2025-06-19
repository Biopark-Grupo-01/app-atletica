import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:app_atletica/models/news_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _newsEndpoint = '/news';
  static const String _newsCacheKey = 'news_cache';
  static const String _imageUploadEndpoint = '/upload-image';

  /// Método para carregar os dados das notícias.
  /// Simplificado para retornar apenas notícias.
  Future<Map<String, dynamic>> loadData(BuildContext context) async {
    try {
      final newsList = await getNews(context);
      // Retorna os dados no formato esperado, apenas com notícias
      return {
        'news': newsList.map((news) => news.toJson()).toList(), // Converte News para Map
      };
    } catch (e) {
      debugPrint('Erro ao carregar dados das notícias: $e');
      return {
        'news': <Map<String, dynamic>>[],
      };
    }
  }

  /// Método para carregar notícias com cache, utilizando ApiService.
  Future<List<News>> getNews(BuildContext context) async {
    try {
      if (ApiService.useMockData) {
        final mockData = _getMockNews();
        // Converte os dados mockados para o modelo News
        final List<News> newsModels = mockData.map((e) => News.fromJson(e)).toList();
        await LocalStorageService.cacheNews(newsModels.map((e) => e.toJson()).toList());
        return newsModels;
      } else {
        final response = await ApiService.get(
          context,
          _newsEndpoint,
          useCache: true,
          cacheKey: _newsCacheKey,
        );

        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('data') && responseBody['data'] is List) {
          final List<dynamic> data = responseBody['data'];
          debugPrint('${data.length} notícias recebidas da API');
          return data.map((item) => News.fromJson(item)).toList();
        } else {
          throw Exception('Resposta inesperada da API (notícias): Campo "data" ausente ou não é lista.');
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar notícias: $e');

      // Tenta obter dados do cache como fallback
      final cachedData = await LocalStorageService.getCachedNews();
      if (cachedData != null && cachedData.isNotEmpty) {
        debugPrint('Notícias carregadas do cache como fallback (${cachedData.length})');
        return cachedData.map((item) => News.fromJson(item)).toList();
      }

      debugPrint('Não há cache e erro na API, usando dados mockados para notícias.');
      // Se não há cache e API falhou, retorna dados mockados
      return _getMockNews().map((e) => News.fromJson(e)).toList();
    }
  }

  /// Método para criar uma nova notícia.
  Future<News> createNews(BuildContext context, News news) async {
    try {
      if (ApiService.useMockData) {
        await Future.delayed(const Duration(seconds: 1)); // Simula atraso
        debugPrint('Simulando criação de notícia em modo mock.');
        // Retorna uma nova instância de News com um ID mockado
        return News(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
          title: news.title,
          date: news.date,
          description: news.description,
          imageUrl: news.imageUrl,
        );
      } else {
        final response = await ApiService.post(
          context,
          _newsEndpoint,
          body: news.toJson(),
        );

        final Map<String, dynamic> responseBody = json.decode(response.body);
        if (responseBody.containsKey('data')) {
          debugPrint('Notícia criada com sucesso: ${responseBody['data']['_id']}');
          return News.fromJson(responseBody['data']);
        } else {
          throw Exception('Resposta inesperada ao criar notícia: Campo "data" ausente.');
        }
      }
    } catch (e) {
      debugPrint('Erro ao criar notícia: $e');
      rethrow; // Relança a exceção para que a UI possa tratá-la
    }
  }

  /// Método para atualizar uma notícia existente.
  Future<bool> updateNews(BuildContext context, News news) async {
    try {
      if (news.id.isEmpty) { // Agora 'id' é sempre String, verifica se está vazio
        throw Exception('ID da notícia é necessário para atualização.');
      }
      if (ApiService.useMockData) {
        await Future.delayed(const Duration(seconds: 1)); // Simula atraso
        debugPrint('Simulando atualização de notícia em modo mock.');
        return true;
      } else {
        final endpoint = '$_newsEndpoint/${news.id}';
        await ApiService.put(
          context,
          endpoint,
          body: news.toJson(), // Usa o toJson do modelo News
        );
        debugPrint('Notícia atualizada com sucesso: ${news.id}');
        return true;
      }
    } catch (e) {
      debugPrint('Erro ao atualizar notícia: $e');
      return false; // Retorna false em caso de erro na atualização
    }
  }

  /// Método para deletar uma notícia.
  Future<bool> deleteNews(BuildContext context, String newsId) async {
    try {
      if (newsId.isEmpty) {
        throw Exception('ID da notícia é necessário para deletar.');
      }
      if (ApiService.useMockData) {
        await Future.delayed(const Duration(seconds: 1)); // Simula atraso
        debugPrint('Simulando exclusão de notícia em modo mock.');
        return true;
      } else {
        final endpoint = '$_newsEndpoint/$newsId';
        await ApiService.delete(context, endpoint);
        debugPrint('Notícia deletada com sucesso: $newsId');
        return true;
      }
    } catch (e) {
      debugPrint('Erro ao deletar notícia: $e');
      return false; // Retorna false em caso de erro na exclusão
    }
  }

  /// Método para upload de imagem, utilizando ApiService para padronização.
  Future<String> uploadImage(BuildContext context, File imageFile) async {
    try {
      final url = Uri.parse('${ApiService.getBaseUrl()}$_imageUploadEndpoint');
      debugPrint('Requisição POST para upload de imagem: $url');

      var request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      var response = await request.send().timeout(const Duration(seconds: 30));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = json.decode(responseBody);

        if (responseData.containsKey('imageUrl')) {
          final String imageUrl = responseData['imageUrl'];
          debugPrint('Upload de imagem bem-sucedido. URL: $imageUrl');
          return imageUrl;
        } else {
          throw Exception('Resposta inesperada do servidor no upload de imagem: URL não encontrada.');
        }
      } else {
        final errorBody = await response.stream.bytesToString();
        debugPrint('Erro no upload de imagem: Status ${response.statusCode}, Body: $errorBody');
        throw Exception('Falha no upload da imagem: ${response.statusCode} - $errorBody');
      }
    } on SocketException {
      throw Exception('Sem conexão com a internet ou servidor de upload inacessível.');
    } on TimeoutException {
      throw Exception('Tempo limite excedido para upload da imagem.');
    } catch (e) {
      debugPrint('Erro desconhecido no upload de imagem: $e');
      throw Exception('Erro ao fazer upload da imagem: $e');
    }
  }

  /// Mock para notícias, simulando a estrutura que viria do backend.
  List<Map<String, dynamic>> _getMockNews() {
    return [
      {
        '_id': 'mock_news_1',
        'imageUrl': '[https://picsum.photos/300/150](https://picsum.photos/300/150)',
        'date': '15/05/2025',
        'location': 'Toledo',
        'title': 'Acesso Rápido (Mock)',
        'description': 'Foi realizado alterações nos botões de acesso rápido',
      },
      {
        '_id': 'mock_news_2',
        'imageUrl': '[https://picsum.photos/301/150](https://picsum.photos/301/150)',
        'date': '22/05/2025',
        'location': 'Toledo',
        'title': 'Notícia do Backend (Mock)',
        'description': 'Essa notícia veio da API (simulado).',
      },
    ];
  }
}
