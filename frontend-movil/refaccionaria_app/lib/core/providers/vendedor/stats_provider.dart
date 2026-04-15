import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StatsProvider extends ChangeNotifier {
  // URLs para desarrollo local hacia Node.js
  // En stats_provider.dart
// DEBE ESTAR ASÍ:
static final String _baseUrlNoSql = dotenv.env['VITE_API_URL_NOSQL'] ?? 'http://127.0.0.1:4000/api';

  final Dio _dio = Dio(BaseOptions(
    baseUrl: _baseUrlNoSql,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Estado
  List<FlSpot> _spots = [];
  bool _isLoading = false;
  String _errorMessage = '';
  List<String> _dias = []; // Opcional, útil para los ejes de la gráfica

  // Getters
  List<FlSpot> get spots => _spots;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<String> get dias => _dias; // Para pintar X axis si se requiere

  /// Ejecuta la petición al endpoint de estadísticas y arma la gráfica
  Future<void> fetchWeeklyStats(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await _dio.get('/ventas/stats/${userId.trim()}');

      if (response.statusCode == 200 && response.data['exito'] == true) {
        final List<dynamic> statsJson = response.data['stats'] ?? [];
        
        final List<FlSpot> nuevosSpots = [];
        final List<String> nuevosDias = [];

        for (int i = 0; i < statsJson.length; i++) {
          final map = statsJson[i];
          
          // parse del total
          final rawTotal = map['total'] ?? 0;
          double totalVenta = 0.0;
          if (rawTotal is num) {
            totalVenta = rawTotal.toDouble();
          } else if (rawTotal is String) {
            totalVenta = double.tryParse(rawTotal) ?? 0.0;
          }

          // Agregamos el FlSpot (x = índice, y = monto de venta)
          nuevosSpots.add(FlSpot(i.toDouble(), totalVenta));
          
          // Opcional: guardamos las fechas para adornar el eje X en la vista
          final String fecha = map['fecha']?.toString() ?? '';
          nuevosDias.add(fecha);
        }

        _spots = nuevosSpots;
        _dias = nuevosDias;
      } else {
        throw Exception("Código ${response.statusCode}");
      }
    } on DioException catch (e) {
      _errorMessage = 'Error de red: ${e.response?.data?['msg'] ?? e.message}';
    } catch (e) {
      _errorMessage = 'Fallo interno: $e';
    } finally {
      // Dibujamos la gráfica
      _isLoading = false;
      notifyListeners();
    }
  }
}
