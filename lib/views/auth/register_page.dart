import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = 'utilisateur';

  final AuthService _authService = AuthService.instance;

  void register() async {
    final user = User(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: selectedRole,
    );
    await _authService.registerUser(user);
    Navigator.pop(context); // retour vers login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: usernameController, decoration: const InputDecoration(labelText: "Nom d'utilisateur")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Mot de passe")),
            DropdownButton<String>(
              value: selectedRole,
              onChanged: (value) => setState(() => selectedRole = value!),
              items: const [
                DropdownMenuItem(value: 'utilisateur', child: Text("Utilisateur")),
                DropdownMenuItem(value: 'organisateur', child: Text("Organisateur")),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: register, child: const Text("Créer un compte")),
          ],
        ),
      ),
    );
  }
}
