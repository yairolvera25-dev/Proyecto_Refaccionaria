import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importamos ambos Providers y el Modelo
import '../../../../core/providers/vendedor/inventario_provider.dart';
import '../../../../core/providers/vendedor/pos_provider.dart';
import '../../../../data/models/producto_model.dart';

class PosScreen extends StatelessWidget {
  final String userId;

  // Por ahora lo probamos con el mock; cuando unas tu Login, le pasas el ID real.
  const PosScreen({Key? key, this.userId = 'tu_usuario_id_de_mongo'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 💡 MultiProvider nos permite tener 2 cerebros trabajando en la misma pantalla
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => InventarioProvider()), // Descarga el catálogo
        ChangeNotifierProvider(create: (_) => PosProvider()),        // Gestiona el carrito
      ],
      child: _PosView(userId: userId),
    );
  }
}

class _PosView extends StatelessWidget {
  final String userId;
  const _PosView({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 👁️ Escuchamos ambos cerebros
    final invProvider = context.watch<InventarioProvider>();
    final posProvider = context.watch<PosProvider>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'SYS.TERMINAL_POS',
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
        actions: [
          // Ícono decorativo de estado de red
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.wifi, color: Colors.greenAccent.withOpacity(0.5), size: 16),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
             height: 1.0,
             decoration: BoxDecoration(
               color: Colors.greenAccent.withOpacity(0.5),
               boxShadow: const [BoxShadow(color: Colors.greenAccent, blurRadius: 6)],
             ),
          ),
        ),
      ),
      
      // CUERPO: Buscador + Lista
      body: Column(
        children: [
          _buildSearchBar(invProvider),
          Expanded(
            child: invProvider.cargando 
              ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
              : _buildCatalogoList(invProvider, posProvider),
          )
        ],
      ),
      
      // BLOQUE INFERIOR: Panel de Cobro Permanente
      bottomNavigationBar: _buildCheckoutPanel(context, posProvider),
    );
  }

  // ===================== WIDGETS PRIVADOS =====================

  Widget _buildSearchBar(InventarioProvider invProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF05080A),
          hintText: '> BUSCAR_ITEM...',
          hintStyle: TextStyle(color: Colors.greenAccent.withOpacity(0.3), fontFamily: 'monospace'),
          prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), 
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1))
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12), 
            borderSide: BorderSide(color: Colors.greenAccent.withOpacity(0.5))
          ),
        ),
        onChanged: invProvider.filtrarPorTexto,
      ),
    );
  }

  Widget _buildCatalogoList(InventarioProvider invProvider, PosProvider posProvider) {
    final productos = invProvider.productosFiltrados;

    if (productos.isEmpty) {
       return Center(
         child: Text(
           'NO_MATCHES_FOUND //',
           style: TextStyle(color: Colors.white.withOpacity(0.3), fontFamily: 'monospace', letterSpacing: 2.0),
         ),
       );
    }

    return ListView.builder(
      itemCount: productos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        final prod = productos[index];
        final bool hayStock = prod.stock > 0;

        return Card(
          color: Colors.black,
          margin: const EdgeInsets.only(bottom: 8),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white.withOpacity(0.05)),
            borderRadius: BorderRadius.circular(12)
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            title: Text(
               prod.nombre.toUpperCase(),
               style: const TextStyle(
                 color: Colors.white, 
                 fontFamily: 'monospace', 
                 fontWeight: FontWeight.bold, 
                 fontSize: 12
               ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: hayStock ? Colors.greenAccent.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      border: Border.all(color: hayStock ? Colors.greenAccent.withOpacity(0.5) : Colors.red.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'STCK: ${prod.stock}', 
                      style: TextStyle(
                        color: hayStock ? Colors.greenAccent : Colors.red, 
                        fontFamily: 'monospace', 
                        fontSize: 9, 
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '\$${prod.precioVenta.toStringAsFixed(2)}', 
                    style: TextStyle(color: Colors.white.withOpacity(0.5), fontFamily: 'monospace', fontSize: 11)
                  )
                ]
              ),
            ),
            // Botón NEÓN interactivo
            trailing: InkWell(
              onTap: hayStock ? () => posProvider.agregarAlCarrito(prod) : null,
               borderRadius: BorderRadius.circular(50),
               child: Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   color: hayStock ? Colors.greenAccent.withOpacity(0.1) : Colors.white10,
                   border: Border.all(color: hayStock ? Colors.greenAccent : Colors.white24)
                 ),
                 child: Icon(
                   Icons.add, 
                   color: hayStock ? Colors.greenAccent : Colors.white24, 
                   size: 20
                 ),
               ),
            ),
          )
        );
      },
    );
  }

  // ===================== PANEL FINAL =====================

  Widget _buildCheckoutPanel(BuildContext context, PosProvider posProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.black,
        border: const Border(top: BorderSide(color: Colors.greenAccent, width: 2)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.15), 
            blurRadius: 20, 
            spreadRadius: 2, 
            offset: const Offset(0, -5)
          )
        ]
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             // Textos a la izquierda
             Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     const Text('TOTAL_DUE', style: TextStyle(color: Colors.white54, fontFamily: 'monospace', fontSize: 10)),
                     const SizedBox(width: 8),
                     // Contenedor de "Items"
                     Container(
                       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                       decoration: BoxDecoration(color: Colors.greenAccent.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                       child: Text('[${posProvider.carrito.length} ITEM]', style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 8, fontWeight: FontWeight.bold)),
                     )
                   ],
                 ),
                 const SizedBox(height: 4),
                 Text(
                   '\$${posProvider.total.toStringAsFixed(2)}', 
                   style: const TextStyle(
                     color: Colors.greenAccent, 
                     fontFamily: 'monospace', 
                     fontSize: 26, 
                     fontWeight: FontWeight.w900, 
                     shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)]
                   )
                 ),
               ]
             ),
             // Botón de Pago
             _buildPayButton(context, posProvider),
          ]
        ),
      ),
    );
  }

  Widget _buildPayButton(BuildContext context, PosProvider posProvider) {
    final bool canPay = posProvider.carrito.isNotEmpty && !posProvider.isLoading;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: canPay ? Colors.greenAccent.withOpacity(0.15) : Colors.white10,
        side: BorderSide(color: canPay ? Colors.greenAccent : Colors.white24, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
      ),
      onPressed: canPay ? () async {
        final success = await posProvider.procesarVenta(userId);
        if (success) {
           _showMatrixDialog(context);
        } else {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
               content: Text('⚠️ ERR: ${posProvider.errorMessage}', style: const TextStyle(fontFamily: 'monospace', color: Colors.black)),
               backgroundColor: Colors.redAccent,
             )
           );
        }
      } : null,
      child: posProvider.isLoading 
         ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.greenAccent, strokeWidth: 2))
         : const Text('COBRAR', style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16)),
    );
  }

  // ===================== EFECTO FEEDBACK =====================

  void _showMatrixDialog(BuildContext context) {
    showDialog(
      context: context, 
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.greenAccent.withOpacity(0.8), width: 2), 
          borderRadius: BorderRadius.circular(16)
        ),
        title: const Row(
          children: [
            Icon(Icons.terminal, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text('// SYSTEM_MSG', style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          '> TRANSACCION_COMPLETADA\n> DATOS ESCRITOS EN MONGODB\n> ESPERANDO_NUEVO_CLIENTE...', 
          style: TextStyle(color: Colors.white70, fontFamily: 'monospace', fontSize: 12)
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), 
            style: TextButton.styleFrom(foregroundColor: Colors.greenAccent),
            child: const Text('[ OK_CONTINUE ]', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, letterSpacing: 1.5))
          )
        ]
      )
    );
  }
}
