// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Lahagli Cargo';

  @override
  String get registerTitle => 'Create Profile';

  @override
  String get registerSubtitle =>
      'Enter your name and phone number to start ordering transport services.';

  @override
  String get nameLabel => 'Full Name';

  @override
  String get nameError => 'Please enter your name';

  @override
  String get phoneLabel => 'Phone Number';

  @override
  String get phoneError => 'Please enter a valid phone number';

  @override
  String get registerButton => 'Register & Continue';

  @override
  String get createOrderTitle => 'New Transport Request';

  @override
  String get locationLabel => 'Destination Location';

  @override
  String get locationError => 'Please enter location';

  @override
  String get vehicleLabel => 'Vehicle Type';

  @override
  String get weightLabel => 'Weight (kg)';

  @override
  String get calculatedPrice => 'Estimated Price';

  @override
  String get currency => 'MRU';

  @override
  String get placeOrderButton => 'Submit Request';

  @override
  String get adminPanelButton => 'Admin Panel';

  @override
  String get orderSuccess => 'Order submitted successfully!';

  @override
  String get adminTitle => 'All Cargo Orders';

  @override
  String get deleteTooltip => 'Delete order';

  @override
  String get callTooltip => 'Call client';

  @override
  String get noOrders => 'No cargo requests placed yet.';

  @override
  String weightDisplay(num weight) {
    final intl.NumberFormat weightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String weightString = weightNumberFormat.format(weight);

    return '$weightString kg';
  }

  @override
  String clientName(String name) {
    return 'Client: $name';
  }

  @override
  String clientPhone(String phone) {
    return 'Phone: $phone';
  }
}
