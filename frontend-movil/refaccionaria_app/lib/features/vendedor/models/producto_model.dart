class ProductoModel {
  final int? id;
  final String nombre;
  final String sku;
  final int stock;
  final double precioVenta;
  final String marca;

  ProductoModel({
    this.id,
    required this.nombre,
    required this.sku,
    required this.stock,
    required this.precioVenta,
    required this.marca,
  });

  factory ProductoModel.fromJson(Map<String, dynamic> json) {
    // Función interna para no fallar con los tipos de PHP/Laravel
    int forceInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      return int.tryParse(value.toString()) ?? 0;
    }

    double forceDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return ProductoModel(
      id: json['id'] != null ? forceInt(json['id']) : null,
      nombre: json['nombre']?.toString() ?? json['nombre_producto']?.toString() ?? 'Sin Nombre',
      sku: json['sku']?.toString() ?? 'N/A',
      stock: forceInt(json['cantidad'] ?? json['stock']),
      precioVenta: forceDouble(json['precio_venta'] ?? json['precio']),
      marca: json['marca']?.toString() ?? 'GENÉRICO',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'sku': sku,
      'precio_venta': precioVenta,
      // Lógica de TabInventario.vue: Calculaba 70% del precio venta
      'precio_compra': precioVenta * 0.7, 
      // Lógica de TabInventario.vue: Enviaba ambos nombres para evitar errores en back
      'stock': stock,
      'cantidad': stock,
      'marca': marca,
      // Rellenos obligatorios que mandaba Vue por defecto
      'stock_minimo': 5,
      'id_categoria': 1,
      'descripcion': 'Sin descripción',
    };
  }
}
