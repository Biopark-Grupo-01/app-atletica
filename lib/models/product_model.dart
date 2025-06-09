class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final int stock;
  final String? category;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
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

  // Converter de JSON para objeto Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
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

  // Converter objeto Product para o formato esperado pela UI
  Map<String, String> toMapForUI() {
    return {
      'name': name,
      // Se não tiver categoria, usa 'OUTROS' como padrão
      'category': category ?? 'OUTROS',
      'price': price.toStringAsFixed(2).replaceAll('.', ','),
      // Se não tiver imagem, usa um placeholder
      'image':
          image != null && image!.startsWith('http')
              ? image!
              : image != null
              ? 'assets/images/$image'
              : 'assets/images/emblema.png',
      'description': description ?? 'Sem descrição disponível.',
    };
  }
}
