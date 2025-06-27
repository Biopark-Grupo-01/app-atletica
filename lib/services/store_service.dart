import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_atletica/models/product_model.dart';
import 'package:app_atletica/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class StoreService {
  // ========== MÉTODOS DE UPLOAD DE IMAGEM ==========
  
  // Método para fazer upload de imagem de produto
  static Future<String?> uploadProductImage(File imageFile) async {
    try {
      // Valida se o arquivo é uma imagem válida
      if (!_isValidImageFile(imageFile.path)) {
        print('Arquivo não é uma imagem válida: ${imageFile.path}');
        return null;
      }
      
      final baseUrl = ApiService.baseUrl;
      print('=== UPLOAD DE IMAGEM (PRODUTO) ===');
      print('BaseURL: $baseUrl');
      print('URL completa: $baseUrl/upload/product-image');
      
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload/product-image'));
      
      // Adiciona o arquivo à requisição usando o campo 'file' como especificado
      final contentType = _getContentType(imageFile.path);
      
      // Como fallback, força JPEG se não conseguiu detectar o tipo
      final finalContentType = contentType.mimeType == 'image/jpeg' && 
          !imageFile.path.toLowerCase().contains('.jpg') && 
          !imageFile.path.toLowerCase().contains('.jpeg') 
        ? MediaType('image', 'jpeg')
        : contentType;
      
      final multipartFile = await http.MultipartFile.fromPath(
        'file', // Campo específico do seu backend
        imageFile.path,
        contentType: finalContentType,
        filename: 'product_image.jpg', // Nome explícito com extensão
      );
      
      print('ContentType definido: ${finalContentType.mimeType}');
      print('Nome do arquivo original: ${imageFile.path.split('/').last}');
      print('Nome do arquivo enviado: product_image.jpg');
      
      request.files.add(multipartFile);
      
      // Adiciona headers
      request.headers.addAll({
        'Accept': 'application/json',
      });
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      print('Status da resposta: ${response.statusCode}');
      print('Corpo da resposta: $responseBody');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(responseBody);
        
        // O backend retorna a URL no campo data.url
        final Map<String, dynamic>? data = responseData['data'];
        final String imageUrl = data?['url'] ?? '';
        
        print('Upload realizado com sucesso! URL: $imageUrl');
        return imageUrl.isNotEmpty ? imageUrl : null;
      } else {
        print('Erro no upload da imagem: ${response.statusCode}');
        print('Resposta do servidor: $responseBody');
        return null;
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
      return null;
    }
  }

  // Método auxiliar para validar se é um arquivo de imagem
  static bool _isValidImageFile(String filePath) {
    final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    final extension = filePath.toLowerCase().split('.').last;
    return validExtensions.contains(extension);
  }

  // Método auxiliar para determinar o contentType baseado na extensão do arquivo
  static MediaType _getContentType(String filePath) {
    // Usa o pacote mime para detectar automaticamente o tipo
    final mimeType = lookupMimeType(filePath);
    
    if (mimeType != null) {
      final parts = mimeType.split('/');
      return MediaType(parts[0], parts[1]);
    }
    
    // Fallback manual baseado na extensão
    final extension = filePath.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'gif':
        return MediaType('image', 'gif');
      case 'bmp':
        return MediaType('image', 'bmp');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  // Método para construir URL completa da imagem
  static String getFullImageUrl(String imageUrl) {
    final baseUrl = ApiService.baseUrl;
    
    if (imageUrl.startsWith('http')) {
      return imageUrl; // Já é uma URL completa
    }
    
    // Se for um asset local (assets/), retorna como está
    if (imageUrl.startsWith('assets/')) {
      return imageUrl; // É um asset local, não concatena com URL do servidor
    }
    
    // Remove '/api' do baseUrl para imagens, pois elas são servidas diretamente pelo servidor
    // Exemplo: baseUrl = "http://192.168.1.2:3001/api" -> "http://192.168.1.2:3001"
    final baseUrlWithoutApi = baseUrl.replaceAll('/api', '');
    final fullUrl = '$baseUrlWithoutApi$imageUrl';
    
    return fullUrl;
  }

  // ========== MÉTODOS EXISTENTES ==========

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
      
      print('=== DEBUG GETPRODUCTS REQUEST ===');
      print('URL da requisição: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));
      
      print('Status da resposta: ${response.statusCode}');
      print('Resposta bruta do backend: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> data = responseData['data'];
        
        print('=== DEBUG GETPRODUCTS ===');
        print('Dados recebidos do backend: $data');
        
        final products = data.map((item) {
          print('Item individual do backend: $item');
          final product = ProductModel.fromJson(item);
          print('ProductModel criado - imageUrl: ${product.imageUrl}');
          return product;
        }).toList();
        
        print('Total de produtos carregados: ${products.length}');
        return products;
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
    File? imageFile,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      print('=== CRIAR PRODUTO ===');
      print('Nome: $name');
      print('Preço: $price');
      print('Categoria: $categoryId');
      print('Tem arquivo de imagem: ${imageFile != null}');
      
      String? imageUrl;
      
      // Faz upload da imagem se fornecida
      if (imageFile != null) {
        print('Iniciando upload da imagem...');
        imageUrl = await uploadProductImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da imagem, continuando sem imagem');
        } else {
          print('Upload da imagem realizado com sucesso: $imageUrl');
        }
      } else {
        print('Nenhuma imagem fornecida para upload');
      }
      
      // Monta o objeto que será enviado
      final Map<String, dynamic> productData = {
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
        'stock': 10,
      };
      
      // Adiciona a imagem se foi feito upload
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;  // Testando com imageUrl
        print('Incluindo imagem no payload com campo imageUrl: $imageUrl');
      } else {
        print('Nenhuma imagem será incluída no payload');
      }
      
      print('Dados que serão enviados para o backend:');
      print(json.encode(productData));
      print('URL do endpoint: $baseUrl/products');
      
      final response = await http.post(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(productData),
      );
      
      print('Status da resposta do backend: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Produto criado com sucesso!');
        return true;
      } else {
        print('Erro ao criar produto: ${response.statusCode}');
        print('Detalhes do erro: ${response.body}');
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
    File? imageFile,
  }) async {
    final baseUrl = ApiService.baseUrl;
    try {
      print('=== ATUALIZAR PRODUTO ===');
      print('ID do produto: $productId');
      print('Nome: $name');
      print('Preço: $price');
      print('Categoria: $categoryId');
      print('Tem arquivo de imagem: ${imageFile != null}');
      
      String? imageUrl;
      
      // Faz upload da imagem se fornecida
      if (imageFile != null) {
        print('Iniciando upload da nova imagem...');
        imageUrl = await uploadProductImage(imageFile);
        if (imageUrl == null) {
          print('Falha no upload da imagem, continuando sem atualizar imagem');
        } else {
          print('Upload da nova imagem realizado com sucesso: $imageUrl');
        }
      } else {
        print('Nenhuma nova imagem fornecida para upload');
      }
      
      // Monta o objeto que será enviado
      final Map<String, dynamic> productData = {
        'name': name,
        'description': description,
        'price': price,
        'categoryId': categoryId,
      };
      
      // Adiciona a imagem se foi feito upload
      if (imageUrl != null) {
        productData['imageUrl'] = imageUrl;  // Testando com imageUrl
        print('Incluindo nova imagem no payload com campo imageUrl: $imageUrl');
      } else {
        print('Nenhuma nova imagem será incluída no payload');
      }
      
      print('Dados que serão enviados para o backend:');
      print(json.encode(productData));
      print('URL do endpoint: $baseUrl/products/$productId');
      
      final response = await http.put(
        Uri.parse('$baseUrl/products/$productId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(productData),
      );
      
      print('Status da resposta do backend: ${response.statusCode}');
      print('Corpo da resposta: ${response.body}');
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Produto atualizado com sucesso!');
        return true;
      } else {
        print('Erro ao atualizar produto: ${response.statusCode}');
        print('Detalhes do erro: ${response.body}');
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

  // Método para testar consulta individual de produto
  static Future<void> testIndividualProduct(String productId) async {
    final baseUrl = ApiService.baseUrl;
    try {
      final url = '$baseUrl/products/$productId';
      print('=== TESTE PRODUTO INDIVIDUAL ===');
      print('URL: $url');
      
      final response = await http.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));
      
      print('Status: ${response.statusCode}');
      print('Resposta individual: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Dados do produto individual: ${responseData}');
        if (responseData.containsKey('data')) {
          print('Campo data: ${responseData['data']}');
        }
      }
    } catch (e) {
      print('Erro ao consultar produto individual: $e');
    }
  }
}