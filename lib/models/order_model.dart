class OrderModel {
  final String id;
  final String location;
  final String vehicle;
  final double weight;
  final double price;
  final String userName;
  final String userPhone;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.location,
    required this.vehicle,
    required this.weight,
    required this.price,
    required this.userName,
    required this.userPhone,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'vehicle': vehicle,
      'weight': weight,
      'price': price,
      'userName': userName,
      'userPhone': userPhone,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> json, String documentId) {
    return OrderModel(
      id: documentId,
      location: json['location'] ?? '',
      vehicle: json['vehicle'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      userName: json['userName'] ?? '',
      userPhone: json['userPhone'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt']) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
