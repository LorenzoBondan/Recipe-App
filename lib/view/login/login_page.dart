import 'package:flutter/material.dart';
import 'package:recipe_app/services/auth_service.dart';
import 'package:recipe_app/view/recipe/recipe_list_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: const LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService authService = AuthService();

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _validateInputs() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showError('Please fill in all fields before continuing.');
      return false;
    }
    return true;
  }

  String _extractUsername(String email) {
    final atIndex = email.indexOf('@');
    return atIndex != -1 ? email.substring(0, atIndex) : email;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Enter an email and password to register or log in.',
              textAlign: TextAlign.center,
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
          ),
          const SizedBox(height: 20.0),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (!_validateInputs()) return;

              final email = _emailController.text;
              final password = _passwordController.text;
              final username = _extractUsername(email);

              authService
                  .register(
                      email: email,
                      password: password,
                      name: username)
                  .then((value) {
                if (value == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListPage(),
                    ),
                  );
                } else {
                  _showError(value);
                }
              });
            },
            child: const Text('Register'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (!_validateInputs()) return;

              final email = _emailController.text;
              final password = _passwordController.text;

              authService.login(email: email, password: password).then((value) {
                if (value == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecipeListPage(),
                    ),
                  );
                } else {
                  _showError(value);
                }
              });
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }
}
