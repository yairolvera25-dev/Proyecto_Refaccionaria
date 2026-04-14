import 'package:dio/dio.dart';

class PosService {
  // Conectamos a Node.js (MongoDB) para registrar la nueva transacción de venta
  static const String _baseUrlNoSql = 'http://127.0.0.1:4000/api';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrlNoSql,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  /// Dispara el POST de la venta hacia Mongo
  Future<void> crearVenta(Map<String, dynamic> ventaData) async {
    try {
      final response = await _dio.post('/ventas', data: ventaData);
      
      // Node.js suele devolver 200 o 201 en creaciones exitosas
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Error del servidor: código ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception('Fallo al registrar la venta: ${e.response?.data['message'] ?? e.message}');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
