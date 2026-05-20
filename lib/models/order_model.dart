// Modèle représentant une commande de livraison

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String? id;
  final String name;
  final String phone;
  final String departure;
  final String destination;
  final String vehicle;    // 'car' ou 'airplane'
  final double weight;     // kg
  final double price;      // MRU
  final String status;     // 'pending', 'inProgress', 'delivered'
  final DateTime createdAt;

  const OrderModel({
    this.id,
    required this.name,
    required this.phone,
    required this.departure,
    required this.destination,
    required this.vehicle,
    required this.weight,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'phone': phone,
    'departure': departure,
    'destination': destination,
    'vehicle': vehicle,
    'weight': weight,
    'price': price,
    'status': status,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      phone: data['phone'] as String? ?? '',
      departure: data['departure'] as String? ?? '',
      destination: data['destination'] as String? ?? '',
      vehicle: data['vehicle'] as String? ?? 'car',
      weight: (data['weight'] as num?)?.toDouble() ?? 0.0,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      status: data['status'] as String? ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  OrderModel copyWith({
    String? id, String? name, String? phone,
    String? departure, String? destination, String? vehicle,
    double? weight, double? price, String? status, DateTime? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      departure: departure ?? this.departure,
      destination: destination ?? this.destination,
      vehicle: vehicle ?? this.vehicle,
      weight: weight ?? this.weight,
      price: price ?? this.price,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}