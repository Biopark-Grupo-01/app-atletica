import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;

class StoreService {
  static const String _productsEndpoint = '/api/products';

  static Future<List<Map<String, dynamic>>> getCategories(BuildContext context) async {
    final baseUrl = getBaseUrl();
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
    final baseUrl = getBaseUrl();
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

  // Método para obter detalhes de um produto específico
  static Future<ProductModel?> getProduct(BuildContext context, String productId) async {
    try {
      if (ApiService.useMockData) {
        final products = _getMockProducts();
        return products.firstWhere((product) => product.id == productId);
      } else {
        final response = await ApiService.get(context, '$_productsEndpoint/$productId');
        return ProductModel.fromJson(json.decode(response.body));
      }
    } catch (e) {
      print('Erro ao carregar detalhes do produto: $e');
      return null;
    }
  }

  // Método para adicionar ou atualizar um produto
  static Future<bool> saveProduct(BuildContext context, ProductModel product) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        final endpoint = product.id.isNotEmpty ? '$_productsEndpoint/${product.id}' : _productsEndpoint;
        final method = product.id.isNotEmpty ? 'put' : 'post';
        
        if (method == 'put') {
          await ApiService.put(context, endpoint, body: product.toJson());
        } else {
          await ApiService.post(context, endpoint, body: product.toJson());
        }
        
        return true;
      }
    } catch (e) {
      print('Erro ao salvar produto: $e');
      return false;
    }
  }

  static Future<bool> deleteProduct(BuildContext context, String productId) async {
    try {
      if (ApiService.useMockData) {
        // Simula um atraso e sucesso
        await Future.delayed(Duration(seconds: 1));
        return true;
      } else {
        await ApiService.delete(context, '$_productsEndpoint/$productId');
        return true;
      }
    } catch (e) {
      print('Erro ao excluir produto: $e');
      return false;
    }
  }

  static String getBaseUrl() {
    // if (ApiService.useMockData) {
    //   return 'http://localhost:3001/api';
    // } else {
    //   return 'http://192.168.1.3:3001/api'; // Altere conforme necessário para produção
    // }
    return 'http://192.168.1.3:3001/api'; // Altere conforme necessário para produção
  }

  // Dados mockados para categorias
  static List<ProductCategory> _getMockCategories() {
    return [
      // ProductCategory(
      //   id: 'CANECAS',
      //   name: 'Canecas',
      //   icon: 'local_drink',
      // ),
      // ProductCategory(
      //   id: 'ROUPAS',
      //   name: 'Roupas',
      //   icon: 'checkroom',
      // ),
      // ProductCategory(
      //   id: 'CHAVEIROS',
      //   name: 'Chaveiros',
      //   icon: 'key',
      // ),
      // ProductCategory(
      //   id: 'TATUAGENS',
      //   name: 'Tatuagens',
      //   icon: 'brush',
      // ),
    ];
  }

  // Dados mockados para produtos
  static List<ProductModel> _getMockProducts() {
    return [
      ProductModel(
        id: '1',
        name: 'Caneca Oficial',
        category: 'CANECAS',
        price: 25.00,
        image: 'assets/images/caneca_oficial.png',
        description: 'Caneca oficial da atlética, material cerâmico de qualidade',
        stock: 10,
      ),
      ProductModel(
        id: '2',
        name: 'Camiseta Masculina',
        category: 'ROUPAS',
        price: 50.00,
        image: 'assets/images/camisetaa_masculina.png',
        description: 'Camiseta oficial masculina da atlética, 100% algodão',
        stock: 15,
      ),
      ProductModel(
        id: '3',
        name: 'Camiseta Feminina',
        category: 'ROUPAS',
        price: 50.00,
        image: 'assets/images/camiseta_feminina_1.png',
        description: 'Camiseta oficial feminina da atlética, 100% algodão',
        stock: 12,
      ),
      ProductModel(
        id: '4',
        name: 'Chaveiro Tigre',
        category: 'CHAVEIROS',
        price: 15.00,
        image: 'assets/images/chaveiro.jpeg',
        description: 'Chaveiro com o mascote da atlética',
        stock: 30,
      ),
      ProductModel(
        id: '5',
        name: 'Tatuagem Temporária',
        category: 'TATUAGENS',
        price: 10.00,
        image: 'assets/images/tatuagens_temporarias.jpeg',
        description: 'Kit com 3 tatuagens temporárias com o emblema da atlética',
        stock: 50,
      ),
      ProductModel(
        id: '6',
        name: 'Caneca Personalizada',
        category: 'CANECAS',
        price: 30.00,
        image: 'assets/images/caneca_personalizada.jpeg',
        description: 'Caneca personalizada com seu nome',
        stock: 8,
      ),
      ProductModel(
        id: '7',
        name: 'Caneca Estampada Premium',
        category: 'CANECAS',
        price: 35.00,
        image: 'assets/images/caneca_estampa_premium.jpeg',
        description: 'Caneca de porcelana com estampa especial',
        stock: 5,
      ),
      ProductModel(
        id: '8',
        name: 'Boné Oficial',
        category: 'ROUPAS',
        price: 40.00,
        image: 'assets/images/bone.png',
        description: 'Boné oficial com logo bordado',
        stock: 20,
      ),
    ];
  }

  static Future<bool> createProduct({
    required String name,
    String? description,
    required double price,
    required String categoryId,
  }) async {
    final baseUrl = getBaseUrl();
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
}
