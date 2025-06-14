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

  // Método para converter o objeto em Map<String, dynamic> (JSON)
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

  // Método factory para criar uma instância a partir de Map<String, dynamic> (JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      role: json['role'] as String?,
      registration: json['registration'] as int?,
      validUntil: json['validUntil'] as String?,
    );
  }
}
