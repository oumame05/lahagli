// Constantes globales de l'application LHAGLI
// Contient : couleurs, tarifs, villes et distances

import 'package:flutter/material.dart';

// ─── Couleurs de l'application ────────────────────────────────────────────────
class AppColors {
  static const Color darkBlue = Color(0xFF1A237E);   // Bleu foncé principal
  static const Color orange = Color(0xFFFF6F00);      // Orange accent
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color success = Color(0xFF388E3C);
  static const Color error = Color(0xFFD32F2F);
}

// ─── Tarifs de livraison ──────────────────────────────────────────────────────
class AppRates {
  // Avion : 150 MRU par km + 50 MRU par kg
  static const double airplanePerKm = 150.0;
  static const double airplanePerKg = 50.0;

  // Voiture : 80 MRU par km + 15 MRU par kg
  static const double carPerKm = 80.0;
  static const double carPerKg = 15.0;
}

// ─── Identifiants admin ───────────────────────────────────────────────────────
class AdminCredentials {
  static const String adminName = 'admin';
  static const String adminPhone = '00000000';
}

// ─── Statuts de commande ──────────────────────────────────────────────────────
class OrderStatus {
  static const String pending = 'pending';
  static const String inProgress = 'inProgress';
  static const String delivered = 'delivered';

  static String nextStatus(String current) {
    switch (current) {
      case pending:
        return inProgress;
      case inProgress:
        return delivered;
      default:
        return pending;
    }
  }
}

// ─── Villes de Mauritanie ─────────────────────────────────────────────────────
const List<String> mauritanianCities = [
  'Nouakchott',
  'Nouadhibou',
  'Rosso',
  'Kaédi',
  'Zouérat',
  'Kiffa',
  'Atar',
  'Tidjikja',
  'Néma',
  'Sélibaby',
  'Aleg',
  'Akjoujt',
  'Boutilimit',
  'Timbedra',
  'Aioun',
  'Boghé',
];

// ─── Distances entre villes (en km) ──────────────────────────────────────────
// Clé : "VilleA|VilleB" (ordre alphabétique)
const Map<String, double> cityDistances = {
  'Aioun|Néma': 320.0,
  'Aioun|Nouakchott': 850.0,
  'Aioun|Timbedra': 160.0,
  'Akjoujt|Atar': 300.0,
  'Akjoujt|Nouakchott': 260.0,
  'Akjoujt|Zouérat': 450.0,
  'Aleg|Boutilimit': 160.0,
  'Aleg|Kaédi': 200.0,
  'Aleg|Nouakchott': 260.0,
  'Atar|Nouadhibou': 680.0,
  'Atar|Nouakchott': 460.0,
  'Atar|Zouérat': 400.0,
  'Boghé|Kaédi': 180.0,
  'Boghé|Nouakchott': 380.0,
  'Boghé|Rosso': 220.0,
  'Boutilimit|Nouakchott': 160.0,
  'Boutilimit|Rosso': 200.0,
  'Kaédi|Nouakchott': 460.0,
  'Kaédi|Sélibaby': 250.0,
  'Kiffa|Néma': 500.0,
  'Kiffa|Nouakchott': 600.0,
  'Néma|Nouakchott': 1100.0,
  'Néma|Timbedra': 160.0,
  'Nouadhibou|Nouakchott': 480.0,
  'Nouadhibou|Zouérat': 480.0,
  'Nouakchott|Rosso': 200.0,
  'Nouakchott|Tidjikja': 680.0,
  'Nouakchott|Zouérat': 820.0,
  'Rosso|Sélibaby': 420.0,
  'Sélibaby|Nouakchott': 700.0,
  'Tidjikja|Kiffa': 320.0,
  'Timbedra|Néma': 160.0,
  'Zouérat|Nouakchott': 820.0,
};

// Retourne la distance entre deux villes
double getDistance(String cityA, String cityB) {
  if (cityA == cityB) return 0.0;
  final List<String> sorted = [cityA, cityB]..sort();
  final String key = '${sorted[0]}|${sorted[1]}';
  if (cityDistances.containsKey(key)) return cityDistances[key]!;
  return _distanceViaHub(cityA, cityB);
}

double _distanceViaHub(String cityA, String cityB) {
  const String hub = 'Nouakchott';
  if (cityA == hub || cityB == hub) return 500.0;
  final double distA = getDistance(cityA, hub);
  final double distB = getDistance(cityB, hub);
  if (distA > 0 && distB > 0) return (distA + distB) * 0.7;
  return 500.0;
}

// Calcul du prix total
double calculatePrice({
  required String departure,
  required String destination,
  required String vehicleType,
  required double weightKg,
}) {
  final double distance = getDistance(departure, destination);
  if (vehicleType == 'airplane') {
    return (distance * AppRates.airplanePerKm) + (weightKg * AppRates.airplanePerKg);
  } else {
    return (distance * AppRates.carPerKm) + (weightKg * AppRates.carPerKg);
  }
}