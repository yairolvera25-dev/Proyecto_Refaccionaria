import 'package:flutter/material.dart';
import '../../../../data/models/producto_model.dart';
import '../../../../data/services/resumen_service.dart';

class ResumenProvider extends ChangeNotifier {
  final ResumenService _service = ResumenService();

  bool _isLoading = false;
  String _errorMessage = '';

  // Listas crudas de base de datos
  List<dynamic> _ordenes = [];
  List<ProductoModel> _productosBajoStock = [];

  // KPIs
  double _totalIngresos = 0.0;
  double _totalComisiones = 0.0;
  int _totalVentasCerradas = 0;

  // Getters para la vista
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<dynamic> get ordenes => _ordenes;
  List<ProductoModel> get productosBajoStock => _productosBajoStock;
  
  double get totalIngresos => _totalIngresos;
  double get totalComisiones => _totalComisiones;
  int get totalVentasCerradas => _totalVentasCerradas;

  /// Llamada principal de inicio (necesita el ID del consultor logueado)
  Future<void> cargarDatos(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Usamos el trim para evitar espacios raros
      final cleanId = userId.trim();

      final futures = await Future.wait([
        _service.getHistorialVentas(cleanId),
        _service.getAlertasStock(),
      ]);

      // Forzamos el casting de forma segura
      _ordenes = (futures[0] as List?) ?? [];
      _productosBajoStock = (futures[1] as List<ProductoModel>?) ?? [];

      _calcularKPIs();
    } catch (e) {
      print("Error en Provider: $e");
      _errorMessage = "ERROR_DE_PROCESAMIENTO: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calcularKPIs() {
    // 1. Total Órdenes (Seguro)
    _totalVentasCerradas = _ordenes.length;

    // 2. Suma de ingresos con validación de tipo ultra estricta
    _totalIngresos = _ordenes.fold(0.0, (acumulador, orden) {
      if (orden is! Map) return acumulador;
      
      // Buscamos el valor en cualquier posible llave
      final rawValue = orden['total_venta'] ?? orden['monto'] ?? 0;
      
      double monto = 0.0;
      if (rawValue is num) {
        monto = rawValue.toDouble();
      } else if (rawValue is String) {
        monto = double.tryParse(rawValue) ?? 0.0;
      }
      
      return acumulador + monto;
    });

    // 3. Comisión
    _totalComisiones = _totalIngresos * 0.05;
  }
}
