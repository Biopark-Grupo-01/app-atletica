class Training {
  final String id;
  final String title;
  final String description;
  final String modality;
  final String coach;
  final String responsible;
  final String place;
  final String date;
  final String time;
  final bool isSubscribed;

  Training({
    required this.id,
    required this.title,
    required this.description,
    required this.modality,
    required this.coach,
    required this.responsible,
    required this.place,
    required this.date,
    required this.time,
    required this.isSubscribed,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      modality: json['modality'] ?? '',
      coach: json['coach'] ?? '',
      responsible: json['responsible'] ?? '',
      place: json['place'] ?? '',
      date: json['start_date'] ?? '',
      time: json['start_time'] ?? '',
      isSubscribed: json['isSubscribed'] ?? false,
    );
  }

  Map<String, String> toMapForUI() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'modality': modality,
      'coach': coach,
      'responsible': responsible,
      'place': place,
      'date': date,
      'time': time,
      'isSubscribed': isSubscribed.toString(),
    };
  }
}
