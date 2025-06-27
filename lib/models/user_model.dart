class UserModel {
  final String id;
  final String name;
  final String email;
  final String? cpf;
  final String? phone;
  final String? avatarUrl;
  final String? role;
  final String? roleDisplayName;
  final int? registration;
  final String? validUntil;
  final String? firebaseUid;
  final DateTime? planStartDate;
  final DateTime? planEndDate;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.cpf,
    this.phone,
    this.avatarUrl,
    this.role,
    this.roleDisplayName,
    this.registration,
    this.validUntil,
    this.firebaseUid,
    this.planStartDate,
    this.planEndDate,
  });

  // Getter para verificar se é admin baseado no role
  bool get isAdmin => role == 'ADMIN' || role == 'DIRECTOR';
  
  // Getter para verificar se é associado (todos exceto NON_ASSOCIATE)
  bool get isAssociate => role != null && role != 'NON_ASSOCIATE' && !isAdmin;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'role': role,
      'roleDisplayName': roleDisplayName,
      'registration': registration,
      'validUntil': validUntil,
      'firebaseUid': firebaseUid,
      'planStartDate': planStartDate?.toIso8601String(),
      'planEndDate': planEndDate?.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'],
      phone: json['phone'],
      // Mapeia tanto 'avatarUrl' quanto 'profilePicture' para avatarUrl
      avatarUrl: json['avatarUrl'] ?? json['profilePicture'],
      // Extrai o role do objeto role se existir, senão usa o valor direto
      role: json['role'] is Map ? json['role']['name'] : json['role'],
      roleDisplayName: json['role'] is Map ? json['role']['displayName'] : "Não Associado",
      registration: json['registration'] is int 
        ? json['registration'] 
        : int.tryParse(json['registration']?.toString() ?? ''),
      validUntil: json['validUntil'],
      firebaseUid: json['firebaseUid'],
      planStartDate: json['planStartDate'] != null 
        ? DateTime.tryParse(json['planStartDate']) 
        : null,
      planEndDate: json['planEndDate'] != null 
        ? DateTime.tryParse(json['planEndDate']) 
        : null,
    );
  }

  // Cria uma cópia do modelo atual com alguns campos alterados
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? cpf,
    String? phone,
    String? avatarUrl,
    String? role,
    String? roleDisplayName,
    int? registration,
    String? validUntil,
    String? firebaseUid,
    DateTime? planStartDate,
    DateTime? planEndDate,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      roleDisplayName: roleDisplayName ?? this.roleDisplayName,
      registration: registration ?? this.registration,
      validUntil: validUntil ?? this.validUntil,
      firebaseUid: firebaseUid ?? this.firebaseUid,
      planStartDate: planStartDate ?? this.planStartDate,
      planEndDate: planEndDate ?? this.planEndDate,
    );
  }
}
