class TicketModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String status; // available, reserved, sold, used, cancelled
  final String? userStatus; // not_paid, paid, used, expired, cancelled, refunded
  final String eventId;
  final String? userId;
  final DateTime? purchasedAt;
  final DateTime? usedAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  TicketModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.status,
    this.userStatus,
    required this.eventId,
    this.userId,
    this.purchasedAt,
    this.usedAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: _parsePrice(json['price']),
      status: json['status'] ?? 'available',
      userStatus: json['userStatus'],
      eventId: json['eventId'] ?? '',
      userId: json['userId'],
      purchasedAt: json['purchasedAt'] != null 
          ? DateTime.parse(json['purchasedAt']) 
          : null,
      usedAt: json['usedAt'] != null 
          ? DateTime.parse(json['usedAt']) 
          : null,
      expiresAt: json['expiresAt'] != null 
          ? DateTime.parse(json['expiresAt']) 
          : null,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'status': status,
      'userStatus': userStatus,
      'eventId': eventId,
      'userId': userId,
      'purchasedAt': purchasedAt?.toIso8601String(),
      'usedAt': usedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Método para fazer parse seguro do preço
  static double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      try {
        return double.parse(price.replaceAll(',', '.'));
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  // Getters para status formatados
  String get statusFormatted {
    switch (status.toLowerCase()) {
      case 'available':
        return 'Disponível';
      case 'reserved':
        return 'Reservado';
      case 'sold':
        return 'Vendido';
      case 'used':
        return 'Usado';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  String get userStatusFormatted {
    if (userStatus == null) return '';
    
    switch (userStatus!.toLowerCase()) {
      case 'not_paid':
        return 'Não Pago';
      case 'paid':
        return 'Pago';
      case 'used':
        return 'Usado';
      case 'expired':
        return 'Expirado';
      case 'cancelled':
        return 'Cancelado';
      case 'refunded':
        return 'Reembolsado';
      default:
        return userStatus!;
    }
  }

  // Status final para exibição
  String get displayStatus {
    if (userStatus != null) {
      return userStatusFormatted;
    }
    return statusFormatted;
  }

  // Status para o ticket card (compatibilidade com widget existente)
  String get ticketCardStatus {
    if (userStatus != null) {
      switch (userStatus!.toLowerCase()) {
        case 'paid':
          return 'valid';
        case 'used':
          return 'used';
        case 'expired':
          return 'expired';
        case 'not_paid':
          return 'unpaid';
        case 'cancelled':
        case 'refunded':
          return 'expired';
        default:
          return 'unpaid';
      }
    }
    
    switch (status.toLowerCase()) {
      case 'available':
        return 'valid';
      case 'sold':
        return 'valid';
      case 'reserved':
        return 'unpaid'; // Tickets reservados aparecem como não pagos
      case 'used':
        return 'used';
      case 'cancelled':
        return 'expired';
      default:
        return 'unpaid';
    }
  }

  bool get isAvailable => status.toLowerCase() == 'available';
  bool get isReserved => status.toLowerCase() == 'reserved';
  bool get isSold => status.toLowerCase() == 'sold';
  bool get isUsed => status.toLowerCase() == 'used' || userStatus?.toLowerCase() == 'used';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get isPaid => userStatus?.toLowerCase() == 'paid';
  bool get isExpired => userStatus?.toLowerCase() == 'expired';

  TicketModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? status,
    String? userStatus,
    String? eventId,
    String? userId,
    DateTime? purchasedAt,
    DateTime? usedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TicketModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      status: status ?? this.status,
      userStatus: userStatus ?? this.userStatus,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      usedAt: usedAt ?? this.usedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
