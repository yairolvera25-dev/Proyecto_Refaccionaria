import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:refaccionaria_app/models/venta_model.dart';

class StockService {
  static String get _base =>
      dotenv.env['API_BASE_URL'] ?? 'http://localhost:4000/api';

  static Future<List<VentaItem>> fetchVentas() async {
    final res = await http.get(Uri.parse('$_base/ventas'));
    if (res.statusCode != 200) throw Exception('Error ${res.statusCode}');
    final List<dynamic> data = json.decode(res.body);
    return data.map((j) => VentaItem.fromJson(j)).toList();
  }

  static Map<String, dynamic> calcStats(List<VentaItem> items) {
    final totalIngresos = items.fold(0.0, (s, i) => s + i.totalVenta);
    final criticos = items.where((i) => i.estado == 'critico').length;
    final pendientes = items.where((i) => i.estado == 'pendiente').length;
    final topItems = List<VentaItem>.from(items)
      ..sort((a, b) => b.cantidad.compareTo(a.cantidad));
    final topProducto = topItems.isEmpty ? 'N/A' : topItems.first.producto;
    return {
      'ingresos': totalIngresos,
      'ordenes': items.length,
      'criticos': criticos,
      'pendientes': pendientes,
      'top': topProducto,
    };
  }
}