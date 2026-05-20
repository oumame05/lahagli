// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Lahagli Cargo';

  @override
  String get registerTitle => 'Créer un Profil';

  @override
  String get registerSubtitle =>
      'Saisissez votre nom et votre numéro de téléphone pour commencer à commander.';

  @override
  String get nameLabel => 'Nom Complet';

  @override
  String get nameError => 'Veuillez entrer votre nom';

  @override
  String get phoneLabel => 'Numéro de Téléphone';

  @override
  String get phoneError => 'Veuillez entrer un numéro de téléphone valide';

  @override
  String get registerButton => 'S\'enregistrer & Continuer';

  @override
  String get createOrderTitle => 'Nouvelle Demande de Transport';

  @override
  String get locationLabel => 'Lieu de Destination';

  @override
  String get locationError => 'Veuillez entrer le lieu de destination';

  @override
  String get vehicleLabel => 'Type de Véhicule';

  @override
  String get weightLabel => 'Poids (kg)';

  @override
  String get calculatedPrice => 'Prix Estimé';

  @override
  String get currency => 'MRU';

  @override
  String get placeOrderButton => 'Soumettre la Demande';

  @override
  String get adminPanelButton => 'Panneau d\'Administration';

  @override
  String get orderSuccess => 'Demande soumise avec succès !';

  @override
  String get adminTitle => 'Toutes les Demandes';

  @override
  String get deleteTooltip => 'Supprimer la commande';

  @override
  String get callTooltip => 'Appeler le client';

  @override
  String get noOrders => 'Aucune demande de transport enregistrée.';

  @override
  String weightDisplay(num weight) {
    final intl.NumberFormat weightNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String weightString = weightNumberFormat.format(weight);

    return '$weightString kg';
  }

  @override
  String clientName(String name) {
    return 'Client : $name';
  }

  @override
  String clientPhone(String phone) {
    return 'Téléphone : $phone';
  }
}
