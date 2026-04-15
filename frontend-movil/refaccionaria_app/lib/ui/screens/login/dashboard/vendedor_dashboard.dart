import 'package:flutter/material.dart';

class VendedorDashboard extends StatelessWidget {
  const VendedorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("PUNTO DE VENTA", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.greenAccent.withOpacity(0.1),
            child: const Icon(Icons.person, color: Colors.greenAccent),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatsCard(),
            const SizedBox(height: 30),
            const Text("ACCIONES RÁPIDAS", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildActionButton(Icons.add_shopping_cart, "Nueva Venta", Colors.greenAccent),
                _buildActionButton(Icons.people, "Clientes", Colors.blueAccent),
                _buildActionButton(Icons.history, "Cortes", Colors.orangeAccent),
              ],
            ),
            const SizedBox(height: 30),
            const Text("PRODUCTOS RECIENTES", style: TextStyle(color: Colors.white54, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            _buildProductItem("Batería LTH 12V", "Ref: LTH-90", "\$2,450.00", "https://m.media-amazon.com/images/I/71p0WfB6Z6L._AC_SL1500_.jpg"),
            _buildProductItem("Aceite Mobil 1", "5W-30 Sintético", "\$890.00", "https://m.media-amazon.com/images/I/71v9TfS3v0L._AC_SL1500_.jpg"),
            _buildProductItem("Balatas Brembo", "Cerámica - Kit", "\$1,200.00", "https://m.media-amazon.com/images/I/61Nl8s6I80L._AC_SL1200_.jpg"),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.greenAccent.withOpacity(0.2), Colors.teal.withOpacity(0.1)]),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ventas de Hoy", style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
          Text("\$12,450.00", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.greenAccent, size: 16),
              Text(" +15% más que ayer", style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildProductItem(String name, String sub, String price, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imgUrl, 
              width: 50, 
              height: 50, 
              fit: BoxFit.cover, // Corregido: de BoxCover a BoxFit.cover
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, color: Colors.white24),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}