import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/screens/login/login_screen.dart';
import 'ui/screens/dashboard/vendedor/vendedor_main_screen.dart';
import 'ui/screens/login/dashboard/admin_dashboard.dart';
import 'ui/screens/login/dashboard/consultor_dashboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');
  final String? rol = prefs.getString('rol');
  final String? userId = prefs.getString('userId');

  Widget initialScreen = const RoleSelectionPage();

  if (token != null && rol != null && userId != null) {
    if (rol == 'vendedor') {
      initialScreen = VendedorMainScreen(userId: userId);
    } else if (rol == 'administrador') {
      initialScreen = const AdminDashboard();
    } else {
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
      routes: {
        '/login': (_) => const RoleSelectionPage(),
        '/admin': (_) => const AdminDashboard(),
        '/consultor': (_) => const ConsultorDashboard(),
      },
    );
  }
}