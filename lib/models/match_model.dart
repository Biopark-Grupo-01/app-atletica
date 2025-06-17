class Match {
  final String id;
  final String title;
  final String description;
  final String modality;
  final String place;
  final String date;
  final String time;
  final String responsible;

  Match({
    required this.id,
    required this.title,
    required this.description,
    required this.modality,
    required this.place,
    required this.date,
    required this.time,
    required this.responsible,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      modality: json['trainingModality']?['name'] ?? '',
      place: json['place'] ?? '',
      date: json['start_date'] ?? '',
      time: json['start_time'] ?? '',
      responsible: json['responsible'] ?? '',
    );
  }
}
