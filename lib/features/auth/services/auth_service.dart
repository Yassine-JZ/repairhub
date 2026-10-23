import '../models/utilisateur.dart';

class AuthService {
  // Connexion (partie LOGIN)
  Future<Utilisateur?> signIn(String email, String password) async {
    // TODO: implémenter avec FirebaseAuth
    throw UnimplementedError();
  }

  // Inscription (partie CRÉATION DE COMPTE)
  Future<Utilisateur?> signUp({
    required String nom,
    required String email,
    required String password,
    required String role,
    required String ville,
  }) async {
    // TODO: implémenter avec FirebaseAuth + Firestore
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    // TODO
    throw UnimplementedError();
  }
}