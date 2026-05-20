import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/order_model.dart';

class FirebaseService {
  // Check if Firebase has been initialized
  bool get _isFirebaseInitialized {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  // In-memory mock storage for instant testing without Firebase setup
  static final List<OrderModel> _mockOrders = [
    OrderModel(
      id: 'mock_1',
      location: 'Nouakchott Port',
      vehicle: 'Truck',
      weight: 1200,
      price: 3600,
      userName: 'Ahmed Salem',
      userPhone: '+22244445555',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    OrderModel(
      id: 'mock_2',
      location: 'Nouadhibou Freezone',
      vehicle: 'Van',
      weight: 350,
      price: 1125,
      userName: 'Mariam Aly',
      userPhone: '+22233332222',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
  ];

  // Save an order to Firestore or Mock storage
  Future<void> saveOrder(OrderModel order) async {
    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('orders').add(order.toJson());
    } else {
      // Simulate network delay and save in-memory
      await Future.delayed(const Duration(milliseconds: 600));
      final generatedId = 'mock_${DateTime.now().millisecondsSinceEpoch}';
      _mockOrders.add(
        OrderModel(
          id: generatedId,
          location: order.location,
          vehicle: order.vehicle,
          weight: order.weight,
          price: order.price,
          userName: order.userName,
          userPhone: order.userPhone,
          createdAt: order.createdAt,
        ),
      );
    }
  }

  // Stream orders from Firestore or Mock storage
  Stream<List<OrderModel>> getOrdersStream() {
    if (_isFirebaseInitialized) {
      return FirebaseFirestore.instance
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
                .toList();
          });
    } else {
      // Periodic stream emitting copy of local list to simulate live updates
      return Stream.periodic(const Duration(seconds: 1), (_) {
        _mockOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        return List<OrderModel>.from(_mockOrders);
      }).distinct();
    }
  }

  // Delete an order
  Future<void> deleteOrder(String id) async {
    if (_isFirebaseInitialized) {
      await FirebaseFirestore.instance.collection('orders').doc(id).delete();
    } else {
      await Future.delayed(const Duration(milliseconds: 300));
      _mockOrders.removeWhere((order) => order.id == id);
    }
  }
}
