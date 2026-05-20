// Service Firebase - gère toutes les interactions avec Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'orders';

  CollectionReference get _ordersRef => _firestore.collection(_collection);

  Future<String> addOrder(OrderModel order) async {
    final DocumentReference doc = await _ordersRef.add(order.toMap());
    return doc.id;
  }

  Stream<List<OrderModel>> getOrders() {
    return _ordersRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    });
  }

  Future<void> deleteOrder(String orderId) async {
    await _ordersRef.doc(orderId).delete();
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _ordersRef.doc(orderId).update({'status': newStatus});
  }
}