class UserModel {
  final String id;
  final String name;
  final String email;
  final String? cpf;
  final String avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.cpf,
    required this.avatarUrl,
  });
}
