import 'package:dio/dio.dart';
import '../models/producto_model.dart';
import 'package:flutter/foundation.dart';

class ResumenService {
  // URLs para desarrollo local (127.0.0.1 si corres en Chrome/Web o iOS simulator)
  // Nota: Node.js suele correr en el puerto 3000, cámbialo si usas otro.
  static const String _baseUrlNoSql = 'http://127.0.0.1:4000/api'; 
  static const String _baseUrlSql = 'http://127.0.0.1:8000/api';

  final Dio _dioNoSql = Dio(BaseOptions(
    baseUrl: _baseUrlNoSql,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  final Dio _dioSql = Dio(BaseOptions(
    baseUrl: _baseUrlSql,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Petición a MONGO DB (Node.js) para traer el historial
  Future<List<dynamic>> getHistorialVentas(String userId) async {
    try {
      // Usamos el puerto 4000 que vimos en tu terminal
      final response = await _dioNoSql.get('/ventas/vendedor/${userId.trim()}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) return data['ventas'] ?? data['data'] ?? [];
        if (data is List) return data;
      }
      return []; 
    } catch (e) {
      print("LOG: Node.js falló, pero seguimos adelante: $e");
      return []; // <--- DEVOLVEMOS LISTA VACÍA PARA QUE NO TRUENE LA UI
    }
  }

  /// Petición a LARAVEL (SQL) para lanzar las alertas 
  Future<List<ProductoModel>> getAlertasStock() async {
    try {
      final response = await _dioSql.get('/productos/bajo-stock');
      if (response.statusCode == 200) {
        // Validación segura de tipos
        dynamic jsonData;
        if (response.data is List) {
          jsonData = response.data;
        } else if (response.data is Map) {
          jsonData = response.data['data'] ?? response.data;
        } else {
          jsonData = response.data;
        }

        if (jsonData is List) {
           return jsonData.map((json) => ProductoModel.fromJson(json)).toList();
        }
        return [];
      } else {
        throw Exception("Error SQL: código ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception('Fallo al cargar alertas SQL: ${e.response?.data['message'] ?? e.message}');
    }
  }
}
