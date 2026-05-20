import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Lahagli Cargo';

  // Pricing configuration
  static const double weightRatePerKg = 2.5; // MRU per kg

  static const Map<String, double> vehicleBaseRates = {
    'Car': 100.0,
    'Van': 250.0,
    'Truck': 600.0,
    'Heavy Trailer': 1200.0,
  };

  // Aesthetic Colors
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF4F46E5); // Darker Indigo
  static const Color accentColor = Color(0xFF10B981); // Emerald
  static const Color backgroundColor = Color(0xFF0F172A); // Slate 900
  static const Color cardColor = Color(0xFF1E293B); // Slate 800
  static const Color textPrimary = Color(0xFFF8FAFC); // Slate 50
  static const Color textSecondary = Color(0xFF94A3B8); // Slate 400

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)], // Slate to Indigo
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
