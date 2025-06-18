import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/product_model.dart';

class ProductService {
  // URL base da API - adaptando para diferentes ambientes
  static String getBaseUrl() {
    // if (kIsWeb) {
    //   // Para aplicações web, pode ser necessário usar um proxy CORS ou habilitar CORS no backend
    //   return 'http://127.0.0.1:3001/api'; // Tentando com 127.0.0.1 em vez de localhost
    // } else if (Platform.isAndroid) {
    //   // Para emulador Android
    //   return 'http://10.0.2.2:3001/api';
    // } else {
    //   // Para dispositivos móveis, use o IP real da máquina na rede
    //   return 'http://192.168.1.3:3001/api'; // Updated to use the correct IP
    // }

      return 'http://192.168.1.3:3001/api'; // Updated to use the correct IP

  }

  // Método para buscar todos os produtos
  Future<List<ProductModel>> getProducts() async {
    final baseUrl = getBaseUrl();
    try {
      print('Fazendo requisição para: $baseUrl/products');

      // Adicionando cabeçalhos para ajudar com CORS
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(Uri.parse('$baseUrl/products'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Resposta recebida com sucesso');
        // Parse da resposta JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Verifica se a resposta contém a propriedade 'data'
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> productsData = responseData['data'];
          print('Produtos recebidos da API: ${productsData.length}');

          // Mapeia os dados para objetos Product
          return productsData
              .map((json) => ProductModel.fromJson(json))
              .toList();
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
      // Em caso de erro, tentar usar produtos mockados para teste
      return _getMockProducts();
    }
  }

  // Método para obter produtos mockados em caso de falha na API
  List<ProductModel> _getMockProducts() {
    print('Usando produtos mockados para teste');
    return [
      ProductModel(
        id: '1',
        name: 'Camiseta Masculina',
        description: 'Camiseta oficial da Atlética',
        price: 50.0,
        stock: 10,
        category: 'ROUPAS',
        image: 'assets/images/camisetaa_masculina.png',
      ),
      ProductModel(
        id: '2',
        name: 'Caneca Oficial',
        description: 'Caneca oficial da Atlética Biopark',
        price: 25.0,
        stock: 15,
        category: 'CANECAS',
        image: 'assets/images/caneca_personalizada.jpeg',
      ),
    ];
  }

  // Método para buscar um produto específico pelo ID
  Future<ProductModel?> getProduct(String id) async {
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
          return ProductModel.fromJson(responseData['data']);
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
  Future<List<ProductModel>> getProductsByCategory(String category) async {
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
          return productsData
              .map((json) => ProductModel.fromJson(json))
              .toList();
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
