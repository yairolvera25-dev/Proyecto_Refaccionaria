import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int selectedIndex = 0;

  List<Map<String, dynamic>> productos = [
    {"nombre": "Filtro aceite", "stock": 20, "precio": 180},
    {"nombre": "Bujía NGK", "stock": 35, "precio": 120}
  ];

  List<Map<String, dynamic>> usuarios = [
    {"nombre": "Hector", "rol": "Administrador"}
  ];

  List<Map<String, dynamic>> ventas = [
    {"folio": "V001", "cliente": "Juan", "total": 850}
  ];

  final List<String> titulos = [
    "Productos",
    "Usuarios",
    "Ventas",
    "Reportes"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(titulos[selectedIndex]),
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
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Productos"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Usuarios"),
          BottomNavigationBarItem(icon: Icon(Icons.sell), label: "Ventas"),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reportes"),
        ],
      ),
    );
  }

  Widget _contenido() {
    switch (selectedIndex) {
      case 0:
        return _crudProductos();
      case 1:
        return _crudUsuarios();
      case 2:
        return _crudVentas();
      default:
        return _reportes();
    }
  }

  Widget _crudProductos() {
    return ListView.builder(
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final item = productos[index];
        return Card(
          color: const Color(0xFF1E293B),
          child: ListTile(
            title: Text(item["nombre"], style: const TextStyle(color: Colors.white)),
            subtitle: Text("Stock: ${item["stock"]}", style: const TextStyle(color: Colors.white70)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("\$${item["precio"]}", style: const TextStyle(color: Colors.cyanAccent)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    setState(() {
                      productos.removeAt(index);
                    });
                  },
                )
              ],
            ),
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
            title: Text(item["nombre"], style: const TextStyle(color: Colors.white)),
            subtitle: Text(item["rol"], style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () {
                setState(() {
                  usuarios.removeAt(index);
                });
              },
            ),
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
            title: Text(item["folio"], style: const TextStyle(color: Colors.white)),
            subtitle: Text(item["cliente"], style: const TextStyle(color: Colors.white70)),
            trailing: Text("\$${item["total"]}", style: const TextStyle(color: Colors.greenAccent)),
          ),
        );
      },
    );
  }

  Widget _reportes() {
    return const Center(
      child: Text(
        "Reportes del sistema",
        style: TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }

  void _agregarRegistro() {
    if (selectedIndex == 0) {
      setState(() {
        productos.add({"nombre": "Nuevo producto", "stock": 10, "precio": 100});
      });
    } else if (selectedIndex == 1) {
      setState(() {
        usuarios.add({"nombre": "Nuevo usuario", "rol": "Vendedor"});
      });
    } else if (selectedIndex == 2) {
      setState(() {
        ventas.add({"folio": "V00${ventas.length + 1}", "cliente": "Cliente", "total": 500});
      });
    }
  }
}
