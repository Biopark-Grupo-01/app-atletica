class TrainingModel {
  final String id;
  final String type;      // TREINOS, AMISTOSOS
  final String category;  // Basquete, Futebol, etc.
  final String date;
  final String location;
  final String title;
  final String? description;

  TrainingModel({
    required this.id,
    required this.type,
    required this.category,
    required this.date,
    required this.location,
    required this.title,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'date': date,
      'location': location,
      'title': title,
      'description': description,
    };
  }
  
  Map<String, String> toDisplayMap() {
    return {
      'id': id,
      'type': type,
      'category': category,
      'date': date,
      'location': location,
      'title': title,
      'description': description ?? '',
    };
  }

  factory TrainingModel.fromJson(Map<String, dynamic> json) {
    return TrainingModel(
      id: json['id'] != null ? json['id'].toString() : DateTime.now().millisecondsSinceEpoch.toString(),
      type: json['type'] ?? 'TREINOS',
      category: json['category'] ?? '',
      date: json['date'] ?? '',
      location: json['location'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
