import 'package:flutter/material.dart';
import 'package:refaccionaria_app/features/vendedor/models/producto_model.dart';
import 'package:refaccionaria_app/features/vendedor/services/inventario_service.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioService _service = InventarioService();

  List<ProductoModel> _productos = [];
  List<ProductoModel> _productosFiltrados = []; // <--- Nueva lista para el buscador
  bool _cargando = false; // <--- Cambiamos nombre si es necesario para que coincida con 'cargando'
  String _errorMessage = '';

  // Getters unificados
  List<ProductoModel> get productos => _productos;
  List<ProductoModel> get productosFiltrados => _productosFiltrados;
  bool get cargando => _cargando;
  bool get isLoading => _cargando; // Alias para compatibilidad
  String get errorMessage => _errorMessage;

  InventarioProvider() {
    cargarInventario();
  }

  // Alias para mantener compatibilidad con InventarioScreen
  Future<void> cargarProductos() => cargarInventario();

  Future<void> cargarInventario() async {
    _cargando = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _productos = await _service.getProductos();
      _productosFiltrados = _productos; // Al inicio, filtrados es igual a todos
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      print("Error cargando inventario: $e");
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  // 👇 ESTA ES LA FUNCIÓN QUE PIDE EL BUSCADOR DEL POS
  void filtrarPorTexto(String query) {
    if (query.isEmpty) {
      _productosFiltrados = _productos;
    } else {
      _productosFiltrados = _productos
          .where((p) => p.nombre.toLowerCase().contains(query.toLowerCase()) || 
                        p.sku.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners(); // Avisa al POS que la lista cambió
  }
}