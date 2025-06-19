import 'dart:convert';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/match_model.dart';

class MatchService {
  Future<List<Match>> getMatches() async {
    final baseUrl = ApiService.baseUrl;
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

  Future<bool> createMatch({
    required String title,
    required String description,
    required String place,
    required String startDate,
    required String startTime,
    required String responsible,
    required String trainingModalityId,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/matches'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'title': title,
          'description': description,
          'place': place,
          'start_date': startDate,
          'start_time': startTime,
          'responsible': responsible,
          'trainingModalityId': trainingModalityId,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao criar amistoso: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar amistoso: $e');
      return false;
    }
  }
}
