import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/screens/login/login_screen.dart';
import 'ui/screens/dashboard/vendedor/vendedor_main_screen.dart';
import 'ui/screens/login/dashboard/admin_dashboard.dart';

// 2. Convierte el main en asíncrono
Future<void> main() async {
  // Inicializamos los bindings de Flutter antes de cargar un asset
  WidgetsFlutterBinding.ensureInitialized();
  
  // 3. Inicializa dotenv antes de arrancar la app
  await dotenv.load(fileName: ".env"); 

  // --- VERIFICACIÓN DE SESIÓN ---
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token'); // <- Si existe, está logueado
  final String? rol = prefs.getString('rol');
  final String? userId = prefs.getString('userId');

  Widget initialScreen = const RoleSelectionPage(); // Por defecto al login

  if (token != null && rol != null && userId != null) {
    if (rol == 'vendedor') {
       initialScreen = VendedorMainScreen(userId: userId);
    } else if (rol == 'administrador') {
       initialScreen = const AdminDashboard();
    } else {
       // Si es consultor, usamos el dashboard temporal integrado que exporta login_screen 
       initialScreen = const ConsultorDashboard(); 
    }
  }

  runApp(RefaccionariaApp(initialScreen: initialScreen));
}

class RefaccionariaApp extends StatelessWidget {
  final Widget initialScreen;
  
  const RefaccionariaApp({super.key, required this.initialScreen});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refaccionaria Los Amigos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, 
        brightness: Brightness.dark,
      ),
      home: initialScreen, 
    );
  }
}