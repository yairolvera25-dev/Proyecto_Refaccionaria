import 'package:flutter/material.dart';
import 'ui/screens/login/login_screen.dart'; // Verifica que la ruta sea esta

void main() => runApp(const RefaccionariaApp());

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