import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://localhost/codeigniter_api/';

  static Future<void> registerUser(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/register'),
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
      print('User registered successfully');
    } else {
      print('Failed to register user: ${response.body}');
    }
  }

  static Future<void> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      print('Login failed: ${response.body}');
    }
  }
}
