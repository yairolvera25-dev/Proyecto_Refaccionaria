import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = dotenv.env['API_URL_NOSQL'] ?? 'http://10.0.2.2:4000/api';

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

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // --- PERSISTENCIA DE SESIÓN ---
        if (data['exito'] == true && data['user'] != null) {
          final prefs = await SharedPreferences.getInstance();
          final user = data['user'];
          
          final String userId = user['id']?.toString() ?? '';
          final String rol = user['rol']?.toString().toLowerCase() ?? '';
          // Manejo seguro por si Node.js implementa JWT en el futuro
          final String token = data['token']?.toString() ?? 'session_$userId';
          
          await prefs.setString('token', token);
          await prefs.setString('userId', userId);
          await prefs.setString('rol', rol);
        }

        return data;
      } else {
        final error = jsonDecode(response.body);
        throw error['msg'] ?? 'Error en las credenciales';
      }
    } catch (e) {
      throw "Error de conexión: Verifica que el servidor esté encendido."; 
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('rol');
  }
}