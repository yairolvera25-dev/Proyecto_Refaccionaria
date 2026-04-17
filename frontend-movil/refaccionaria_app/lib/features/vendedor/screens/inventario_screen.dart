import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refaccionaria_app/features/vendedor/providers/inventario_provider.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectamos el Provider a este contexto
    return ChangeNotifierProvider(
      create: (_) => InventarioProvider(),
      child: const _InventarioView(),
    );
  }
}

class _InventarioView extends StatelessWidget {
  const _InventarioView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escuchamos los cambios del provider
    final provider = context.watch<InventarioProvider>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'SYS.INVENTARIO',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        // Línea inferior neón
        // Línea inferior neón (¡Corregida!)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.5), // El color se muda adentro
              // Efecto glow leve
              boxShadow: const [
                BoxShadow(
                  color: Colors.greenAccent, 
                  blurRadius: 4,
                )
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(InventarioProvider provider) {
    // 1. Estado de Carga
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.greenAccent,
          backgroundColor: Colors.white10,
        ),
      );
    }

    // 2. Estado de Error
    if (provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
           padding: const EdgeInsets.all(24.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               const Icon(Icons.warning_amber_rounded, color: Colors.greenAccent, size: 48),
               const SizedBox(height: 16),
               Text(
                 'ERROR: ${provider.errorMessage}',
                 textAlign: TextAlign.center,
                 style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace'),
               ),
               const SizedBox(height: 24),
               OutlinedButton.icon(
                 onPressed: provider.cargarProductos,
                 icon: const Icon(Icons.refresh),
                 label: const Text('REINTENTAR', style: TextStyle(fontFamily: 'monospace', letterSpacing: 1.5)),
                 style: OutlinedButton.styleFrom(
                   foregroundColor: Colors.greenAccent,
                   side: const BorderSide(color: Colors.greenAccent),
                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                 ),
               )
             ],
           ),
        ),
      );
    }

    // 3. Estado Vacío
    if (provider.productos.isEmpty) {
      return const Center(
        child: Text(
          'SIN RESULTADOS EN BD //',
          style: TextStyle(color: Colors.white54, fontFamily: 'monospace', letterSpacing: 2),
        ),
      );
    }

    // 4. Lista de Productos
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.productos.length,
      itemBuilder: (context, index) {
        final prod = provider.productos[index];
        return Card(
          color: Colors.black,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.greenAccent.withOpacity(0.3)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        prod.nombre.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${prod.sku}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Badge de Stock
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.1),
                          border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'STOCK: ${prod.stock}',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 10,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                // Precio a la derecha
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${prod.precioVenta.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        fontSize: 18,
                        shadows: [
                          Shadow(
                            color: Colors.greenAccent,
                            blurRadius: 8,
                          )
                        ]
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
