class Utilisateur {
  final String uid;
  final String nom;
  final String email;
  final String role; // 'client' ou 'reparateur'
  final String ville;

  Utilisateur({
    required this.uid,
    required this.nom,
    required this.email,
    required this.role,
    required this.ville,
  });

  // Objet Dart -> Map (pour l'envoyer à Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nom': nom,
      'email': email,
      'role': role,
      'ville': ville,
    };
  }

  // Map (lue depuis Firestore) -> objet Dart
  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      uid: map['uid'] ?? '',
      nom: map['nom'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'client',
      ville: map['ville'] ?? '',
    );
  }
}