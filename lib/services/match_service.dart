import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/match_model.dart';
import 'package:flutter/foundation.dart';

class MatchService {
  static String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3001/api';
    } else {
      return 'http://192.168.1.3:3001/api';
    }
  }

  Future<List<Match>> getMatches() async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/matches'), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((json) => Match.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar amistosos: $e');
      return [];
    }
  }
}
