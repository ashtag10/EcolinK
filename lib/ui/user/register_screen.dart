import 'package:flutter/material.dart';
import 'package:ecolink/ui/core/themes/colors.dart';
import 'package:go_router/go_router.dart';
import '../../routing/routes.dart';
import '../../data/services/mock_auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();


  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  bool _loading = false;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);
      try {
        final user = await MockAuthService.instance.register(
          name: _nameCtrl.text,
          phone: _phoneCtrl.text,
          password: _passwordCtrl.text,
        );
        if (!mounted) return;
        context.go(AppRoutes.home, extra: user);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(height: 8),
                const Text(
                  "S'inscrire",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Nom d\'utilisateur'),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Veuillez saisir un nom'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration:
                            const InputDecoration(labelText: "N° téléphone"),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Veuillez saisir un numéro'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Mot de passe'),
                        validator: (v) => (v == null || v.trim().length < 6)
                            ? 'Le mot de passe doit faire au moins 6 caractères'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirmer le mot de passe'),
                        validator: (v) => (v != _passwordCtrl.text)
                            ? 'Les mots de passe ne correspondent pas'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.vertEcolink,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text('S\'inscrire',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.login),
                          child: const Text('Vous avez un compte ?'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 140),
              ],
            ),
          ),
           // --- Background aligné en bas ---
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.fill,
              width: size.width,
            ),
          ),
        ]),
      ),
    );
  }
}
