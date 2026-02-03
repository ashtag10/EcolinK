import 'package:flutter/material.dart';
import 'package:ecolink/ui/core/themes/colors.dart';
import 'package:ecolink/ui/core/localization/applocalization.dart';
import 'package:go_router/go_router.dart';
import '../../routing/routes.dart';
import '../../data/services/mock_auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _remember = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  bool _loading = false;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);
      try {
        final user = await MockAuthService.instance
            .login(phone: _phoneCtrl.text, password: _passwordCtrl.text);
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
    final loc = AppLocalization.of(context);
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
                Text(
                  loc.login,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 22),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "N° téléphone",
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Veuillez saisir votre numéro'
                            : null,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Mot de passe',
                        ),
                        validator: (v) => (v == null || v.trim().length < 6)
                            ? 'Mot de passe invalide'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: _remember,
                            onChanged: (v) =>
                                setState(() => _remember = v ?? false),
                          ),
                          const SizedBox(width: 4),
                          const Text('Se souvenir de moi'),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: const Text('Mot de passe oublié ?'),
                          ),
                        ],
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
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () => context.go(AppRoutes.register),
                          child: const Text("S'inscrire"),
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
