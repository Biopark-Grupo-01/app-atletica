import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/news_model.dart';

class NewsService {
  static String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3001/api';
    } else {
      return 'http://172.27.16.1:3001/api';
    }
  }

  // Buscar todas as notícias
  Future<List<News>> getAllNews() async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/news'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> newsData = responseData['data'];
          return newsData.map((json) => News.fromJson(json)).toList();
        }
        return [];
      } else {
        print('Erro ao buscar notícias: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro na requisição de notícias: $e');
      return [];
    }
  }

  // Buscar uma notícia por ID
  Future<News?> getNewsById(String id) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/news/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data')) {
          return News.fromJson(responseData['data']);
        }
        return null;
      } else {
        print('Erro ao buscar notícia por ID: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar notícia: $e');
      return null;
    }
  }

  // Criar uma nova notícia
  Future<bool> createNews(News news) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/news'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(news.toJson()),
      ).timeout(const Duration(seconds: 15));

      return response.statusCode == 201;
    } catch (e) {
      print('Erro ao criar notícia: $e');
      return false;
    }
  }

  // Deletar notícia
  Future<bool> deleteNews(String id) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/news/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (e) {
      print('Erro ao deletar notícia: $e');
      return false;
    }
  }
}
