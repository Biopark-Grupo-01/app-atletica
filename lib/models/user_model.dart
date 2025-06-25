class UserModel {
  final String id;
  final String name;
  final String email;
  final String? cpf;
  final String? avatarUrl;
  final String? role;
  final int? registration;
  final String? validUntil;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.cpf,
    this.avatarUrl,
    this.role,
    this.registration,
    this.validUntil,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'avatarUrl': avatarUrl,
      'role': role,
      'registration': registration,
      'validUntil': validUntil,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'],
      avatarUrl: json['avatarUrl'],
      role: json['role'] is Map ? json['role']['name'] : json['role'],
      registration: json['registration'] is int 
        ? json['registration'] 
        : int.tryParse(json['registration']?.toString() ?? ''),
      validUntil: json['validUntil'],
    );
  }

  // Cria uma cópia do modelo atual com alguns campos alterados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? cpf,
    String? avatarUrl,
    String? role,
    int? registration,
    String? validUntil,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      registration: registration ?? this.registration,
      validUntil: validUntil ?? this.validUntil,
    );
  }
}
