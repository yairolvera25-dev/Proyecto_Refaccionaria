import 'package:flutter/material.dart';
import '../../../data/models/producto_model.dart';
import '../../../data/services/inventario_service.dart';

class InventarioProvider extends ChangeNotifier {
  final InventarioService _service = InventarioService();

  List<ProductoModel> _productos = [];
  List<ProductoModel> _productosFiltrados = [];
  bool _cargando = false;
  String _errorMessage = '';

  List<ProductoModel> get productos => _productos;
  List<ProductoModel> get productosFiltrados => _productosFiltrados;
  bool get cargando => _cargando;
  bool get isLoading => _cargando;
  String get errorMessage => _errorMessage;

  InventarioProvider() {
    cargarInventario();
  }

  Future<void> cargarProductos() => cargarInventario();

  Future<void> cargarInventario() async {
    _cargando = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _productos = await _service.getProductos();
      _productosFiltrados = List.from(_productos);
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> agregarProducto(ProductoModel producto) async {
    try {
      await _service.crearProducto(producto);
      await cargarInventario();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> actualizarProducto(ProductoModel producto) async {
    try {
      await _service.actualizarProducto(producto);
      await cargarInventario();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> eliminarProducto(int id) async {
    try {
      await _service.eliminarProducto(id);
      await cargarInventario();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void filtrarPorTexto(String query) {
    if (query.isEmpty) {
      _productosFiltrados = List.from(_productos);
    } else {
      _productosFiltrados = _productos.where((p) {
        return p.nombre.toLowerCase().contains(query.toLowerCase()) ||
            p.sku.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }
}