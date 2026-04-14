class VentaItem {
  final String id;
  final String producto;
  final int cantidad;
  final double precio;
  final DateTime fecha;
  final String sku;
  final String estado; // 'vendido', 'pendiente', 'critico'

  VentaItem({
    required this.id,
    required this.producto,
    required this.cantidad,
    required this.precio,
    required this.fecha,
    required this.sku,
    required this.estado,
  });

  factory VentaItem.fromJson(Map<String, dynamic> json) {
    String name = 'Sin nombre';
    if (json['producto'] != null) name = json['producto'];
    else if (json['nombre_pieza'] != null) name = json['nombre_pieza'];
    else if (json['productos_vendidos'] != null &&
        (json['productos_vendidos'] as List).isNotEmpty) {
      name = json['productos_vendidos'][0]['nombre_pieza'] ?? 'Venta';
    }

    int qty = 0;
    if (json['cantidad'] != null) qty = json['cantidad'];
    else if (json['productos_vendidos'] != null &&
        (json['productos_vendidos'] as List).isNotEmpty) {
      qty = json['productos_vendidos'][0]['cantidad'] ?? 0;
    }

    double price = 0;
    if (json['precio'] != null) price = (json['precio'] as num).toDouble();
    else if (json['total'] != null) price = (json['total'] as num).toDouble();

    DateTime date = DateTime.now();
    if (json['fecha'] != null) {
      try { date = DateTime.parse(json['fecha']); } catch (_) {}
    }

    final rawId = json['_id'].toString();
    final sku = "REF-${rawId.substring(rawId.length - 6)}";

    String estado = 'vendido';
    if (qty == 0) estado = 'critico';
    else if (qty <= 2) estado = 'pendiente';

    return VentaItem(
      id: rawId,
      producto: name,
      cantidad: qty,
      precio: price,
      fecha: date,
      sku: sku,
      estado: estado,
    );
  }

  double get totalVenta => precio * cantidad;
}