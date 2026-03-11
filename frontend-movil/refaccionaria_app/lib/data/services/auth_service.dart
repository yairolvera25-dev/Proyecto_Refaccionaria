import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Asegúrate de que esta URL sea la de tu ngrok actual
  final String _baseUrl = 'https://jeffery-preevolutional-isabel.ngrok-free.dev/api/auth/login';

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'ngrok-skip-browser-warning': 'true', 
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw error['msg'] ?? 'Error en las credenciales';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}