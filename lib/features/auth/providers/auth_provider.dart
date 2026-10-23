import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/utilisateur.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  Utilisateur? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Utilisateur? get user => _user;

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _service.signIn(email, password);
      if (_user == null) {
        _errorMessage = "Profil introuvable.";
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _messageErreur(e.code);
    } catch (_) {
      _errorMessage = "Une erreur est survenue. Réessayez.";
    }

    _isLoading = false;
    notifyListeners();
    return _user != null;
  }
    Future<bool> signUp({
    required String nom,
    required String email,
    required String password,
    required String role,
    required String ville,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _service.signUp(
        nom: nom,
        email: email,
        password: password,
        role: role,
        ville: ville,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = _messageErreurInscription(e.code);
    } catch (_) {
      _errorMessage = "Une erreur est survenue. Réessayez.";
    }

    _isLoading = false;
    notifyListeners();
    return _user != null;
  }

  String _messageErreurInscription(String code) {
    switch (code) {
      case 'email-already-in-use':
        return "Cet email est déjà utilisé.";
      case 'invalid-email':
        return "Email invalide.";
      case 'weak-password':
        return "Mot de passe trop faible (6 caractères minimum).";
      case 'network-request-failed':
        return "Pas de connexion internet.";
      default:
        return "Erreur d'inscription ($code).";
    }
  }
  Future<void> signOut() async {
    await _service.signOut();
    _user = null;
    notifyListeners();
  }

  String _messageErreur(String code) {
    switch (code) {
      case 'invalid-email':
        return "Email invalide.";
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return "Email ou mot de passe incorrect.";
      case 'too-many-requests':
        return "Trop de tentatives. Réessayez plus tard.";
      case 'network-request-failed':
        return "Pas de connexion internet.";
      default:
        return "Erreur de connexion ($code).";
    }
  }
}