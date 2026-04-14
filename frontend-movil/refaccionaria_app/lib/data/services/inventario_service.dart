import 'package:dio/dio.dart';
import '../models/producto_model.dart';

class InventarioService {
  final Dio _dio = Dio(
    BaseOptions(
      // Recuerda cambiar a tu IP o dominio en producción
      baseUrl: 'http://127.0.0.1:8000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    )
  );

  /// Equivalente a `fetchProductos()` de Vue
  Future<List<ProductoModel>> getProductos() async {
    try {
      final response = await _dio.get('/productos');
      
      if (response.statusCode == 200) {
        // --- AQUÍ ESTÁ LA MAGIA CORREGIDA ---
        dynamic jsonData;
        
        // Si Laravel manda la lista directa [{}, {}]
        if (response.data is List) {
          jsonData = response.data;
        } 
        // Si Laravel lo manda envuelto en { "data": [{}, {}] }
        else {
          jsonData = response.data['data'] ?? response.data;
        }

        if (jsonData is List) {
          return jsonData.map((json) => ProductoModel.fromJson(json)).toList();
        } else {
          throw Exception("El backend devolvió un formato no iterable");
        }
      } else {
        throw Exception("Error del servidor: código ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception("Error de respuesta del backend: ${e.response?.data['message'] ?? e.message}");
      } else {
        throw Exception("Error de red o conexión rechazada.");
      }
    } catch (e) {
      throw Exception("Error al listar: $e");
    }
  }

  /// Equivalente a la petición POST en `guardarProducto()` de Vue
  Future<void> crearProducto(ProductoModel producto) async {
    try {
      await _dio.post('/productos', data: producto.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "No se pudo crear el producto");
    }
  }

  /// Equivalente a la petición PUT en `guardarProducto()` de Vue
  Future<void> actualizarProducto(ProductoModel producto) async {
    try {
      if (producto.id == null) throw Exception("ID de producto inválido");
      await _dio.put('/productos/${producto.id}', data: producto.toJson());
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "No se pudo actualizar el producto");
    }
  }

  /// Equivalente a `ejecutarEliminar()` de Vue
  Future<void> eliminarProducto(int id) async {
    try {
      await _dio.delete('/productos/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Asegúrate de que no tenga ventas asociadas.");
    }
  }
}
