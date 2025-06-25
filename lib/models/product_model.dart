// Modelo para categorias de produtos
class ProductCategory {
  final String id; // CANECAS, ROUPAS, etc.
  final String name;
  final String? icon;

  ProductCategory({
    required this.id,
    required this.name,
    this.icon,
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
  final String? categoryId;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'category_id': categoryId ?? '',
      'price': price.toStringAsFixed(2).replaceAll('.', ','),
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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString(),
      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0.0
          : 0.0,
      stock: json['stock'] != null ? int.tryParse(json['stock'].toString()) ?? 0 : 0,
      categoryId: (json['category_id'] ?? json['categoryId'])?.toString() ?? '',
      image: json['image']?.toString(),
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
    );
  }
}
