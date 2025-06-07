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

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
                'Informe um usuário (email) e uma senha para se cadastrar ou para realizar o login'),
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
              labelText: 'Senha',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String email = _emailController.text;
              String password = _passwordController.text;
              authService
                  .register(
                      email: email, password: password, name: 'Nome do Usuário')
                  .then((value) {
                if (value == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value),
                      duration: Duration(seconds: 4),
                    ),
                  );
                }
              });
            },
            child: const Text('Register'),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              String email = _emailController.text;
              String password = _passwordController.text;

              authService.login(email: email, password: password).then((value) {
                if (value == null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RecipeListPage()),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value),
                      duration: Duration(seconds: 4),
                    ),
                  );
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
