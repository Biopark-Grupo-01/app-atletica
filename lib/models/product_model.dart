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
  final String? categoryId;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.category,
    this.categoryId,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category ?? 'OUTROS',
      'category_id': categoryId ?? '',
      'price': price.toStringAsFixed(2).replaceAll('.', ','),
      'stock': stock.toString(),
      'imageUrl': imageUrl ?? 'assets/images/brasao.png', // Preserva a URL original sem modificações
      'description': description ?? 'Sem descrição disponível.',
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      stock: json['stock'] != null ? int.tryParse(json['stock'].toString()) ?? 0 : 0,
      category: json['category']?.toString() ?? '',
      categoryId: (json['category_id'] ?? json['categoryId'])?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString(), // Tenta ambos os campos
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }
}
