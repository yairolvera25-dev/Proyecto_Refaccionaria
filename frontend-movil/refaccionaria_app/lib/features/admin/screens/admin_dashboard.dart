import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:refaccionaria_app/features/admin/widgets/admin_stat_card.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  // --- VARIABLES DE ESTADO ---
  int selectedIndex = 0;
  String searchQuery = "";
  String activeMetric = "VENTAS";
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // --- PALETA DE COLORES PREMIUM ---
  final Color bgDark = const Color(0xFF0B0E14);
  final Color neonBlue = const Color(0xFF00E5FF);
  final Color cardDark = const Color(0xFF161B26);

  // --- BASE DE DATOS LOCAL: REFACCIONES (IMÁGENES DE ALTA CALIDAD DE CAR PARTS) ---
  final List<Map<String, dynamic>> productos = [
    {
      "nombre": "Kit Pistones V8",
      "stock": 15,
      "precio": 8500.0,
      "cat": "Motor",
      "img": "https://images.unsplash.com/photo-1486006920555-c77dcf18193c?w=500&q=80"
    },
    {
      "nombre": "Bujía NGK Iridium",
      "stock": 120,
      "precio": 125.0,
      "cat": "Motor",
      "img": "https://images.unsplash.com/photo-1635773103138-0c67534c038d?w=500&q=80"
    },
    {
      "nombre": "Aceite Sintético 5W30",
      "stock": 45,
      "precio": 950.0,
      "cat": "Aceites",
      "img": "https://images.unsplash.com/photo-1619642751034-765dfdf7c58e?w=500&q=80"
    },
    {
      "nombre": "Batería LTH Pro",
      "stock": 8,
      "precio": 3200.0,
      "cat": "Eléctrico",
      "img": "https://images.unsplash.com/photo-1597762444920-07460f068593?w=500&q=80"
    },
    {
      "nombre": "Balatas Cerámicas",
      "stock": 12,
      "precio": 1450.0,
      "cat": "Frenos",
      "img": "https://images.unsplash.com/photo-1517524008436-bbdb53c248b1?w=500&q=80"
    },
    {
      "nombre": "Alternador Bosch",
      "stock": 3,
      "precio": 4800.0,
      "cat": "Eléctrico",
      "img": "https://images.unsplash.com/photo-1635773103020-08709e99a896?w=500&q=80"
    },
  ];

  // --- BASE DE DATOS LOCAL: CLIENTES / USUARIOS ---
  final List<Map<String, dynamic>> clientes = [
    {"nombre": "Hector Flores", "rol": "Admin UPP", "status": "En línea", "img": "https://randomuser.me/api/portraits/men/1.jpg"},
    {"nombre": "Juan Mecánico", "rol": "Cliente VIP", "status": "Ausente", "img": "https://randomuser.me/api/portraits/men/32.jpg"},
    {"nombre": "Ana García", "rol": "Contadora", "status": "En línea", "img": "https://randomuser.me/api/portraits/women/44.jpg"},
    {"nombre": "Roberto Datsun", "rol": "Proveedor", "status": "Desconectado", "img": "https://randomuser.me/api/portraits/men/50.jpg"},
    {"nombre": "Melissa Johnson", "rol": "Ventas", "status": "En línea", "img": "https://randomuser.me/api/portraits/women/68.jpg"},
  ];

  // --- HISTORIAL DE TRANSACCIONES ---
  final List<Map<String, dynamic>> transacciones = [
    {"id": "INV-1024", "cliente": "Juan Mecánico", "total": 2450.0, "fecha": "Hoy, 14:20", "status": "Completado", "items": ["Bujías", "Aceite"]},
    {"id": "INV-1025", "cliente": "Taller Tizayuca", "total": 12800.0, "fecha": "Hoy, 10:05", "status": "Completado", "items": ["Kit Pistones"]},
    {"id": "INV-1026", "cliente": "Roberto D.", "total": 450.0, "fecha": "Ayer", "status": "Pendiente", "items": ["Filtro aire"]},
  ];

  final Map<String, List<FlSpot>> dataSets = {
    "VENTAS": [const FlSpot(0, 3), const FlSpot(1, 5), const FlSpot(2, 4), const FlSpot(3, 7), const FlSpot(4, 6), const FlSpot(5, 8)],
    "ÓRDENES": [const FlSpot(0, 2), const FlSpot(1, 3.5), const FlSpot(2, 2.5), const FlSpot(3, 5), const FlSpot(4, 4), const FlSpot(5, 6)],
    "EGRESOS": [const FlSpot(0, 5), const FlSpot(1, 3), const FlSpot(2, 6), const FlSpot(3, 2), const FlSpot(4, 4.5), const FlSpot(5, 3)],
  };

  // --- LÓGICA DE FOTO DE PERFIL ---
  Future<void> _cambiarFotoPerfil() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _imageFile = File(image.path));
  }

  void _mostrarPerfil() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: cardDark, 
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          border: Border(top: BorderSide(color: neonBlue.withOpacity(0.5), width: 2))
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _cambiarFotoPerfil,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 65, 
                    backgroundColor: neonBlue.withOpacity(0.1),
                    backgroundImage: _imageFile != null 
                      ? FileImage(_imageFile!) as ImageProvider 
                      : const NetworkImage("https://randomuser.me/api/portraits/lego/1.jpg")
                  ),
                  CircleAvatar(radius: 20, backgroundColor: neonBlue, child: const Icon(Icons.camera_alt, size: 20, color: Colors.black)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            const Text("Ismael TIID", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            const Text("Administrador General - UPP", style: TextStyle(color: Colors.white54, fontSize: 14)),
            const SizedBox(height: 40),
            _buildActionTile(Icons.settings_outlined, "Configuración del Perfil"),
            _buildActionTile(Icons.history_rounded, "Mi Historial de Actividad"),
            const Divider(color: Colors.white10, height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.1), 
                foregroundColor: Colors.redAccent, 
                side: const BorderSide(color: Colors.redAccent), 
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))
              ),
              icon: const Icon(Icons.logout_rounded),
              label: const Text("CERRAR SESIÓN", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: neonBlue, size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 14),
      onTap: () {},
    );
  }

  // --- LÓGICA DE AGREGAR PRODUCTO (BOTÓN +) ---
  void _agregarRegistro() {
    TextEditingController nombreCtrl = TextEditingController();
    TextEditingController stockCtrl = TextEditingController();
    TextEditingController precioCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), 
          side: BorderSide(color: neonBlue.withOpacity(0.4))
        ),
        title: Text("NUEVA REFACCIÓN", style: TextStyle(color: neonBlue, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField(nombreCtrl, "Nombre de la pieza", Icons.inventory_2_outlined),
            const SizedBox(height: 15),
            _buildDialogField(stockCtrl, "Stock Inicial", Icons.numbers_rounded, isNum: true),
            const SizedBox(height: 15),
            _buildDialogField(precioCtrl, "Precio Venta (\$)", Icons.attach_money_rounded, isNum: true),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCELAR", style: TextStyle(color: Colors.white38))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: neonBlue, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              if (nombreCtrl.text.isNotEmpty) {
                setState(() => productos.add({
                  "nombre": nombreCtrl.text,
                  "stock": int.parse(stockCtrl.text),
                  "precio": double.parse(precioCtrl.text),
                  "cat": "Nuevo",
                  "img": "https://images.unsplash.com/photo-1486006920555-c77dcf18193c?w=500"
                }));
                Navigator.pop(context);
              }
            },
            child: const Text("GUARDAR PRODUCTO", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildDialogField(TextEditingController ctrl, String label, IconData icon, {bool isNum = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: isNum ? TextInputType.number : TextInputType.text,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: Icon(icon, color: neonBlue, size: 20),
        enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: neonBlue)),
      ),
    );
  }

// --- CATEGORÍAS ESPECIALES: NAVEGACIÓN Y GRID RESPONSIVO ---
  void _irACategoria(String cat) {
    // 1. Filtramos los productos por la categoría seleccionada
    final filtrados = productos.where((p) => p['cat'] == cat).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: bgDark,
          appBar: AppBar(
            backgroundColor: cardDark, 
            iconTheme: IconThemeData(color: neonBlue),
            elevation: 0,
            title: Text(
              "Catálogo: $cat", 
              style: TextStyle(color: neonBlue, fontWeight: FontWeight.bold, letterSpacing: 1.2)
            ),
          ),
          // 🔥 USO DE LAYOUTBUILDER PARA RESPONSIVIDAD (Corrección #3)
          body: filtrados.isEmpty 
          ? const Center(child: Text("Sin stock en esta categoría", style: TextStyle(color: Colors.white38)))
          : LayoutBuilder(
              builder: (context, constraints) {
                // Lógica de Columnas Dinámicas (Breakpoints):
                // Si el ancho es mayor a 900px (Escritorio) -> 4 columnas
                // Si el ancho es mayor a 600px (Tablet) -> 3 columnas
                // Si es menor (Celular) -> 2 columnas
                int cols = constraints.maxWidth > 900 ? 4 : (constraints.maxWidth > 600 ? 3 : 2);

                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,       // Aplicamos la responsividad aquí
                    childAspectRatio: 0.72,     // Proporción para que la imagen y texto quepan bien
                    crossAxisSpacing: 18,       // Espaciado horizontal
                    mainAxisSpacing: 18,        // Espaciado vertical
                  ),
                  itemCount: filtrados.length,
                  itemBuilder: (context, i) => _buildProductGridCard(filtrados[i]),
                );
              },
            ),
        ),
      ),
    );
  }

  Widget _buildProductGridCard(Map<String, dynamic> p) {
    return Container(
      decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Image.network(p['img'], fit: BoxFit.cover, width: double.infinity,
                loadingBuilder: (context, child, progress) => progress == null ? child : const Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.white10, child: const Icon(Icons.broken_image, color: Colors.white10)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['nombre'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 6),
                Text("\$${p['precio']}", style: TextStyle(color: neonBlue, fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- DETALLE DE TICKET INTERACTIVO (GLASSMORPHISM) ---
  void _verTicket(Map<String, dynamic> tx) {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: AlertDialog(
          backgroundColor: cardDark.withOpacity(0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35), 
            side: BorderSide(color: neonBlue.withOpacity(0.3))
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: neonBlue.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.receipt_long_rounded, color: neonBlue, size: 45)),
              const SizedBox(height: 20),
              Text(tx['id'], style: const TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              Text(tx['cliente'], style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
              const Divider(color: Colors.white12, height: 40),
              ...List.generate(tx['items'].length, (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6), 
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(tx['items'][i], style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  const Text("x1", style: TextStyle(color: Colors.white24, fontSize: 14))
                ])
              )),
              const Divider(color: Colors.white12, height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text("TOTAL PAGADO", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                Text("\$${tx['total']}", style: TextStyle(color: neonBlue, fontSize: 24, fontWeight: FontWeight.w900))
              ]),
              const SizedBox(height: 35),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: neonBlue, foregroundColor: Colors.black, minimumSize: const Size(double.infinity, 55), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), 
                onPressed: () => Navigator.pop(context), 
                child: const Text("CERRAR COMPROBANTE", style: TextStyle(fontWeight: FontWeight.bold))
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- CONSTRUCCIÓN DEL SCAFFOLD PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDark,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _contenido(constraints),
          );
        }),
      ),
      // 🔥 BOTÓN RESTAURADO CON BRILLO NEÓN 🔥
      floatingActionButton: selectedIndex == 1 
        ? Container(
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: neonBlue.withOpacity(0.4), blurRadius: 20, spreadRadius: 2)]),
            child: FloatingActionButton(
              backgroundColor: neonBlue, 
              elevation: 0, 
              onPressed: _agregarRegistro, 
              child: const Icon(Icons.add_rounded, color: Colors.black, size: 32)
            ),
          )
        : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(border: Border(top: BorderSide(color: neonBlue.withOpacity(0.1), width: 1))),
        child: BottomNavigationBar(
          backgroundColor: const Color(0xFF0F172A),
          currentIndex: selectedIndex,
          selectedItemColor: neonBlue,
          unselectedItemColor: Colors.white24,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: (v) => setState(() { selectedIndex = v; searchQuery = ""; }),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), activeIcon: Icon(Icons.dashboard_rounded), label: "Inicio"),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), activeIcon: Icon(Icons.inventory_2_rounded), label: "Stock"),
            BottomNavigationBarItem(icon: Icon(Icons.people_alt_rounded), activeIcon: Icon(Icons.people_alt_rounded), label: "Usuarios"),
          ],
        ),
      ),
    );
  }

  Widget _contenido(BoxConstraints constraints) {
    switch (selectedIndex) {
      case 0: return _vistaResumen(); 
      case 1: return _crudProductos(); 
      case 2: return _vistaClientes(); 
      default: return const Center(child: CircularProgressIndicator());
    }
  }

  // --- VISTA 1: DASHBOARD DINÁMICO ---
  Widget _vistaResumen() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("ENGINE CORE v1.0", style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w900)),
              SizedBox(height: 6),
              Text("Panel Los Amigos", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            ]),
            GestureDetector(
              onTap: _mostrarPerfil,
              child: Hero(tag: 'profile', child: Container(
                padding: const EdgeInsets.all(2.5), 
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: neonBlue, width: 2)), 
                child: CircleAvatar(radius: 22, backgroundColor: cardDark, backgroundImage: _imageFile != null ? FileImage(_imageFile!) : const NetworkImage("https://randomuser.me/api/portraits/lego/1.jpg") as ImageProvider)
              )),
            )
          ],
        ),
        const SizedBox(height: 35),
        
        // Tarjetas Estadísticas Responsivas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              AdminStatCard(title: "VENTAS", amount: "\$124k", percentage: "15%", isSelected: activeMetric == "VENTAS", onTap: () => setState(() => activeMetric = "VENTAS")),
              AdminStatCard(title: "ÓRDENES", amount: "1,240", percentage: "8%", isSelected: activeMetric == "ÓRDENES", onTap: () => setState(() => activeMetric = "ÓRDENES")),
              AdminStatCard(title: "EGRESOS", amount: "\$12k", percentage: "5%", isPositive: false, isSelected: activeMetric == "EGRESOS", onTap: () => setState(() => activeMetric = "EGRESOS")),
            ],
          ),
        ),
        
        const SizedBox(height: 35),
        
        // Gráfica de Rendimiento Pro
        Container(
          height: 300,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withOpacity(0.05))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text("Desempeño Semanal: $activeMetric", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Icon(Icons.query_stats_rounded, color: neonBlue, size: 20),
              ]),
              const SizedBox(height: 25),
              Expanded(
                child: LineChart(
                  LineChartData(
                    lineTouchData: LineTouchData(touchTooltipData: LineTouchTooltipData(getTooltipColor: (spot) => neonBlue)),
                    gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (v) => FlLine(color: Colors.white.withOpacity(0.05))),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: (v, m) => Padding(padding: const EdgeInsets.only(top: 12), child: Text(["Lun", "Mar", "Mie", "Jue", "Vie", "Sab"][v.toInt()], style: const TextStyle(color: Colors.white24, fontSize: 10, fontWeight: FontWeight.bold))))),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: dataSets[activeMetric]!,
                        isCurved: true, color: neonBlue, barWidth: 4, dotData: const FlDotData(show: true),
                        belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [neonBlue.withOpacity(0.25), neonBlue.withOpacity(0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        const Text("CATEGORÍAS ESPECIALES", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 2)),
        const SizedBox(height: 20),
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildCategoryBtn(Icons.settings_suggest_rounded, "Motor"),
              _buildCategoryBtn(Icons.bolt_rounded, "Eléctrico"),
              _buildCategoryBtn(Icons.disc_full_rounded, "Frenos"),
              _buildCategoryBtn(Icons.oil_barrel_rounded, "Aceites"),
            ],
          ),
        ),

        const SizedBox(height: 40),
        const Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("VENTAS RECIENTES", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 2)),
          Text("TODAS", style: TextStyle(color: Color(0xFF00E5FF), fontSize: 11, fontWeight: FontWeight.w900)),
        ]),
        const SizedBox(height: 20),
        ...transacciones.map((tx) => _buildTxCard(tx)).toList(),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCategoryBtn(IconData icon, String label) {
    return GestureDetector(
      onTap: () => _irACategoria(label),
      child: Container(
        width: 95, margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white.withOpacity(0.05)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))]),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, color: neonBlue, size: 32),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w900)),
        ]),
      ),
    );
  }

  Widget _buildTxCard(Map<String, dynamic> tx) {
    return GestureDetector(
      onTap: () => _verTicket(tx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white.withOpacity(0.03))),
        child: Row(children: [
          CircleAvatar(backgroundColor: neonBlue.withOpacity(0.1), child: Icon(Icons.shopping_bag_outlined, color: neonBlue, size: 20)),
          const SizedBox(width: 18),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(tx['cliente'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            Text("${tx['id']} • ${tx['fecha']}", style: const TextStyle(color: Colors.white24, fontSize: 11)),
          ])),
          Text("+\$${tx['total']}", style: TextStyle(color: neonBlue, fontWeight: FontWeight.w900, fontSize: 17)),
        ]),
      ),
    );
  }

  // --- VISTA 2: INVENTARIO GLOBAL ---
  Widget _crudProductos() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Align(alignment: Alignment.centerLeft, child: Text("STOCK GLOBAL", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2))),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(18), border: Border.all(color: neonBlue.withOpacity(0.2))),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (v) => setState(() => searchQuery = v),
            decoration: InputDecoration(hintText: "Buscar refacción por nombre...", border: InputBorder.none, hintStyle: const TextStyle(color: Colors.white24, fontSize: 14), icon: Icon(Icons.search_rounded, color: neonBlue)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 25),
            itemCount: productos.length,
            itemBuilder: (context, i) {
              final p = productos[i];
              if (searchQuery.isNotEmpty && !p['nombre'].toLowerCase().contains(searchQuery.toLowerCase())) return const SizedBox();
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(22), border: Border.all(color: (p['stock'] < 10) ? Colors.redAccent.withOpacity(0.25) : Colors.white.withOpacity(0.05))),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  leading: ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(p['img'], width: 55, height: 55, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image, color: Colors.white10))),
                  title: Text(p["nombre"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  subtitle: Text("Stock: ${p["stock"]} • Categoría: ${p['cat']}", style: TextStyle(color: (p['stock'] < 10) ? Colors.redAccent : Colors.white38, fontSize: 12)),
                  trailing: Text("\$${p["precio"]}", style: TextStyle(color: neonBlue, fontWeight: FontWeight.w900, fontSize: 18)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- VISTA 3: DIRECTORIO DE USUARIOS ---
  Widget _vistaClientes() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Align(alignment: Alignment.centerLeft, child: Text("DIRECTORIO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2))),
        const SizedBox(height: 25),
        Expanded(
          child: ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, i) {
              final c = clientes[i];
              bool isOnline = c['status'] == "En línea";
              return Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(color: cardDark, borderRadius: BorderRadius.circular(25), border: Border.all(color: Colors.white.withOpacity(0.05)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 4))]),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(18),
                  leading: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(radius: 30, backgroundColor: neonBlue.withOpacity(0.15), backgroundImage: NetworkImage(c['img'])),
                      Container(width: 15, height: 15, decoration: BoxDecoration(color: isOnline ? Colors.greenAccent : Colors.white10, shape: BoxShape.circle, border: Border.all(color: cardDark, width: 2.5))),
                    ],
                  ),
                  title: Text(c["nombre"], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text("${c["rol"]} • ${c['status']}", style: TextStyle(color: isOnline ? Colors.white54 : Colors.white24, fontSize: 13)),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: neonBlue.withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.chat_bubble_rounded, color: neonBlue, size: 20),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}