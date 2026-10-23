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
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = cred.user!.uid;

    final user = Utilisateur(
      uid: uid,
      nom: nom.trim(),
      email: email.trim(),
      role: role,
      ville: ville.trim(),
    );

    // On enregistre le profil dans Firestore: users/{uid}
    await _db.collection('users').doc(uid).set(user.toMap());
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}