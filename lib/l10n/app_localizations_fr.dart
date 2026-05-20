// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LHAGLI';

  @override
  String get appSubtitle => 'Service de livraison en Mauritanie';

  @override
  String get fullName => 'Nom complet';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get continueButton => 'Continuer';

  @override
  String get fieldRequired => 'Ce champ est obligatoire';

  @override
  String get phoneInvalid => 'Numéro invalide (8 chiffres minimum)';

  @override
  String get departure => 'Lieu de départ';

  @override
  String get destination => 'Lieu d\'arrivée';

  @override
  String get vehicleType => 'Type de véhicule';

  @override
  String get car => 'Voiture';

  @override
  String get airplane => 'Avion';

  @override
  String get weight => 'Poids du colis (kg)';

  @override
  String get weightInvalid => 'Entrez un poids valide';

  @override
  String get estimatedPrice => 'Prix estimé';

  @override
  String get confirmOrder => 'Confirmer la commande';

  @override
  String get editOrder => 'Modifier';

  @override
  String get adminPanel => 'Panneau Administrateur';

  @override
  String get noOrders => 'Aucune commande pour le moment';

  @override
  String get call => 'Appeler';

  @override
  String get delete => 'Supprimer';

  @override
  String get updateStatus => 'Modifier le statut';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusDelivered => 'Livré';

  @override
  String get orderConfirmed => 'Commande confirmée avec succès !';

  @override
  String get orderDeleted => 'Commande supprimée';

  @override
  String get errorMessage => 'Une erreur est survenue';

  @override
  String get selectCity => 'Sélectionner une ville';

  @override
  String get sameCityError => 'Départ et arrivée doivent être différents';

  @override
  String get register => 'Inscription';

  @override
  String get newOrder => 'Nouvelle commande';

  @override
  String get client => 'Client';

  @override
  String get trip => 'Trajet';

  @override
  String get vehicle => 'Véhicule';

  @override
  String get price => 'Prix';

  @override
  String get status => 'Statut';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get confirmDeleteMessage =>
      'Voulez-vous vraiment supprimer cette commande ?';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get chooseStatus => 'Choisir un statut';

  @override
  String get mru => 'MRU';

  @override
  String get kg => 'kg';

  @override
  String get km => 'km';
}
