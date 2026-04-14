import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/vendedor/inventario_provider.dart';

class InventarioScreen extends StatelessWidget {
  const InventarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => InventarioProvider(),
      child: const _InventarioView(),
    );
  }
}

class _InventarioView extends StatelessWidget {
  const _InventarioView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<InventarioProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: provider.productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = provider.productosFiltrados[index];

                return ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text('SKU: ${producto.sku}'),
                  trailing: Text('\$${producto.precioVenta}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}