import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:app_atletica/models/training_model.dart';

class TrainingService {
  static String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3001/api';
    } else {
      return 'http://192.168.3.109:3001/api'; // Updated to use the correct IP
    }
  }

  Future<List<Training>> getTrainings() async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/trainings'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData.containsKey('data') && responseData['data'] is List) {
          return (responseData['data'] as List)
              .map((json) => Training.fromJson(json))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar treinos: $e');
      return [];
    }
  }

  Future<bool> subscribeToTraining(String trainingId, String userId) async {
    final baseUrl = getBaseUrl();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/subscriptions'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'trainingId': trainingId, 'userId': userId}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('(else) Erro ao se inscrever: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('(catch) Erro ao se inscrever: $e');
      return false;
    }
  }

  Future<bool> unsubscribeFromTraining(String subscriptionId) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/subscriptions/$subscriptionId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao desinscrever: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao desinscrever: $e');
      return false;
    }
  }

  Future<List<String>> getSubscribedTrainingIds(String userId) async {
    final baseUrl = getBaseUrl();

    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/subscriptions?userId=$userId'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];

        return data
            .map((subscription) => subscription['training']['id'] as String)
            .toList();
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar inscrições: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUserSubscriptions(String userId) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/subscriptions?userId=$userId'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        // Retorna a lista de inscrições completas
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar inscrições: $e');
      return [];
    }
  }
}
