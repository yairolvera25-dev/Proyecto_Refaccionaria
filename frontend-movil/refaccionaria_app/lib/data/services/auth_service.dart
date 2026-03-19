// lib/data/services/auth_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- Importa dotenv

class AuthService {
  // Obtenemos la URL base del .env, con un fallback por si falla
  final String _baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000/api';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login'); // Construimos la ruta final

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

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body);
        throw error['msg'] ?? 'Error en las credenciales';
      }
    } catch (e) {
      throw "Error de conexión: Verifica que el servidor esté encendido."; 
    }
  }
}