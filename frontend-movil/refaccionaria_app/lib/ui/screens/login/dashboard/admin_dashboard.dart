import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;
  String busqueda = "";

  List<Map<String, dynamic>> productos = [
    {"nombre": "Filtro aceite", "stock": 20, "precio": 180},
    {"nombre": "Bujía NGK", "stock": 35, "precio": 120}
  ];

  List<Map<String, dynamic>> usuarios = [
    {"nombre": "Hector", "rol": "Administrador"},
    {"nombre": "Carlos", "rol": "Vendedor"}
  ];

  List<Map<String, dynamic>> ventas = [
    {"folio": "V001", "cliente": "Juan", "total": 850}
  ];

  final List<String> titulos = [
    "Inicio",
    "Usuarios",
    "Productos",
    "Ventas"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(titulos[selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _mostrarBusqueda,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: _contenido(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyanAccent,
        onPressed: _agregarRegistro,
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF0F172A),
        currentIndex: selectedIndex,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Inicio"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Usuarios"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Productos"),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: "Ventas"),
        ],
      ),
    );
  }

  Widget _contenido() {
    switch (selectedIndex) {
      case 0:
        return _dashboardInicio();
      case 1:
        return _crudUsuarios();
      case 2:
        return _crudProductos();
      default:
        return _crudVentas();
    }
  }

  Widget _dashboardInicio() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _cardResumen("Usuarios", usuarios.length.toString(), Icons.people),
        _cardResumen("Productos", productos.length.toString(), Icons.inventory),
        _cardResumen("Ventas", ventas.length.toString(), Icons.sell),
        _cardResumen("Ingresos", "\$850", Icons.attach_money),
      ],
    );
  }

  Widget _cardResumen(String titulo, String valor, IconData icono) {
    return Card(
      color: const Color(0xFF1E293B),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, color: Colors.cyanAccent, size: 35),
            const SizedBox(height: 10),
            Text(valor,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
            Text(titulo,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _crudProductos() {
    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final item = productos[index];
        return Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            title: Text(item["nombre"],
                style: const TextStyle(color: Colors.white)),
            subtitle: Text("Stock: ${item["stock"]}",
                style: const TextStyle(color: Colors.white70)),
            trailing: Text("\$${item["precio"]}",
                style: const TextStyle(color: Colors.cyanAccent)),
          ),
        );
      },
    );
  }

  Widget _crudUsuarios() {
    return ListView.builder(
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final item = usuarios[index];
        return Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            title: Text(item["nombre"],
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(item["rol"],
                style: const TextStyle(color: Colors.white70)),
          ),
        );
      },
    );
  }

  Widget _crudVentas() {
    return ListView.builder(
      itemCount: ventas.length,
      itemBuilder: (context, index) {
        final item = ventas[index];
        return Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            title: Text(item["folio"],
                style: const TextStyle(color: Colors.white)),
            subtitle: Text(item["cliente"],
                style: const TextStyle(color: Colors.white70)),
            trailing: Text("\$${item["total"]}",
                style: const TextStyle(color: Colors.greenAccent)),
          ),
        );
      },
    );
  }

  void _agregarRegistro() {
    setState(() {
      productos.add({
        "nombre": "Nuevo producto",
        "stock": 10,
        "precio": 100
      });
    });
  }

  void _mostrarBusqueda() {
    showSearch(
      context: context,
      delegate: SearchDelegateCustom(productos),
    );
  }
}

class SearchDelegateCustom extends SearchDelegate {
  final List<Map<String, dynamic>> productos;

  SearchDelegateCustom(this.productos);

  @override
  List<Widget>? buildActions(BuildContext context) => [];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) {
    final resultados = productos
        .where((p) =>
            p["nombre"].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: resultados
          .map((p) => ListTile(title: Text(p["nombre"])))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}