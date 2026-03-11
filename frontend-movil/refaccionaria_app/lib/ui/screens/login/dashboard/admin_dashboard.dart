import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        title: const Text("PANEL DE CONTROL ADMIN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.logout_rounded))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildAdminCard("Gestión de Usuarios", Icons.people_alt_rounded, Colors.blueAccent),
            _buildAdminCard("Inventario Global", Icons.inventory_2_rounded, Colors.orangeAccent),
            _buildAdminCard("Reportes de Ventas", Icons.analytics_rounded, Colors.greenAccent),
            _buildAdminCard("Configuración API", Icons.api_rounded, Colors.purpleAccent),
            _buildAdminCard("Auditoría Log", Icons.history_rounded, Colors.redAccent),
            _buildAdminCard("Copia de Seguridad", Icons.storage_rounded, Colors.tealAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}