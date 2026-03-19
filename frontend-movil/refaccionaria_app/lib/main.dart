import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <--- 1. Importa esto
import 'ui/screens/login/login_screen.dart';

// 2. Convierte el main en asíncrono
Future<void> main() async {
  // Inicializamos los bindings de Flutter antes de cargar un asset
  WidgetsFlutterBinding.ensureInitialized();
  // 3. Inicializa dotenv antes de arrancar la app
  await dotenv.load(fileName: ".env"); 
  runApp(const RefaccionariaApp());
}

class RefaccionariaApp extends StatelessWidget {
  const RefaccionariaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Refaccionaria Los Amigos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      home: const RoleSelectionPage(),
    );
  }
}