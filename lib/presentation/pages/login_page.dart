import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum _AuthMode { login, register }

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  _AuthMode _mode = _AuthMode.login;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit(AuthViewModel auth) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;

    if (_mode == _AuthMode.register) {
      final confirm = _confirmController.text;
      if (password != confirm) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Les mots de passe ne correspondent pas.")),
        );
        return;
      }
      await auth.register(email, password);
    } else {
      await auth.signIn(email, password);
    }

    if (auth.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == _AuthMode.login ? 'Se connecter' : 'Créer un compte'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 400,
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: "Email"),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer un email";
                            }
                            if (!value.contains('@')) {
                              return "Email invalide";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: "Mot de passe"),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer un mot de passe";
                            }
                            if (value.length < 6) {
                              return "Au moins 6 caractères";
                            }
                            return null;
                          },
                        ),
                        if (_mode == _AuthMode.register) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmController,
                            decoration: const InputDecoration(
                              labelText: "Confirmer le mot de passe",
                            ),
                            obscureText: true,
                          ),
                        ],
                        const SizedBox(height: 20),
                        if (auth.isLoading)
                          const CircularProgressIndicator()
                        else
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _submit(auth),
                              child: Text(
                                _mode == _AuthMode.login
                                    ? "Se connecter"
                                    : "Créer un compte",
                              ),
                            ),
                          ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = _mode == _AuthMode.login
                                  ? _AuthMode.register
                                  : _AuthMode.login;
                            });
                          },
                          child: Text(
                            _mode == _AuthMode.login
                                ? "Pas de compte ? Inscrivez-vous"
                                : "Déjà un compte ? Connectez-vous",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
