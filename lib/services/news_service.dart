import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/services/local_storage_service.dart';

class NewsService {
  static const String _newsEndpoint = '/news';

  static String getBaseUrl() {
    if (kIsWeb) {
      return 'http://127.0.0.1:3001/api';
    } else if (Platform.isAndroid) {
      return 'http://192.168.3.108:3001/api';
    } else {
      return 'http://192.168.3.108:3001/api';
    }
  }

  /// Método principal para carregar notícias (com cache + fallback)
  static Future<List<Map<String, dynamic>>> loadNews() async {
    try {
      // Tenta carregar do cache local
      final cachedNews = await LocalStorageService.getCachedNews();
      if (cachedNews != null && cachedNews.isNotEmpty) {
        print('Notícias carregadas do cache (${cachedNews.length})');
        return List<Map<String, dynamic>>.from(cachedNews);
      }
    } catch (e) {
      print('Erro ao carregar notícias do cache: $e');
    }

    try {
      // Tenta buscar da API
      final freshNews = await _getNewsFromApi();
      // Atualiza o cache
      await LocalStorageService.cacheNews(freshNews);
      print('Cache de notícias atualizado com ${freshNews.length} registros');
      return freshNews;
    } catch (e) {
      print('Erro ao buscar notícias da API: $e');
    }

    // Se tudo falhar, retorna os dados mockados
    print('Usando dados mockados para notícias');
    return _getMockNews();
  }

  /// Busca notícias diretamente da API
  static Future<List<Map<String, dynamic>>> _getNewsFromApi() async {
    final baseUrl = getBaseUrl();
    final url = Uri.parse('$baseUrl$_newsEndpoint');

    print('Requisição GET para $url');

    final response = await http
        .get(url, headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        })
        .timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('data') && responseBody['data'] is List) {
        final List<dynamic> newsList = responseBody['data'];
        print('${newsList.length} notícias recebidas da API');
        return List<Map<String, dynamic>>.from(newsList);
      } else {
        throw Exception('Resposta inesperada da API');
      }
    } else {
      throw Exception('Erro ${response.statusCode} ao carregar notícias');
    }
  }

  /// Dados mockados para fallback
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
}
