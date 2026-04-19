import 'package:flutter/material.dart';
import 'package:refaccionaria_app/features/vendedor/models/producto_model.dart';
import 'package:refaccionaria_app/features/vendedor/services/resumen_service.dart';

class ResumenProvider extends ChangeNotifier {
  final ResumenService _service = ResumenService();

  // Variables de estado
  List<ProductoModel> _productosBajoStock = [];
  List<dynamic> _ordenes = [];
  double _totalIngresos = 0.0;
  int _totalVentasCerradas = 0;
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters que la UI (ResumenScreen) necesita
  List<ProductoModel> get productosBajoStock => _productosBajoStock;
  List<dynamic> get ordenes => _ordenes;
  double get totalIngresos => _totalIngresos;
  int get totalVentasCerradas => _totalVentasCerradas;
  double get totalComisiones => _totalIngresos * 0.05; // 5% de comisión
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> cargarDatos(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Llamada al servicio para obtener todo
      _productosBajoStock = await _service.obtenerProductosBajoStock();
      
      // Aquí podrías agregar más llamadas al servicio para órdenes e ingresos reales
      // Por ahora, inicializamos con datos base para que la app no truene
      _ordenes = []; 
      _totalIngresos = 0.0;
      _totalVentasCerradas = 0;

    } catch (e) {
      _errorMessage = 'Error al sincronizar con el sistema: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}