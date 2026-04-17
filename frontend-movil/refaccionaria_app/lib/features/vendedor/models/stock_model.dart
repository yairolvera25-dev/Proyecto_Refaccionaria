class StockItem {
  final String id;
  final String nombre;
  final int cantidad;
  final String sku;

  StockItem({required this.id, required this.nombre, required this.cantidad, required this.sku});

  factory StockItem.fromJson(Map<String, dynamic> json) {
    // Buscador inteligente de nombres en el JSON de Atlas
    String name = 'Sin nombre';
    if (json['producto'] != null) name = json['producto'];
    else if (json['nombre_pieza'] != null) name = json['nombre_pieza'];
    else if (json['productos_vendidos'] != null && json['productos_vendidos'].isNotEmpty) {
      name = json['productos_vendidos'][0]['nombre_pieza'] ?? 'Venta';
    }

    // Buscador de cantidades
    int qty = 0;
    if (json['cantidad'] != null) qty = json['cantidad'];
    else if (json['productos_vendidos'] != null && json['productos_vendidos'].isNotEmpty) {
      qty = json['productos_vendidos'][0]['cantidad'] ?? 0;
    }

    return StockItem(
      id: json['_id'].toString(),
      nombre: name,
      cantidad: qty,
      sku: "REF-${json['_id'].toString().substring(json['_id'].toString().length - 6)}",
    );
  }
}