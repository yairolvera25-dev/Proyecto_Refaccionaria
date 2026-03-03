import 'package:flutter/material.dart';

void main() => runApp(const RefaccionariaApp());

class RefaccionariaApp extends StatelessWidget {
  const RefaccionariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refaccionaria Los Amigos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey,
      ),
      home: const RoleSelectionPage(),
    );
  }
}

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  void _intentarLogin() {
    String user = _userController.text;
    String pass = _passController.text;

    // Lógica de validación por roles
    if (selectedRole == "Administrador" && user == "admin" && pass == "1234") {
      _navegar(const AdminDashboard());
    } else if (selectedRole == "Vendedor" && user == "ventas" && pass == "1234") {
      _navegar(const VendedorDashboard());
    } else if (selectedRole == "Consultor" && user == "user" && pass == "1234") {
      _navegar(const ConsultorDashboard());
    } else {
      // Si los datos están mal, mostramos un error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario o contraseña incorrectos para este rol")),
      );
    }
  }

  void _navegar(Widget pantalla) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pantalla));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Colors.blueGrey, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.settings_suggest, size: 80, color: Colors.white),
                const Text("REFACCIONARIA", 
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                const SizedBox(height: 30),
                
                const Text("Selecciona tu rol:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                const SizedBox(height: 15),

                _buildRoleCard("Administrador", Icons.admin_panel_settings, Colors.redAccent),
                _buildRoleCard("Vendedor", Icons.point_of_sale, Colors.green),
                _buildRoleCard("Consultor", Icons.person_search, Colors.blue),

                if (selectedRole != null) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Text("Acceso como $selectedRole", style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        TextField(
                          controller: _userController,
                          decoration: const InputDecoration(labelText: 'Usuario', filled: true, border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Contraseña', filled: true, border: OutlineInputBorder()),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white),
                            onPressed: _intentarLogin, 
                            child: const Text("ENTRAR AL SISTEMA"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(String title, IconData icon, Color color) {
    bool isSelected = selectedRole == title;
    return GestureDetector(
      onTap: () => setState(() => selectedRole = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : color),
            const SizedBox(width: 15),
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black87)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

// --- PANTALLAS DE DESTINO ---

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Admin - Inventario"), backgroundColor: Colors.redAccent),
      body: Center(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar Sesión"))),
    );
  }
}

class VendedorDashboard extends StatelessWidget {
  const VendedorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Caja - Ventas"), backgroundColor: Colors.green),
      body: Center(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar Sesión"))),
    );
  }
}

class ConsultorDashboard extends StatelessWidget {
  const ConsultorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buscador de Stock"), backgroundColor: Colors.blue),
      body: Center(child: ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Cerrar Sesión"))),
    );
  }
}