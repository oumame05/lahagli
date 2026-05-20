// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LHAGLI';

  @override
  String get appSubtitle => 'Delivery Service in Mauritania';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get continueButton => 'Continue';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get phoneInvalid => 'Invalid number (minimum 8 digits)';

  @override
  String get departure => 'Departure';

  @override
  String get destination => 'Destination';

  @override
  String get vehicleType => 'Vehicle Type';

  @override
  String get car => 'Car';

  @override
  String get airplane => 'Airplane';

  @override
  String get weight => 'Package Weight (kg)';

  @override
  String get weightInvalid => 'Enter a valid weight';

  @override
  String get estimatedPrice => 'Estimated Price';

  @override
  String get confirmOrder => 'Confirm Order';

  @override
  String get editOrder => 'Edit';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get call => 'Call';

  @override
  String get delete => 'Delete';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get orderConfirmed => 'Order confirmed successfully!';

  @override
  String get orderDeleted => 'Order deleted';

  @override
  String get errorMessage => 'An error occurred';

  @override
  String get selectCity => 'Select a city';

  @override
  String get sameCityError => 'Departure and destination must be different';

  @override
  String get register => 'Registration';

  @override
  String get newOrder => 'New Order';

  @override
  String get client => 'Client';

  @override
  String get trip => 'Trip';

  @override
  String get vehicle => 'Vehicle';

  @override
  String get price => 'Price';

  @override
  String get status => 'Status';

  @override
  String get confirmDelete => 'Confirm Deletion';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this order?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get chooseStatus => 'Choose a status';

  @override
  String get mru => 'MRU';

  @override
  String get kg => 'kg';

  @override
  String get km => 'km';
}
