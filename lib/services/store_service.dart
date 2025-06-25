import 'dart:convert';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/product_model.dart';

class CategoryService {
  Future<List<ProductCategory>> getCategories() async {
    final baseUrl = ApiService.baseUrl;
    try {
      print('Fazendo requisição para: $baseUrl/product-categories');

      // Adicionando cabeçalhos para ajudar com CORS
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(Uri.parse('$baseUrl/product-categories'), headers: headers)
          .timeout(const Duration(seconds: 15));

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Resposta recebida com sucesso');
        // Parse da resposta JSON
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Verifica se a resposta contém a propriedade 'data'
        if (responseData.containsKey('data') && responseData['data'] is List) {
          final List<dynamic> data = responseData['data'];
          print('Produtos recebidos da API: ${data.length}');

          // Mapeia os dados para objetos Product
          return data
              .map((json) => ProductCategory.fromJson(json))
              .toList();
        } else {
          print('Formato de resposta inesperado: ${response.body}');
          return [];
        }
      } else {
        print('Erro HTTP: ${response.statusCode}');
        print('Resposta: ${response.body}');
        throw Exception('Falha ao carregar categorias: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao buscar categorias: $e');
      // Em caso de erro, tentar usar categorias mockados para teste
      return _mockCategories();
    }
  }

  // Lista mockada de categorias
  List<ProductCategory> _mockCategories() {
    print('Usando categorias mockadas para teste');
    return [
      ProductCategory(
        id: 'ROUPAS',
        name: 'Roupas',
        icon: 'checkroom',
      ),
      ProductCategory(
        id: 'CANECAS',
        name: 'Canecas',
        icon: 'local_cafe',
      ),
      ProductCategory(
        id: 'CHAVEIROS',
        name: 'Chaveiros',
        icon: 'key',
      ),
    ];
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
}
