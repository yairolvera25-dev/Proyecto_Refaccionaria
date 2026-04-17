import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- IMPORTACIONES DE PANTALLAS ---
import 'package:refaccionaria_app/features/auth/screens/login_screen.dart';
import 'package:refaccionaria_app/features/auth/screens/register_screen.dart'; // Asegúrate de que este archivo exista
import 'package:refaccionaria_app/features/vendedor/screens/vendedor_main_screen.dart';
import 'package:refaccionaria_app/features/admin/screens/admin_dashboard.dart';
import 'package:refaccionaria_app/features/consultor/screens/consultor_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Carga de variables de entorno (.env)
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Si no encuentra el .env, no detiene la app pero avisa
    debugPrint("Archivo .env no encontrado");
  }

  // 2. Persistencia de sesión (Aquí es donde estaba el error)
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? rol = prefs.getString('rol'); // 🔥 ESTA LÍNEA ES LA QUE FALTABA
  final String userId = prefs.getString('userId') ?? ''; 

  // 3. Lógica para determinar la ruta inicial
  String initialRoute = '/login';

  if (token != null && rol != null) {
    if (rol == 'vendedor') {
      initialRoute = '/vendedor';
    } else if (rol == 'administrador') {
      initialRoute = '/admin';
    } else if (rol == 'consultor') {
      initialRoute = '/consultor';
    }
  }

  runApp(RefaccionariaApp(initialRoute: initialRoute, userId: userId));
}

class RefaccionariaApp extends StatelessWidget {
  final String initialRoute;
  final String userId;

  const RefaccionariaApp({
    super.key, 
    required this.initialRoute, 
    required this.userId
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refaccionaria Los Amigos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: Colors.indigoAccent,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const RoleSelectionPage(),
        '/admin': (context) => const AdminDashboard(),
        '/consultor': (context) => const ConsultorDashboard(),
        '/vendedor': (context) => VendedorMainScreen(userId: userId),
        '/registro': (context) => const RegisterScreen(), // Ruta para Rafael
      },
    );
  }
}