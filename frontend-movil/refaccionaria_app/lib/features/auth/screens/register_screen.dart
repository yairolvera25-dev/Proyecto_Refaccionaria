import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String? selectedRole;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("Crear Cuenta", style: TextStyle(fontWeight: FontWeight.bold))),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("Selecciona el rol que desempeñarás:", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  
                  // 🔥 SOLICITAR ROL PARA DAR DE ALTA
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF161B26),
                    decoration: _inputStyle("Seleccionar Rol", Icons.badge_outlined),
                    items: ["Administrador", "Vendedor", "Consultor"]
                        .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                        .toList(),
                    onChanged: (val) => setState(() => selectedRole = val),
                    validator: (v) => v == null ? "Selecciona un rol" : null,
                  ),
                  
                  const SizedBox(height: 20),
                  TextFormField(decoration: _inputStyle("Nombre Completo", Icons.person_outline)),
                  const SizedBox(height: 15),
                  TextFormField(decoration: _inputStyle("Correo Institucional", Icons.email_outlined)),
                  const SizedBox(height: 15),
                  TextFormField(obscureText: true, decoration: _inputStyle("Contraseña", Icons.lock_outline)),
                  
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF818CF8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Aquí va la lógica de Rafael para el backend
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registro enviado a revisión")));
                        }
                      },
                      child: const Text("REGISTRAR USUARIO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.indigoAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(0.05),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    );
  }
}