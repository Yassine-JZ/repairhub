import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const _teal = Color(0xFF0F766E);
  static const _tealDark = Color(0xFF134E4A);

  final _formKey = GlobalKey<FormState>();
  final _nom = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _ville = TextEditingController();

  String _role = 'client';
  bool _hidePass = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _nom.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _ville.dispose();
    super.dispose();
  }
    Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      nom: _nom.text,
      email: _email.text,
      password: _password.text,
      role: _role,
      ville: _ville.text,
    );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compte créé avec succès !')),
      );
      // TODO: redirection selon le rôle (étape suivante)
    }
  }

  InputDecoration _field(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: _teal),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF0FDFA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: _teal, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_tealDark, _teal, Color(0xFF14B8A6)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                children: [
                  Column(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.handyman_rounded,
                          size: 38,
                          color: _teal,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'RepairHub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Créer un compte',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: _nom,
                            textCapitalization: TextCapitalization.words,
                            decoration: _field('Nom', Icons.person_outline),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Obligatoire'
                                    : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _field('Email', Icons.mail_outline),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Obligatoire';
                              }
                              if (!v.contains('@') || !v.contains('.')) {
                                return 'Email invalide';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            obscureText: _hidePass,
                            decoration: _field(
                              'Mot de passe',
                              Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () =>
                                    setState(() => _hidePass = !_hidePass),
                                icon: Icon(
                                  _hidePass
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: _teal,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Obligatoire';
                              if (v.length < 6) return 'Au moins 6 caractères';
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirm,
                            obscureText: _hideConfirm,
                            decoration: _field(
                              'Confirmation',
                              Icons.lock_outline,
                              suffix: IconButton(
                                onPressed: () => setState(
                                  () => _hideConfirm = !_hideConfirm,
                                ),
                                icon: Icon(
                                  _hideConfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: _teal,
                                ),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Obligatoire';
                              if (v != _password.text) {
                                return 'Mots de passe différents';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Rôle',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF334155),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _RoleCard(
                                  label: 'Client',
                                  icon: Icons.person_rounded,
                                  selected: _role == 'client',
                                  onTap: () => setState(() => _role = 'client'),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _RoleCard(
                                  label: 'Réparateur',
                                  icon: Icons.build_rounded,
                                  selected: _role == 'reparateur',
                                  onTap: () =>
                                      setState(() => _role = 'reparateur'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _ville,
                            textCapitalization: TextCapitalization.words,
                            decoration: _field(
                              'Ville',
                              Icons.location_on_outlined,
                            ),
                            validator: (v) =>
                                v == null || v.trim().isEmpty
                                    ? 'Obligatoire'
                                    : null,
                          ),
                          const SizedBox(height: 22),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: auth.isLoading ? null : _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _teal,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: auth.isLoading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                              : const Text(
                                'S’inscrire',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text.rich(
                              TextSpan(
                                text: 'Déjà un compte ? ',
                                style: TextStyle(color: Color(0xFF64748B)),
                                children: [
                                  TextSpan(
                                    text: 'Se connecter',
                                    style: TextStyle(
                                      color: _teal,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF0F766E);
    const amber = Color(0xFFF59E0B);

    return Material(
      color: selected ? teal.withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? teal : const Color(0xFFE2E8F0),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? teal : amber),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: selected ? teal : const Color(0xFF475569),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
