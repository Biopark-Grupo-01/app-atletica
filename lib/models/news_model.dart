class NewsModel {
  final String? id;
  final String title;
  final String description;
  final String author;
  final String? imageUrl;

  NewsModel({
    this.id,
    required this.title,
    required this.description,
    required this.author,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'imageUrl': imageUrl,
    };
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}
