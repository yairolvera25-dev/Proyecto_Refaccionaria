import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = dotenv.env['VITE_API_URL_NOSQL']!;

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        if (data['token'] != null) {
          await prefs.setString('token', data['token']);
        }

        return {
          'ok': true,
          'data': data,
        };
      } else {
        return {
          'ok': false,
          'message': data['message'] ?? 'Error en login',
        };
      }
    } catch (e) {
      return {
        'ok': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
