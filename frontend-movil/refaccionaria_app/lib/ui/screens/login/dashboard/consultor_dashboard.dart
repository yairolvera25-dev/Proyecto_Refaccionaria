import 'package:flutter/material.dart';

class ConsultorDashboard extends StatelessWidget {
  const ConsultorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("CONSULTOR DE STOCK"),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const TextField(
                  decoration: InputDecoration(
                    hintText: "Buscar por código o nombre...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoTile("Bujía NGK", "Pasillo A - Estante 4", "12 unidades"),
                _buildInfoTile("Aceite Castrol 5W30", "Pasillo B - Estante 1", "5 unidades"),
                _buildInfoTile("Filtro Aire Sentra", "Pasillo A - Estante 2", "20 unidades"),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(String part, String location, String stock) {
    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.blueAccent, width: 4)),
        color: Colors.white.withOpacity(0.02),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(part, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(location, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ]),
          Text(stock, style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}