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
  final String category;
  final String price;
  final String image;
  final String? description;
  final int? stock;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.image,
    this.description,
    this.stock,
  });
  
  Map<String, String> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'image': image,
      'description': description ?? '',
      'stock': stock?.toString() ?? '0',
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] != null ? json['id'].toString() : DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      price: json['price'] ?? '0,00',
      image: json['image'] ?? '',
      description: json['description'],
      stock: json['stock'] != null ? int.parse(json['stock'].toString()) : null,
    );
  }
}
