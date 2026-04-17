import 'package:flutter/material.dart';
// Importa el modelo de producto (suponiendo que está en su nueva carpeta)
import 'package:refaccionaria_app/features/vendedor/models/producto_model.dart';
// ¡OJO AQUÍ! Cambiamos resumen_service por pos_service
import 'package:refaccionaria_app/features/vendedor/services/pos_service.dart'; 



class PosProvider extends ChangeNotifier {
  final PosService _service = PosService();

  // El estado central interactivo de la UI
  final List<ProductoModel> _carrito = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters Públicos
  List<ProductoModel> get carrito => _carrito;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Matemática limpia: suma iterando la lista en vivo
  double get total => _carrito.fold(0.0, (suma, producto) => suma + producto.precioVenta);

  /// 🛒 MÉTODOS DEL CARRITO
  void agregarAlCarrito(ProductoModel producto) {
    _carrito.add(producto);
    notifyListeners(); // Actualiza la UI instantáneamente
  }

  void eliminarDelCarrito(int id) {
    // Buscamos solo el PRIMER índice de ese producto para no borrar la cantidad total si agregó varios
    final index = _carrito.indexWhere((p) => p.id == id);
    if (index != -1) {
      _carrito.removeAt(index);
      notifyListeners();
    }
  }

  void vaciarCarrito() {
    _carrito.clear();
    notifyListeners();
  }

  void limpiarError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// 💸 PROCESAMIENTO FINAL (Checkout)
  Future<bool> procesarVenta(String userId) async {
    if (_carrito.isEmpty) {
      _errorMessage = 'El carrito no tiene productos.';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      // Agrupación y mapeo para Node.js (Ajusta los nombres según tu Schema)
      final Map<String, dynamic> ventaData = {
        'id_vendedor': userId.trim(),
        'id_sucursal_orig': 1, // Tu Mongoose schema requiere esto (puedes hacerlo en duro temporalmente al ser mobile)
        'items': _carrito.map((p) => { 
            'id': p.id,            
            'sku': p.sku,
            'nombre': p.nombre,
            'cantidad': 1,
            'precio': p.precioVenta,
        }).toList(),
        'total_venta': total, 
        'metodo_pago': 'EFECTIVO',
      };

      await _service.crearVenta(ventaData);
      
      // La transacción fue un éxito en base de datos, reseteamos UI
      vaciarCarrito();
      return true;

    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
