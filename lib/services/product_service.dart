import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/product_model.dart';

class ProductService {
  // URL base da API - usando o IP real da sua máquina
  static String getBaseUrl() {
    // Para desenvolvimento local:
    if (kIsWeb) {
      // Se estiver rodando na web, use localhost
      return 'http://localhost:3001/api';
    } else {
      // Para dispositivos móveis, use o IP real da máquina na rede
      return 'http://10.200.142.159:3001/api';
    }

    // Para produção, descomente e use a URL de produção:
    // return 'https://seu-backend-de-producao.com/api';
  }

  // Método para buscar todos os produtos
  Future<List<Product>> getProducts() async {
    final baseUrl = getBaseUrl();
    try {
      print('Fazendo requisição para: $baseUrl/products');

      // Aumentar o timeout para dar mais tempo para a conexão ser estabelecida
      final response = await http
          .get(
            Uri.parse('$baseUrl/products'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        print('Resposta recebida com sucesso');
        // Parse da resposta JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Verifica se a resposta contém a propriedade 'data'
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> productsData = responseData['data'];
          print('Produtos recebidos da API: ${productsData.length}');

          // Mapeia os dados para objetos Product
          return productsData.map((json) => Product.fromJson(json)).toList();
        } else {
          print('Formato de resposta inesperado: ${response.body}');
          return [];
        }
      } else {
        print('Erro HTTP: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception('Falha ao carregar produtos: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar produtos: $e');
      // Em caso de erro na API, retornar lista vazia
      return [];
    }
  }

  // Método para buscar um produto específico pelo ID
  Future<Product?> getProduct(String id) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products/$id'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data')) {
          return Product.fromJson(responseData['data']);
        } else {
          return null;
        }
      } else {
        throw Exception('Falha ao carregar o produto: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar o produto: $e');
      return null;
    }
  }

  // Método para buscar produtos por categoria
  Future<List<Product>> getProductsByCategory(String category) async {
    final baseUrl = getBaseUrl();
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products?category=$category'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> productsData = responseData['data'];
          return productsData.map((json) => Product.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Falha ao carregar produtos por categoria: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Erro ao buscar produtos por categoria: $e');
      return [];
    }
  }
}
