// Modèle représentant un utilisateur (client ou admin)
// Contient uniquement le nom et le numéro de téléphone

class UserModel {
  final String name;
  final String phone;

  const UserModel({
    required this.name,
    required this.phone,
  });

  // Vérifie si l'utilisateur est admin
  bool get isAdmin => name == 'admin' && phone == '00000000';

  Map<String, dynamic> toMap() => {'name': name, 'phone': phone};

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    name: map['name'] as String? ?? '',
    phone: map['phone'] as String? ?? '',
  );
}