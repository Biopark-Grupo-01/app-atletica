class EventModel {
  final String id;
  final String? imageUrl;
  final String date;
  final String location;
  final String title;
  final String? description;
  final String? price;

  EventModel({
    required this.id,
    this.imageUrl,
    required this.date,
    required this.location,
    required this.title,
    this.description,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'title': title,
      'description': description,
      'price': price,
    };
  }
  
  Map<String, String> toDisplayMap() {
    return {
      'id': id,
      'imageUrl': imageUrl ?? '',
      'date': date,
      'location': location,
      'title': title,
      'description': description ?? '',
      'price': price ?? '0,00',
    };
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] != null ? json['id'].toString() : DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0,00',
    );
  }
}
