// Modelo para categorias de produtos
class ProductCategory {
  final String id; // CANECAS, ROUPAS, etc.
  final String name;
  final String icon;

  ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'package',
    );
  }
}

// Modelo para produtos
class ProductModel {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? category;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.category,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      // Se não tiver categoria, usa 'OUTROS' como padrão
      'category': category ?? 'OUTROS',
      'price': price.toStringAsFixed(2).replaceAll('.', ','),
      // Se não tiver imagem, usa brasao.png como padrão
      'image':
          image != null && image!.startsWith('http')
              ? image!
              : image != null && image!.isNotEmpty
              ? 'assets/images/$image'
              : 'assets/images/brasao.png',
      'description': description ?? 'Sem descrição disponível.',
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      // Converte preço de string para double
      price:
          json['price'] != null
              ? double.tryParse(json['price'].toString()) ?? 0.0
              : 0.0,
      stock: json['stock'] ?? 0,
      category: json['category'],
      image: json['image'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
