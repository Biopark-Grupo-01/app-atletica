import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/services/auth_service.dart';
import 'package:app_atletica/services/local_storage_service.dart';
import 'package:app_atletica/config/app_config.dart';

enum ApiEnvironment {
  development,
  production,
}

class ApiService {
  // Flag para usar dados mockados (baseado na configuração do aplicativo)
  static bool get useMockData => AppConfig.useMockData;
  
  // URL base atual baseada no ambiente
  static String get baseUrl => AppConfig.apiUrl;
  
  // Duração máxima para cache de dados
  static const Duration _maxCacheAge = Duration(hours: 1);

  // Headers padrão para requisições
  static Future<Map<String, String>> _getHeaders() async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Adiciona o token de autenticação aos headers se o usuário estiver logado
    final String? token = await AuthService.getToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // GET request com suporte a cache
  static Future<http.Response> get(
    BuildContext context,
    String endpoint, {
    Map<String, dynamic>? queryParams,
    bool useCache = true,
    String? cacheKey,
  }) async {
    // Se useCache é true e temos uma chave de cache, verificamos se há dados em cache
    if (useCache && cacheKey != null) {
      final shouldRefresh = await LocalStorageService.shouldSync(_maxCacheAge);
      final cachedData = await LocalStorageService.getData(cacheKey);
      
      // Se temos dados em cache e não precisamos atualizar, retornamos os dados em cache
      if (cachedData != null && !shouldRefresh) {
        return http.Response(
          json.encode(cachedData),
          200,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    
    // Se não temos cache ou precisamos atualizar, fazemos a requisição
    final fullUrl = baseUrl + endpoint;
    final Uri url = Uri.parse(fullUrl).replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    try {
      final response = await http.get(url, headers: headers);
      final processedResponse = _handleResponse(context, response);
      
      // Se a requisição foi bem-sucedida e temos uma chave de cache, salvamos os dados
      if (processedResponse.statusCode >= 200 && 
          processedResponse.statusCode < 300 && 
          useCache && 
          cacheKey != null) {
        final data = json.decode(processedResponse.body);
        await LocalStorageService.saveData(cacheKey, data);
      }
      
      return processedResponse;
    } catch (e) {
      // Em caso de erro, se temos dados em cache, usamos eles
      if (useCache && cacheKey != null) {
        final cachedData = await LocalStorageService.getData(cacheKey);
        if (cachedData != null) {
          print('Usando dados em cache para $endpoint devido a erro: $e');
          return http.Response(
            json.encode(cachedData),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
      }
      
      return _handleError(context, e);
    }
  }

  // POST request
  static Future<http.Response> post(
    BuildContext context,
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final fullUrl = baseUrl + endpoint;
    final Uri url = Uri.parse(fullUrl).replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(context, response);
    } catch (e) {
      return _handleError(context, e);
    }
  }

  // PUT request
  static Future<http.Response> put(
    BuildContext context,
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final fullUrl = baseUrl + endpoint;
    final Uri url = Uri.parse(fullUrl).replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(context, response);
    } catch (e) {
      return _handleError(context, e);
    }
  }

  // DELETE request
  static Future<http.Response> delete(
    BuildContext context,
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParams,
  }) async {
    final fullUrl = baseUrl + endpoint;
    final Uri url = Uri.parse(fullUrl).replace(queryParameters: queryParams);
    final headers = await _getHeaders();

    try {
      final response = await http.delete(
        url,
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(context, response);
    } catch (e) {
      return _handleError(context, e);
    }
  }

  // Tratamento de respostas
  static http.Response _handleResponse(BuildContext context, http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response;
    } else if (response.statusCode == 401) {
      _showSessionExpiredDialog(context);
      throw Exception('Sessão expirada ou token inválido');
    } else {
      throw Exception('Erro na requisição: ${response.statusCode} - ${response.body}');
    }
  }

  // Tratamento de erros
  static http.Response _handleError(BuildContext context, dynamic error) {
    _showErrorDialog(context, 'Erro de conexão: ${error.toString()}');
    throw error;
  }

  // Diálogo de sessão expirada
  static void _showSessionExpiredDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sessão Expirada'),
          content: const Text('Sua sessão expirou. Por favor, faça login novamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
                AuthService.logout();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Diálogo de erro genérico
  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
