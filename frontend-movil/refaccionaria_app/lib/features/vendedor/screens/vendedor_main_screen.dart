import 'package:flutter/material.dart';
import 'package:refaccionaria_app/features/vendedor/screens/resumen_screen.dart';
import 'package:refaccionaria_app/features/vendedor/screens/pos_screen.dart';
import 'package:refaccionaria_app/features/vendedor/screens/inventario_screen.dart';
import 'package:refaccionaria_app/features/vendedor/screens/perfil_screen.dart';

class VendedorMainScreen extends StatefulWidget {
  final String userId;

  const VendedorMainScreen({Key? key, this.userId = 'tu_usuario_id_de_mongo'}) : super(key: key);

  @override
  State<VendedorMainScreen> createState() => _VendedorMainScreenState();
}

class _VendedorMainScreenState extends State<VendedorMainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Inicializamos las pantallas pasándoles el userId donde sea requerido
    _screens = [
      ResumenScreen(userId: widget.userId),
      PosScreen(userId: widget.userId),
      const InventarioScreen(), 
      PerfilScreen(userId: widget.userId),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border(
            top: BorderSide(
              color: Colors.greenAccent.withOpacity(0.5),
              width: 1.0,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.greenAccent,
          unselectedItemColor: Colors.white54,
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
          ),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard, shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)]),
              label: 'RESUMEN',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart, shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)]),
              label: 'POS',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2, shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)]),
              label: 'INVENTARIO',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, shadows: [Shadow(color: Colors.greenAccent, blurRadius: 10)]),
              label: 'PERFIL',
            ),
          ],
        ),
      ),
    );
  }
}
