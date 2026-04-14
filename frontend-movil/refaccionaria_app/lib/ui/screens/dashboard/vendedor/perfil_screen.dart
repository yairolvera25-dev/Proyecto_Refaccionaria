import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../data/services/auth_service.dart';
import '../../login/login_screen.dart'; // Módulo del Login

class PerfilScreen extends StatefulWidget {
  final String userId;

  const PerfilScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final AuthService _authService = AuthService();
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    setState(() => _isLoggingOut = true);
    
    // Llamada al método logout() que limpia SharedPreferences
    await _authService.logout();
    
    if (mounted) {
      // Destruye todo el historial y empuja de cero RoleSelectionPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RoleSelectionPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'MI PERFIL',
          style: TextStyle(
            color: Colors.greenAccent,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            height: 1.0,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.greenAccent, 
                  blurRadius: 4,
                )
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar Gigante
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    )
                  ]
                ),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 32),

              // Glassmorphism Data Cards
              _buildDataCard('ID USUARIO', widget.userId),
              const SizedBox(height: 16),
              _buildDataCard('NIVEL DE ACCESO', 'VENDEDOR_ACCESS'),

              const SizedBox(height: 48),

              // Botón de Cerrar Sesión Rojo Neón
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isLoggingOut ? null : _logout,
                  icon: _isLoggingOut 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2))
                      : const Icon(Icons.power_settings_new, color: Colors.redAccent),
                  label: const Text(
                    'CERRAR SESIÓN',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: [Shadow(color: Colors.redAccent, blurRadius: 4)]
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    side: const BorderSide(color: Colors.redAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.redAccent.withOpacity(0.5),
                    elevation: 10,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataCard(String label, String value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
            boxShadow: [
               BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontFamily: 'monospace',
                  fontSize: 10,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
