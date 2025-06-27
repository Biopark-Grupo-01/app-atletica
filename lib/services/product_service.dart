import 'dart:convert';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:app_atletica/models/product_model.dart';

class ProductService {
  // Método para buscar todos os produtos
  Future<List<ProductModel>> getProducts() async {
    final baseUrl = ApiService.baseUrl;
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
        imageUrl: 'camisetaa_masculina.png',
      ),
      ProductModel(
        id: '2',
        name: 'Caneca Oficial',
        description: 'Caneca oficial da Atlética Biopark',
        price: 25.0,
        stock: 15,
        category: 'CANECAS',
        imageUrl: 'caneca_personalizada.jpeg',
      ),
      ProductModel(
        id: '3',
        name: 'Chaveiro',
        description: 'Chaveiro da Atlética Biopark',
        price: 15.0,
        stock: 30,
        category: 'CHAVEIROS',
        imageUrl: 'chaveiro.jpeg',
      ),
    ];
  }

  // Método para buscar um produto específico pelo ID
  Future<ProductModel?> getProduct(String id) async {
    final baseUrl = ApiService.baseUrl;
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
    final baseUrl = ApiService.baseUrl;
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
