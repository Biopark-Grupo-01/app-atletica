class News {
  final String id;
  final String title;
  final String date;
  final String description;
  final String? imageUrl;

  News({
    required this.id,
    required this.title,
    required this.date,
    required this.description,
    this.imageUrl,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
