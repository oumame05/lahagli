// Provider principal - gère l'état global de l'application
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../utils/constants.dart';

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  void setUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  String? _departure;
  String? _destination;
  String _vehicleType = 'car';
  double _weightKg = 0.0;
  double _calculatedPrice = 0.0;

  String? get departure => _departure;
  String? get destination => _destination;
  String get vehicleType => _vehicleType;
  double get weightKg => _weightKg;
  double get calculatedPrice => _calculatedPrice;

  void setDeparture(String? city) {
    _departure = city;
    _recalculatePrice();
    notifyListeners();
  }

  void setDestination(String? city) {
    _destination = city;
    _recalculatePrice();
    notifyListeners();
  }

  void setVehicleType(String type) {
    _vehicleType = type;
    _recalculatePrice();
    notifyListeners();
  }

  void setWeight(double weight) {
    _weightKg = weight;
    _recalculatePrice();
    notifyListeners();
  }

  void _recalculatePrice() {
    if (_departure != null && _destination != null && _departure != _destination) {
      _calculatedPrice = calculatePrice(
        departure: _departure!,
        destination: _destination!,
        vehicleType: _vehicleType,
        weightKg: _weightKg,
      );
    } else {
      _calculatedPrice = 0.0;
    }
  }

  Stream<List<OrderModel>> getOrdersStream() => _firebaseService.getOrders();

  Future<void> confirmOrder() async {
    if (_currentUser == null || _departure == null || _destination == null) {
      throw Exception('Données manquantes pour confirmer la commande');
    }
    final OrderModel order = OrderModel(
      name: _currentUser!.name,
      phone: _currentUser!.phone,
      departure: _departure!,
      destination: _destination!,
      vehicle: _vehicleType,
      weight: _weightKg,
      price: _calculatedPrice,
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
    );
    await _firebaseService.addOrder(order);
    _resetOrderForm();
  }

  Future<void> deleteOrder(String orderId) async {
    await _firebaseService.deleteOrder(orderId);
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    await _firebaseService.updateOrderStatus(orderId, newStatus);
  }

  Locale _locale = const Locale('fr');
  Locale get locale => _locale;

  void toggleLanguage() {
    _locale = _locale.languageCode == 'fr'
        ? const Locale('en')
        : const Locale('fr');
    notifyListeners();
  }

  void _resetOrderForm() {
    _departure = null;
    _destination = null;
    _vehicleType = 'car';
    _weightKg = 0.0;
    _calculatedPrice = 0.0;
    notifyListeners();
  }

  void resetAll() {
    _currentUser = null;
    _resetOrderForm();
  }
}