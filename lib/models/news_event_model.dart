class NewsModel {
  final String id;
  final String? imageUrl;
  final String date;
  final String? location;
  final String title;
  final String? description;

  NewsModel({
    required this.id,
    this.imageUrl,
    required this.date,
    this.location,
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'title': title,
      'description': description,
    };
  }
  
  Map<String, String> toDisplayMap() {
    return {
      'id': id,
      'imageUrl': imageUrl ?? '',
      'date': date,
      'location': location ?? '',
      'title': title,
      'description': description ?? '',
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] != null ? json['id'].toString() : DateTime.now().millisecondsSinceEpoch.toString(),
      imageUrl: json['imageUrl'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}

class EventModel {
  final String id;
  final String? imageUrl;
  final String date;
  final String location;
  final String title;
  final String? description;

  EventModel({
    required this.id,
    this.imageUrl,
    required this.date,
    required this.location,
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'date': date,
      'location': location,
      'title': title,
      'description': description,
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
    );
  }
}