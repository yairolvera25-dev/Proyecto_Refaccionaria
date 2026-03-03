import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  bool _isLoading = false;

  // --- LÓGICA DE CONEXIÓN REAL ---
  Future<void> _intentarLogin() async {
    if (selectedRole == null) {
      _mostrarError("Por favor, selecciona un rol primero");
      return;
    }

    setState(() => _isLoading = true);

    // URL del servidor de Rafiki (vía ngrok)
    final url = Uri.parse('https://jeffery-preevolutional-isabel.ngrok-free.dev/api/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          // Header obligatorio para que ngrok no bloquee la petición en el navegador
          'ngrok-skip-browser-warning': 'true', 
        },
        body: jsonEncode({
          'email': _userController.text.trim(),
          'password': _passController.text.trim(),
        }),
      );

      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String serverRole = data['user']['role'].toString().toLowerCase();
        
        // Redirección automática según el rol que devuelve el servidor
        if (serverRole == 'administrador') {
          _navegar(const AdminDashboard());
        } else if (serverRole == 'vendedor') {
          _navegar(const VendedorDashboard());
        } else {
          _navegar(const ConsultorDashboard());
        }
      } else {
        // Manejo de errores de credenciales (401, 404, etc.)
        final errorMsg = jsonDecode(response.body);
        _mostrarError(errorMsg['msg'] ?? "Credenciales incorrectas");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      // Si sale este error, es bloqueo de navegador o servidor apagado
      _mostrarError("Error de conexión. Revisa el link de ngrok.");
      print("Detalle técnico: $e");
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent),
    );
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
                const SizedBox(height: 60),
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
                          decoration: const InputDecoration(labelText: 'Correo Electrónico', filled: true, border: OutlineInputBorder()),
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
                            onPressed: _isLoading ? null : _intentarLogin, 
                            child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                              : const Text("ENTRAR AL SISTEMA"),
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
          boxShadow: [if (isSelected) const BoxShadow(color: Colors.black26, blurRadius: 8)],
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

// --- PANTALLAS DE DESTINO (DASHBOARD) ---

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Admin"), backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Bienvenido Administrador", style: TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Salir"))
        ],
      )),
    );
  }
}

class VendedorDashboard extends StatelessWidget {
  const VendedorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Ventas"), backgroundColor: Colors.green, foregroundColor: Colors.white),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Bienvenido Vendedor", style: TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Salir"))
        ],
      )),
    );
  }
}

class ConsultorDashboard extends StatelessWidget {
  const ConsultorDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel Consultas"), backgroundColor: Colors.blue, foregroundColor: Colors.white),
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Bienvenido Consultor", style: TextStyle(fontSize: 20)),
          ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Salir"))
        ],
      )),
    );
  }
}