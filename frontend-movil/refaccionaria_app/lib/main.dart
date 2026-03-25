import 'package:flutter/material.dart';
import 'core/theme.dart'; 
import 'ui/screens/login/login_screen.dart'; // Aquí vive RoleSelectionPage
import 'ui/screens/login/dashboard/vendedor_dashboard.dart';
import 'ui/screens/login/dashboard/consultor_dashboard.dart';
import 'ui/screens/login/dashboard/admin_dashboard.dart';

void main() => runApp(const RefaccionariaApp());

class RefaccionariaApp extends StatelessWidget {
  const RefaccionariaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refaccionaria Los Amigos',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, 

      // CAMBIAMOS LoginScreen() por RoleSelectionPage()
      home: const RoleSelectionPage(), 

      routes: {
        '/login': (context) => const RoleSelectionPage(),
        '/vendedor': (context) => const VendedorDashboard(),
        '/consultor': (context) => const ConsultorDashboard(),
        '/admin': (context) => const AdminDashboard(),
      },
    );
  }
}