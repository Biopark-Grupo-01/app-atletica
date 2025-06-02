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
}
