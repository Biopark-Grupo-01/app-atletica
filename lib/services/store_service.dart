import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/services/api_service.dart';

class StoreService {
  static const String _productsEndpoint = '/products';
  static const String _categoriesEndpoint = '/product-categories';

  static Future<List<ProductCategory>> getCategories(BuildContext context) async {
    try {
      if (ApiService.useMockData) {
        return _getMockCategories();
      } else {
        final response = await ApiService.get(context, _categoriesEndpoint);
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ProductCategory.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar categorias: $e');
      // Em caso de erro, retorna dados mockados
      return _getMockCategories();
    }
  }

  static Future<List<ProductModel>> getProducts(BuildContext context, {String? category}) async {
    try {
      if (ApiService.useMockData) {
        final products = _getMockProducts();
        if (category != null) {
          return products.where((product) => product.category == category).toList();
        }
        return products;
      } else {
        Map<String, dynamic>? queryParams;
        if (category != null) {
          queryParams = {'category': category};
        }
        
        final response = await ApiService.get(context, _productsEndpoint, queryParams: queryParams);
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
      // Em caso de erro, retorna dados mockados
      final products = _getMockProducts();
      if (category != null) {
        return products.where((product) => product.category == category).toList();
      }
      return products;
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

  // Dados mockados para categorias
  static List<ProductCategory> _getMockCategories() {
    return [
      ProductCategory(
        id: 'CANECAS',
        name: 'Canecas',
        icon: 'local_drink',
      ),
      ProductCategory(
        id: 'ROUPAS',
        name: 'Roupas',
        icon: 'checkroom',
      ),
      ProductCategory(
        id: 'CHAVEIROS',
        name: 'Chaveiros',
        icon: 'key',
      ),
      ProductCategory(
        id: 'TATUAGENS',
        name: 'Tatuagens',
        icon: 'brush',
      ),
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
}
