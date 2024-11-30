import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String usernameError = '';
  String emailError = '';
  String passwordError = '';

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= 6;
  }

  Future<void> registerUser(BuildContext context) async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() {
      usernameError = '';
      emailError = '';
      passwordError = '';
    });

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        if (username.isEmpty) usernameError = 'Username tidak boleh kosong';
        if (email.isEmpty) emailError = 'Email tidak boleh kosong';
        if (password.isEmpty) passwordError = 'Password tidak boleh kosong';
      });
      return;
    }

    if (!isValidEmail(email)) {
      setState(() {
        emailError = 'Email tidak valid!';
      });
      return;
    }

    if (!isValidPassword(password)) {
      setState(() {
        passwordError = 'Password harus memiliki minimal 6 karakter!';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('http://localhost:8080/codeigniter_api/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Registrasi Berhasil'),
            content: Text('Akun berhasil dibuat. Silakan login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final errorResponse = jsonDecode(response.body);
      setState(() {
        final errors = errorResponse['errors'];
        usernameError = errors['username'] ?? '';
        emailError = errors['email'] ?? '';
        passwordError = errors['password'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            if (usernameError.isNotEmpty)
              Text(
                usernameError,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            if (emailError.isNotEmpty)
              Text(
                emailError,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (passwordError.isNotEmpty)
              Text(
                passwordError,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                registerUser(context);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
