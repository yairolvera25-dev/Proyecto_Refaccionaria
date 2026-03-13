import 'package:flutter/material.dart';

class ConsultorDashboard extends StatelessWidget {
  const ConsultorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: const Color(0xFF1A1F2B),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text("CONSULTA DE STOCK", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blueAccent.withOpacity(0.3), Colors.transparent])
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Barra de búsqueda profesional
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Buscar por nombre, código o marca...",
                      prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildSectionHeader("CATEGORÍAS"),
                  const SizedBox(height: 15),
                  _buildCategories(),
                  const SizedBox(height: 30),
                  _buildSectionHeader("RESULTADOS DISPONIBLES"),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildStockCard(),
              childCount: 10, // Simulando muchos items
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white54, fontWeight: FontWeight.bold, fontSize: 12)),
        const Icon(Icons.filter_list, color: Colors.blueAccent, size: 18),
      ],
    );
  }

  Widget _buildCategories() {
    final cats = ["Motor", "Frenos", "Suspensión", "Eléctrico", "Llantas"];
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cats.length,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(right: 10),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blueAccent.withOpacity(0.3)),
          ),
          child: Center(child: Text(cats[i], style: const TextStyle(fontSize: 12))),
        ),
      ),
    );
  }

  Widget _buildStockCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          const Icon(Icons.settings_suggest, color: Colors.blueAccent, size: 30),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Bujía Iridium IX", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Marca: NGK | Pasillo 4-B", style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          ),
          Column(
            children: [
              const Text("Stock", style: TextStyle(color: Colors.white38, fontSize: 10)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
                child: const Text("45", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }
}