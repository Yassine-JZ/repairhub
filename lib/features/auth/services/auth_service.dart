import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/utilisateur.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Connexion (partie LOGIN)
  Future<Utilisateur?> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;

    // On lit le profil (nom, rôle, ville) dans Firestore
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return Utilisateur.fromMap(doc.data()!);
  }

  // Inscription (partie CRÉATION DE COMPTE) - à faire par Aziz
  Future<Utilisateur?> signUp({
    required String nom,
    required String email,
    required String password,
    required String role,
    required String ville,
  }) async {
    // TODO
    throw UnimplementedError();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}