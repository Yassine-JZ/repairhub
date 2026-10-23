import 'package:flutter/material.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _ville = TextEditingController();
  String _role = 'client';

  @override
  void dispose() {
    _nom.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _ville.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nom,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Obligatoire' : null,
              ),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Obligatoire';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Email invalide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obligatoire';
                  if (v.length < 6) return 'Au moins 6 caractères';
                  return null;
                },
              ),
              TextFormField(
                controller: _confirm,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmation du mot de passe',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Obligatoire';
                  if (v != _password.text) return 'Mots de passe différents';
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                initialValue: _role,
                decoration: const InputDecoration(labelText: 'Rôle'),
                items: const [
                  DropdownMenuItem(value: 'client', child: Text('Client')),
                  DropdownMenuItem(
                    value: 'reparateur',
                    child: Text('Réparateur'),
                  ),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _role = v);
                },
              ),
              TextFormField(
                controller: _ville,
                decoration: const InputDecoration(labelText: 'Ville'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Obligatoire' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState?.validate();
                },
                child: const Text('S’inscrire'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
