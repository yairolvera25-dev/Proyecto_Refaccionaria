import 'package:flutter/material.dart';
import 'package:refaccionaria_app/core/constants.dart';
import 'package:refaccionaria_app/data/services/stock_service.dart';
import 'package:refaccionaria_app/models/venta_model.dart';
import 'package:refaccionaria_app/ui/widgets/stat_card.dart';
import 'package:refaccionaria_app/data/services/report_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultorDashboard extends StatefulWidget {
  const ConsultorDashboard({super.key});

  @override
  State<ConsultorDashboard> createState() => _ConsultorDashboardState();
}

class _ConsultorDashboardState extends State<ConsultorDashboard>
    with TickerProviderStateMixin {
  List<VentaItem> _items = [];
  List<VentaItem> _filtered = [];
  Map<String, dynamic> _stats = {};
  bool _loading = true;
  String _searchQuery = '';
  String _filterEstado = 'todos';
  int _notifCount = 0;
  late AnimationController _pulse;
  late AnimationController _chartAnim;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _chartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fetchData();
  }

  @override
  void dispose() {
    _pulse.dispose();
    _chartAnim.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() => _loading = true);
    try {
      final items = await StockService.fetchVentas();
      setState(() {
        _items = items;
        _stats = StockService.calcStats(items);
        _notifCount = (_stats['criticos'] ?? 0) + (_stats['pendientes'] ?? 0);
        _loading = false;
      });
      _applyFilters();
      _chartAnim.forward(from: 0);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filtered = _items.where((i) {
        final matchQuery =
            i.producto.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                i.sku.toLowerCase().contains(_searchQuery.toLowerCase());
        final matchEstado =
            _filterEstado == 'todos' || i.estado == _filterEstado;
        return matchQuery && matchEstado;
      }).toList();
    });
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.neon,
          backgroundColor: AppColors.surface,
          onRefresh: _fetchData,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildStats()),
              SliverToBoxAdapter(child: _buildChart()),
              SliverToBoxAdapter(child: _buildSearchAndFilter()),
              if (_loading)
                const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.neon),
                  ),
                )
              else if (_filtered.isEmpty)
                SliverFillRemaining(child: _buildEmptyState())
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _buildItemCard(_filtered[i]),
                      childCount: _filtered.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.neon,
                    shape: BoxShape.circle,
                  ),
                ),
                const Text('REFACCIONARIA',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 9,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 3),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.neon, Color(0xFF00BFFF)],
              ).createShader(bounds),
              child: const Text('LOS AMIGOS CORE',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: -0.5)),
            ),
          ],
        ),
        const Spacer(),
        AnimatedBuilder(
          animation: _pulse,
          builder: (_, __) => Container(
            width: 7, height: 7,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.neon.withOpacity(0.3 + 0.7 * _pulse.value),
            ),
          ),
        ),
        _iconBtn(Icons.refresh_rounded, _fetchData),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _iconBtn(Icons.notifications_none_rounded, _showNotificaciones),
            if (_notifCount > 0)
              Positioned(
                top: -4, right: -4,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(
                      color: Colors.redAccent, shape: BoxShape.circle),
                  child: Center(
                    child: Text('$_notifCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 8),
        // ← BOTÓN SALIR
        GestureDetector(
          onTap: _confirmSalir,
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: const Icon(Icons.logout_rounded,
                color: Colors.redAccent, size: 17),
          ),
        ),
      ],
    ),
  );
}

void _confirmSalir() {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color(0xFF1A1D24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout_rounded,
                  color: Colors.redAccent, size: 28),
            ),
            const SizedBox(height: 14),
            const Text('¿Cerrar sesión?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Serás redirigido al login.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withOpacity(0.1), width: 0.5),
                      ),
                      child: const Center(
                        child: Text('CANCELAR',
                            style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(context);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login', (_) => false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.redAccent.withOpacity(0.4),
                            width: 0.5),
                      ),
                      child: const Center(
                        child: Text('SALIR',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

  void _showNotificaciones() {
    final criticos =
        _items.where((i) => i.estado == 'critico').toList();
    final pendientes =
        _items.where((i) => i.estado == 'pendiente').toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.85,
        builder: (_, ctrl) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded,
                      color: AppColors.neon, size: 18),
                  const SizedBox(width: 8),
                  const Text('ALERTAS DE INVENTARIO',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${criticos.length + pendientes.length} alertas',
                      style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  if (criticos.isNotEmpty) ...[
                    _notifSection('SIN STOCK — URGENTE', Colors.redAccent),
                    ...criticos.map((i) => _notifTile(i, Colors.redAccent,
                        Icons.warning_rounded, 'Stock en 0 unidades')),
                  ],
                  if (pendientes.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _notifSection('STOCK BAJO', Colors.orangeAccent),
                    ...pendientes.map((i) => _notifTile(
                        i,
                        Colors.orangeAccent,
                        Icons.hourglass_bottom_rounded,
                        '${i.cantidad} unidad(es) restante(s)')),
                  ],
                  if (criticos.isEmpty && pendientes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('✅  Todo en orden, sin alertas',
                            style: TextStyle(
                                color: AppColors.textMuted, fontSize: 13)),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notifSection(String label, Color color) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(label,
            style: TextStyle(
                color: color,
                fontSize: 8,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5)),
      );

  Widget _notifTile(
          VentaItem item, Color color, IconData icon, String subtitle) =>
      Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2), width: 0.5),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(subtitle,
                      style: TextStyle(color: color, fontSize: 9)),
                ],
              ),
            ),
            Text(item.sku,
                style: const TextStyle(
                    color: AppColors.textHint, fontSize: 8)),
          ],
        ),
      );

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Icon(icon, color: AppColors.neon, size: 17),
        ),
      );

  // ─── STATS ────────────────────────────────────────────────────────────────

  Widget _buildStats() {
    final ingresos = (_stats['ingresos'] ?? 0.0) as double;
    final ordenes = _stats['ordenes'] ?? 0;
    final criticos = _stats['criticos'] ?? 0;
    final pendientes = _stats['pendientes'] ?? 0;

    return SizedBox(
      height: 112,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20, top: 6, bottom: 6),
        children: [
          StatCard(
            label: 'INGRESOS',
            value: '\$${ingresos.toStringAsFixed(0)}',
            subtitle: 'total acumulado',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.neon,
            onTap: () => _showStatDetail('Ingresos totales',
                '\$${ingresos.toStringAsFixed(2)}',
                'Suma de todas las ventas registradas.',
                AppColors.neon, Icons.account_balance_wallet_rounded),
          ),
          StatCard(
            label: 'ÓRDENES',
            value: '$ordenes',
            subtitle: 'en sistema',
            icon: Icons.receipt_long_rounded,
            color: Colors.blueAccent,
            onTap: () => _showStatDetail('Total órdenes', '$ordenes registros',
                'Productos y ventas en la base de datos.',
                Colors.blueAccent, Icons.receipt_long_rounded),
          ),
          StatCard(
            label: 'CRÍTICO',
            value: '$criticos',
            subtitle: criticos > 0 ? '¡reabastecer!' : 'sin alertas',
            icon: Icons.warning_amber_rounded,
            color: criticos > 0 ? Colors.redAccent : Colors.green,
            onTap: () => _showStatDetail('Productos críticos',
                '$criticos sin stock',
                'Piezas en 0 unidades. Reabastecimiento urgente.',
                Colors.redAccent, Icons.warning_amber_rounded),
          ),
          StatCard(
            label: 'PENDIENTE',
            value: '$pendientes',
            subtitle: 'stock bajo',
            icon: Icons.hourglass_bottom_rounded,
            color: Colors.orangeAccent,
            onTap: () => _showStatDetail('Stock bajo', '$pendientes piezas',
                'Productos con 1–2 unidades restantes.',
                Colors.orangeAccent, Icons.hourglass_bottom_rounded),
          ),
        ],
      ),
    );
  }

  void _showStatDetail(String title, String value, String desc, Color color,
      IconData icon) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 14),
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1)),
              const SizedBox(height: 10),
              Text(desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                      height: 1.5)),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: color.withOpacity(0.3), width: 0.5),
                  ),
                  child: Text('CERRAR',
                      style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── CHART VERTICAL CON ANIMACIÓN ─────────────────────────────────────────

  Widget _buildChart() {
    final top = List<VentaItem>.from(_items)
      ..sort((a, b) => b.cantidad.compareTo(a.cantidad));
    final top7 = top.take(7).toList();
    final maxQ =
        top7.isEmpty ? 1 : top7.first.cantidad.clamp(1, 9999);

    final barColors = [
      AppColors.neon,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.purpleAccent,
      Colors.cyanAccent,
      Colors.pinkAccent,
      Colors.tealAccent,
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('TOP STOCK',
                  style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 9,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.neon.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('${top7.length} productos',
                    style: const TextStyle(
                        color: AppColors.neon,
                        fontSize: 8,
                        fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              const Icon(Icons.bar_chart_rounded,
                  color: AppColors.neon, size: 14),
            ],
          ),
          const SizedBox(height: 14),
          if (top7.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Sin datos',
                    style: TextStyle(
                        color: AppColors.textHint, fontSize: 11)),
              ),
            )
          else
            SizedBox(
              height: 120,
              child: AnimatedBuilder(
                animation: _chartAnim,
                builder: (_, __) => Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: top7.asMap().entries.map((e) {
                    final pct = e.value.cantidad / maxQ;
                    final animatedPct = pct * _chartAnim.value;
                    final color = barColors[e.key % barColors.length];
                    return Expanded(
                      child: _VerticalBar(
                        pct: animatedPct,
                        rawPct: pct,
                        color: color,
                        value: e.value.cantidad,
                        label: e.value.producto,
                        onTap: () => _showItemDetail(e.value),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          // Eje X — mini labels
          if (top7.isNotEmpty) ...[
            const SizedBox(height: 6),
            Row(
              children: top7.asMap().entries.map((e) {
                final color = barColors[e.key % barColors.length];
                return Expanded(
                  child: Center(
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── SEARCH + FILTER ──────────────────────────────────────────────────────

  Widget _buildSearchAndFilter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
      child: Column(
        children: [
          TextField(
            onChanged: (v) {
              _searchQuery = v;
              _applyFilters();
            },
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Rastrear SKU o pieza...',
              hintStyle: const TextStyle(
                  color: AppColors.textHint, fontSize: 12),
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.neon, size: 17),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: Colors.white.withOpacity(0.05), width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide:
                    const BorderSide(color: AppColors.neon, width: 1),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              {'key': 'todos', 'label': 'TODOS', 'color': AppColors.neon},
              {'key': 'vendido', 'label': 'OK ✓', 'color': Colors.blueAccent},
              {
                'key': 'pendiente',
                'label': 'BAJO ⚡',
                'color': Colors.orangeAccent
              },
              {
                'key': 'critico',
                'label': 'CRÍTICO ⚠',
                'color': Colors.redAccent
              },
            ].map((item) {
              final key = item['key'] as String;
              final label = item['label'] as String;
              final color = item['color'] as Color;
              final isActive = _filterEstado == key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _filterEstado = key;
                    _applyFilters();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isActive
                          ? color.withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isActive
                            ? color
                            : Colors.white.withOpacity(0.07),
                        width: isActive ? 1 : 0.5,
                      ),
                    ),
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isActive ? color : AppColors.textMuted,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── ITEM CARD ────────────────────────────────────────────────────────────

  Widget _buildItemCard(VentaItem item) {
    final cfg = _estadoConfig(item.estado);
    return GestureDetector(
      onTap: () => _showItemDetail(item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.estado == 'critico'
                ? Colors.redAccent.withOpacity(0.25)
                : Colors.white.withOpacity(0.04),
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: cfg.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(cfg.icon, color: cfg.color, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.producto.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.3),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(item.sku,
                          style: const TextStyle(
                              color: AppColors.textHint, fontSize: 9)),
                      if (item.precio > 0) ...[
                        const SizedBox(width: 8),
                        Text(
                          '\$${item.precio.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: AppColors.textMuted, fontSize: 9),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${item.cantidad}',
                  style: TextStyle(
                    color: item.cantidad == 0
                        ? Colors.redAccent
                        : item.cantidad <= 2
                            ? Colors.orangeAccent
                            : AppColors.neon,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: cfg.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cfg.label,
                    style: TextStyle(
                        color: cfg.color,
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ({Color color, IconData icon, String label}) _estadoConfig(
          String estado) =>
      switch (estado) {
        'vendido' => (
            color: Colors.blueAccent,
            icon: Icons.check_circle_rounded,
            label: 'VENDIDO'
          ),
        'pendiente' => (
            color: Colors.orangeAccent,
            icon: Icons.hourglass_bottom_rounded,
            label: 'BAJO'
          ),
        'critico' => (
            color: Colors.redAccent,
            icon: Icons.warning_rounded,
            label: 'CRÍTICO'
          ),
        _ =>
          (color: AppColors.neon, icon: Icons.circle, label: ''),
      };

  // ─── EMPTY STATE ──────────────────────────────────────────────────────────

  Widget _buildEmptyState() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                color: AppColors.textHint, size: 44),
            const SizedBox(height: 10),
            const Text('Sin resultados',
                style:
                    TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const SizedBox(height: 4),
            const Text('Intenta con otro SKU o filtro',
                style:
                    TextStyle(color: AppColors.textHint, fontSize: 10)),
          ],
        ),
      );

  // ─── DETAIL ───────────────────────────────────────────────────────────────

  void _showItemDetail(VentaItem item) {
    final cfg = _estadoConfig(item.estado);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: cfg.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(cfg.icon, color: cfg.color, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.producto.toUpperCase(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(item.sku,
                          style: const TextStyle(
                              color: AppColors.neon, fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _detailRow('Stock actual', '${item.cantidad} unidades',
                      item.cantidad == 0
                          ? Colors.redAccent
                          : item.cantidad <= 2
                              ? Colors.orangeAccent
                              : AppColors.neon),
                  _divider(),
                  _detailRow('Precio unitario',
                      '\$${item.precio.toStringAsFixed(2)}', Colors.white),
                  _divider(),
                  _detailRow('Total venta',
                      '\$${item.totalVenta.toStringAsFixed(2)}',
                      AppColors.neon),
                  _divider(),
                  _detailRow('Estado', item.estado.toUpperCase(), cfg.color),
                  _divider(),
                  _detailRow(
                      'Fecha',
                      '${item.fecha.day}/${item.fecha.month}/${item.fecha.year}',
                      AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _divider() => Divider(
      height: 1, color: Colors.white.withOpacity(0.05), thickness: 0.5);

  Widget _detailRow(String label, String value, Color valueColor) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 12)),
            Text(value,
                style: TextStyle(
                    color: valueColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  // ─── FAB ──────────────────────────────────────────────────────────────────

 Widget _buildFAB() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Botón Excel
        FloatingActionButton.small(
          heroTag: 'excel',
          backgroundColor: const Color(0xFF1A1D24),
          foregroundColor: Colors.green,
          onPressed: () => _showReportDialog(),
          child: const Icon(Icons.table_chart_rounded, size: 18),
        ),
        const SizedBox(height: 10),
        // Botón principal
        FloatingActionButton.extended(
          heroTag: 'sync',
          backgroundColor: AppColors.neon,
          foregroundColor: Colors.black,
          onPressed: _fetchData,
          icon: const Icon(Icons.sync_rounded, size: 18),
          label: const Text('ACTUALIZAR',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5)),
        ),
      ],
    );
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: const Color(0xFF1A1D24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.assessment_rounded,
                  color: AppColors.neon, size: 36),
              const SizedBox(height: 12),
              const Text('GENERAR REPORTE',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
              const SizedBox(height: 6),
              const Text('Elige el formato de exportación',
                  style:
                      TextStyle(color: AppColors.textMuted, fontSize: 11)),
              const SizedBox(height: 20),
              // PDF
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ReportService.generarPDF(context, _items);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.redAccent.withOpacity(0.3), width: 0.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf_rounded,
                          color: Colors.redAccent, size: 20),
                      SizedBox(width: 10),
                      Text('Exportar PDF',
                          style: TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Excel
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ReportService.generarExcel(context, _items);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.green.withOpacity(0.3), width: 0.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.table_chart_rounded,
                          color: Colors.green, size: 20),
                      SizedBox(width: 10),
                      Text('Exportar Excel',
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Text('CANCELAR',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} // <--- ESTA LLAVE CIERRA TU PANTALLA PRINCIPAL. ¡NO LA BORRES!

// ─── VERTICAL BAR con hover tooltip y efecto 3D ───────────────────────────────

class _VerticalBar extends StatefulWidget {
  final double pct;
  final double rawPct;
  final Color color;
  final int value;
  final String label;
  final VoidCallback onTap;

  const _VerticalBar({
    required this.pct,
    required this.rawPct,
    required this.color,
    required this.value,
    required this.label,
    required this.onTap,
  });

  @override
  State<_VerticalBar> createState() => _VerticalBarState();
}

class _VerticalBarState extends State<_VerticalBar> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final barH = (90 * widget.pct).clamp(4.0, 90.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Tooltip al hover
              AnimatedOpacity(
                duration: const Duration(milliseconds: 150),
                opacity: _hovered ? 1 : 0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                        color: widget.color.withOpacity(0.4), width: 0.5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${widget.value}',
                        style: TextStyle(
                            color: widget.color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.label.length > 10
                            ? '${widget.label.substring(0, 10)}…'
                            : widget.label,
                        style: const TextStyle(
                            color: AppColors.textHint, fontSize: 7),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              if (!_hovered)
                Text(
                  '${widget.value}',
                  style: TextStyle(
                      color: widget.color.withOpacity(0.7),
                      fontSize: 8,
                      fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 3),
              // Barra principal con sombra lateral (efecto 3D)
              Stack(
                children: [
                  // Sombra derecha (profundidad)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 5,
                      height: barH,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.25),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                  // Barra principal
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: barH,
                    decoration: BoxDecoration(
                      color: _hovered
                          ? widget.color
                          : widget.color.withOpacity(0.75),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      boxShadow: _hovered
                          ? [
                              BoxShadow(
                                color: widget.color.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 0,
                              )
                            ]
                          : [],
                    ),
                    // Brillo superior (efecto 3D)
                    child: Column(
                      children: [
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}