import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/producto_model.dart';

class ResumenService {
  final String baseUrl = "http://localhost:5000/api"; // Ajusta a tu IP de servidor

  Future<List<ProductoModel>> obtenerProductosBajoStock() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/productos/bajo-stock'));
      
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((item) => ProductoModel.fromJson(item)).toList();
      }
      return [];
    } catch (e) {
      print("Error en ResumenService: $e");
      return [];
    }
  }
}