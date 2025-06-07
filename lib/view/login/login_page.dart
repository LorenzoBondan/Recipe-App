import 'package:flutter/material.dart';
import 'package:recipe_app/services/auth_service.dart';
import 'package:recipe_app/view/recipe/recipe_list_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      home: const Scaffold(
        body: LoginForm(),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[700]),
      floatingLabelStyle: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[500]!),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(3.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(3.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(3.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your email and password to continue',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _emailController,
              decoration: _inputDecoration('Email'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: _inputDecoration('Password'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                if (!_validateInputs()) return;

                final email = _emailController.text;
                final password = _passwordController.text;
                final username = _extractUsername(email);

                authService.register(
                  email: email,
                  password: password,
                  name: username,
                ).then((value) {
                  if (value == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeListPage()),
                    );
                  } else {
                    _showError(value);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!_validateInputs()) return;

                final email = _emailController.text;
                final password = _passwordController.text;

                authService.login(email: email, password: password).then((value) {
                  if (value == null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RecipeListPage()),
                    );
                  } else {
                    _showError(value);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
