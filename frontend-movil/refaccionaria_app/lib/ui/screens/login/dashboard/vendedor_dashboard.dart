import 'package:flutter/material.dart';

class VendedorDashboard extends StatelessWidget {
  const VendedorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        title: const Text("PUNTO DE VENTA", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.greenAccent.withOpacity(0.1),
      ),
      body: Column(
        children: [
          _buildQuickAction(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSalesItem("Nueva Venta", Icons.add_shopping_cart_rounded, "Inicia una transacción rápida"),
                _buildSalesItem("Catálogo de Piezas", Icons.search_rounded, "Consulta compatibilidad y precios"),
                _buildSalesItem("Mis Ventas del Día", Icons.receipt_long_rounded, "Ver historial de hoy"),
                _buildSalesItem("Clientes", Icons.person_search_rounded, "Registrar o buscar cliente"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction() {
    return Container(
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.greenAccent, Colors.teal]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Meta Diaria", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              Text("85% Completado", style: TextStyle(color: Colors.black54, fontSize: 12)),
            ],
          ),
          Icon(Icons.trending_up_rounded, color: Colors.black, size: 40),
        ],
      ),
    );
  }

  Widget _buildSalesItem(String title, IconData icon, String sub) {
    return Card(
      color: Colors.white.withOpacity(0.05),
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, color: Colors.greenAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
      ),
    );
  }
}
