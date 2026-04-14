import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:convert';

// 1. IMPORTACIONES ABSOLUTAS (A prueba de errores de carpetas)
import 'package:refaccionaria_app/data/services/auth_service.dart'; 
import 'package:refaccionaria_app/ui/widgets/background_effects.dart';
import 'package:refaccionaria_app/ui/screens/login/dashboard/admin_dashboard.dart'; 
import 'package:refaccionaria_app/ui/screens/dashboard/vendedor/vendedor_main_screen.dart'; 

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});
  @override
  State<RoleSelectionPage> createState() => _RoleSelectionPageState();
}

class _RoleSelectionPageState extends State<RoleSelectionPage> with TickerProviderStateMixin {
  String? selectedRole;
  Color activeColor = Colors.indigoAccent;
  bool isSplashing = false;
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _isLoading = false;

  // 2. INSTANCIAMOS EL SERVICIO
  final AuthService _authService = AuthService();

  late AnimationController _mainController;
  List<Particle> roleParticles = [];
  List<Meteor> meteors = [];
  List<MouseParticle> mouseTrail = [];

  @override
  void initState() {
    super.initState();
    _mainController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    meteors = List.generate(15, (index) => Meteor());
  }

  @override
  void dispose() {
    _mainController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onMouseHover(PointerEvent details) {
    setState(() {
      mouseTrail.add(MouseParticle(details.localPosition.dx, details.localPosition.dy, activeColor));
      if (mouseTrail.length > 30) mouseTrail.removeAt(0); 
    });
  }

  void _onRoleTap(String role, Color color) {
    setState(() {
      selectedRole = role;
      activeColor = color;
      isSplashing = true;
      _userController.clear();
      _passController.clear();
      roleParticles = List.generate(50, (index) => Particle(color));
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => isSplashing = false);
    });
  }

  // 3. EL MÉTODO REAL CONECTADO AL SERVICIO
  Future<void> _intentarLogin() async {
    if (selectedRole == null) {
      _mostrarError("Selecciona un rol");
      return;
    }

    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      _mostrarError("Ingresa usuario y contraseña");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(_userController.text, _passController.text);
      
      if (response['exito'] == true && response['user'] != null) {
        final userData = response['user'];
        final String role = (userData['rol'] ?? '').toString().toLowerCase();
        final String userId = userData['id'].toString();

        if (role == "vendedor") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => VendedorMainScreen(userId: userId)),
          );
        } else if (role == "administrador") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ConsultorDashboard()));
        }
      } else {
        _mostrarError("Respuesta de servidor inválida");
      }
    } catch (e) {
      _mostrarError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.redAccent, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      body: MouseRegion(
        onHover: _onMouseHover,
        child: Stack(
          children: [
            if (selectedRole == null || isSplashing)
              AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) => CustomPaint(painter: MeteorPainter(meteors, isSplashing), child: Container()),
              ),
            if (selectedRole != null && !isSplashing)
              AnimatedBuilder(
                animation: _mainController,
                builder: (context, child) => CustomPaint(painter: ParticlePainter(roleParticles), child: Container()),
              ),
            AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) => CustomPaint(painter: MouseTrailPainter(mouseTrail), child: Container()),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    const Icon(Icons.engineering_rounded, size: 70, color: Color(0xFF818CF8)),
                    const Text("LOS AMIGOS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 6)),
                    const SizedBox(height: 70),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildRoleButton("Administrador", Icons.security_rounded, Colors.redAccent),
                        _buildRoleButton("Vendedor", Icons.point_of_sale_rounded, Colors.greenAccent),
                        _buildRoleButton("Consultor", Icons.manage_search_rounded, Colors.blueAccent),
                      ],
                    ),
                    const SizedBox(height: 40),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      child: selectedRole != null && !isSplashing ? _buildGlassForm() : const SizedBox(height: 100),
                    ),
                  ],
                ),
              ),
            ),
            if (isSplashing) _buildSplashOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(String role, IconData icon, Color color) {
    bool isSelected = selectedRole == role;
    return GestureDetector(
      onTap: () => _onRoleTap(role, color),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: isSelected ? color : Colors.white10, width: 2),
              boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 25, spreadRadius: 2)] : [],
            ),
            child: Icon(icon, color: isSelected ? color : Colors.white38, size: 32),
          ),
          const SizedBox(height: 12),
          Text(role, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : Colors.white24)),
        ],
      ),
    );
  }

  Widget _buildGlassForm() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("LOGIN: ${selectedRole!.toUpperCase()}", style: TextStyle(color: activeColor, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => setState(() => selectedRole = null), icon: const Icon(Icons.close_rounded, color: Colors.white24))
                ],
              ),
              const SizedBox(height: 20),
              _buildField(_userController, "Correo", Icons.alternate_email_rounded),
              const SizedBox(height: 15),
              _buildField(_passController, "Password", Icons.lock_outline_rounded, obscure: true),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor, 
                    foregroundColor: Colors.black, 
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))
                  ),
                  onPressed: _isLoading ? null : _intentarLogin, 
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) 
                    : const Text("INICIAR SESIÓN", style: TextStyle(fontWeight: FontWeight.w900)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String hint, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white), 
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: activeColor.withOpacity(0.5)),
        hintText: hint,
        filled: true,
        fillColor: Colors.black26,
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.white.withOpacity(0.05))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: activeColor, width: 2)),
      ),
    );
  }

  Widget _buildSplashOverlay() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      builder: (context, double val, child) {
        return Opacity(
          opacity: (1 - val).clamp(0.0, 1.0),
          child: Container(
            color: activeColor,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.bolt_rounded, size: 120, color: Colors.white),
                  Text(selectedRole!.toUpperCase(), style: const TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: Colors.white)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// --- DASHBOARDS TEMPORALES ---
class VendedorDashboard extends StatelessWidget { const VendedorDashboard({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("VENTAS")), body: const Center(child: Text("Bienvenido Vendedor"))); }
class ConsultorDashboard extends StatelessWidget { const ConsultorDashboard({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("CONSULTOR")), body: const Center(child: Text("Bienvenido Consultor"))); }


