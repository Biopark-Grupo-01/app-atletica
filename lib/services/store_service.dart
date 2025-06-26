import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;

class StoreService {
  static Future<List<Map<String, dynamic>>> getCategories(BuildContext context) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product-categories'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
      return [];
    }
  }

  static Future<List<ProductModel>> getProducts(BuildContext context, {String? category}) async {
    final baseUrl = ApiService.baseUrl;
    try {
      String url = '$baseUrl/products';
      if (category != null) {
        url += '?category=$category';
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        return data.map((item) => ProductModel.fromJson(item)).toList();
      } else {
        throw Exception('Erro ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      return [];
    }
  }

  static Future<bool> createProduct({
    required String name,
    String? description,
    required double price,
    required String categoryId,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'price': price,
          'categoryId': categoryId,
          'stock': 10, 
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print('Erro ao criar produto: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao criar produto: $e');
      return false;
    }
  }

  static Future<bool> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required String categoryId,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'description': description,
          'price': price,
          'categoryId': categoryId,
        }),
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao atualizar produto: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao atualizar produto: $e');
      return false;
    }
  }

  static Future<bool> deleteProduct(String productId) async {
    if (productId.isEmpty) {
      print('Erro: ID do produto não pode estar vazio');
      return false;
    }
    
    final baseUrl = ApiService.baseUrl;
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {'Accept': 'application/json'},
      );
      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        print('Erro ao excluir produto: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Erro ao excluir produto: $e');
      return false;
    }
}
}