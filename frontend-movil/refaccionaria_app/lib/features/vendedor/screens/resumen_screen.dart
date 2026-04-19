import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:refaccionaria_app/features/vendedor/providers/resumen_provider.dart';
import 'package:refaccionaria_app/features/vendedor/providers/stats_provider.dart';

class ResumenScreen extends StatelessWidget {
  // Recibiremos el ID del logueo, para probar usaré uno vacío o estático por default
  final String userId;

  const ResumenScreen({Key? key, this.userId = 'tu_usuario_id_de_mongo'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyectamos el Provider y ejecutamos la carga inicial (..) en cascada
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ResumenProvider()..cargarDatos(userId)),
        ChangeNotifierProvider(create: (_) => StatsProvider()..fetchWeeklyStats(userId)),
      ],
      child: const _ResumenView(),
    );
  }
}

class _ResumenView extends StatelessWidget {
  const _ResumenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ResumenProvider>();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text(
          'SYS.RESUMEN_PANEL',
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
        // Adorno Neón del Navbar
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
             height: 1.0,
             decoration: BoxDecoration(
               color: Colors.greenAccent.withOpacity(0.5),
               boxShadow: const [BoxShadow(color: Colors.greenAccent, blurRadius: 4)],
             ),
          ),
        ),
      ),
      // Validamos los 3 estados globales
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.greenAccent))
          : provider.errorMessage.isNotEmpty
              ? _buildErrorForm(provider)
              : _buildBody(context, provider),
    );
  }

  // ============== WIDGETS PRIVADOS =================

  Widget _buildBody(BuildContext context, ResumenProvider provider) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildKPIsGrid(provider),
            const SizedBox(height: 24),
            _buildChart(context),
            const SizedBox(height: 32),
            _buildOperacionesRecientesTitle(),
            const SizedBox(height: 16),
            _buildOperacionesList(provider),
          ],
        ),
      ),
    );
  }

  // 1. Gridview de KPIs (2x2)
  // Gridview de KPIs (2x2) más compacto
  Widget _buildKPIsGrid(ResumenProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12, // Espacio entre columnas un poco menor
      mainAxisSpacing: 12,  // Espacio entre filas un poco menor
      childAspectRatio: 3.0, // <--- CAMBIO CLAVE: Más ancho, menos alto
      children: [
        _buildKpiCard(
          title: 'INGRESOS TOTALES', 
          value: '\$${provider.totalIngresos.toStringAsFixed(2)}', 
          subtitle: 'Historial NoSQL',
        ),
        _buildKpiCard(
          title: 'ÓRDENES CERRADAS', 
          value: provider.totalVentasCerradas.toString(), 
          subtitle: '# Documentos',
        ),
        _buildKpiCard(
          title: 'COMISIÓN (5%)', 
          value: '\$${provider.totalComisiones.toStringAsFixed(2)}', 
          subtitle: 'Para Vendedor',
        ),
        _buildKpiCard(
          title: 'STOCK CRÍTICO', 
          value: provider.productosBajoStock.length.toString(), 
          subtitle: 'Alerta SQL',
          isAlert: provider.productosBajoStock.isNotEmpty,
        ),
      ],
    );
  }

  // Molde individual para las tarjetas arriba
  Widget _buildKpiCard({required String title, required String value, required String subtitle, bool isAlert = false}) {
    final colorBase = isAlert ? Colors.orangeAccent : Colors.greenAccent;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorBase.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colorBase.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color: colorBase,
                fontSize: 24,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: colorBase, blurRadius: 8)],
              ),
            ),
          ),
          const Spacer(),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white38,
              fontSize: 9,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  // 2. Gráfica Cyberpunk (fl_chart)
  Widget _buildChart(BuildContext context) {
    final stats = context.watch<StatsProvider>();

    if (stats.isLoading) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: const Center(child: CircularProgressIndicator(color: Colors.greenAccent)),
      );
    }

    if (stats.errorMessage.isNotEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
        ),
        child: Center(
           child: Text('ERR_CHART_SYNC: ${stats.errorMessage}', 
              style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace', fontSize: 10))
        ),
      );
    }

    if (stats.spots.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: const Center(
           child: Text('// NO_DATA //', 
              style: TextStyle(color: Colors.white38, fontFamily: 'monospace'))
        ),
      );
    }

    // Calcular el max Y para que la gráfica no se vea pachoncita contra el tope
    double maxY = 0;
    for (var spot in stats.spots) {
      if (spot.y > maxY) maxY = spot.y;
    }
    // Si no hay ventas en 7 días, un default
    if (maxY == 0) maxY = 100;
    
    // Le damos un "headroom" del 20% al tope superior
    maxY = maxY * 1.2;

    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 24, left: 0, top: 24, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.greenAccent.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ]
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Cuadrículas aburridas OUT
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < stats.dias.length) {
                    return SideTitleWidget(
                      meta: meta,
                      space: 8,
                      child: Text(
                        _getShortDay(stats.dias[index]),
                        style: const TextStyle(
                          color: Colors.white54, 
                          fontFamily: 'monospace', 
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                interval: maxY / 4 > 0 ? maxY / 4 : 1, // Marcas dinámicas
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Ocultamos si es 0 o tope máximo para que no se encimen
                  if (value == 0 || value == maxY) return const SizedBox.shrink();
                  
                  // Abreviamos Ks si es muy alto
                  String text = value.toStringAsFixed(0);
                  if (value >= 1000) {
                     text = '${(value/1000).toStringAsFixed(1)}k';
                  }
                  return SideTitleWidget(
                      meta: meta,
                      space: 4,
                      child: Text(
                        '\$$text',
                        style: TextStyle(
                          color: Colors.greenAccent.withOpacity(0.5), 
                          fontFamily: 'monospace', 
                          fontSize: 9
                        ),
                      ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: stats.spots,
              isCurved: true,
              color: Colors.greenAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.black,
                    strokeWidth: 2,
                    strokeColor: Colors.greenAccent,
                  );
                }
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent.withOpacity(0.3),
                    Colors.greenAccent.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getShortDay(String fechaIso) {
    if (fechaIso.isEmpty) return '';
    try {
      final date = DateTime.parse(fechaIso);
      switch(date.weekday) {
        case 1: return 'Lun';
        case 2: return 'Mar';
        case 3: return 'Mié';
        case 4: return 'Jue';
        case 5: return 'Vie';
        case 6: return 'Sáb';
        case 7: return 'Dom';
      }
    } catch(e) {}
    return '';
  }

  // Título decorativo de lista
  Widget _buildOperacionesRecientesTitle() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'OPERACIONES RECIENTES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        Text(
          '// NOSQL_LOGS',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  // 3. Lista de ventas tipo ListTile
  Widget _buildOperacionesList(ResumenProvider provider) {
    if (provider.ordenes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Text(
            'SIN ÓRDENES REGISTRADAS',
            style: TextStyle(color: Colors.white38, fontFamily: 'monospace'),
          ),
        ),
      );
    }

    // Vue usaba .slice(0, 5) para mostrar solo las más nuevas
    final ordenesMostrar = provider.ordenes.take(5).toList();

    return ListView.builder(
      shrinkWrap: true, // Importante para que no truene con SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), 
      itemCount: ordenesMostrar.length,
      itemBuilder: (context, index) {
        final orden = ordenesMostrar[index];
        final id = orden['_id']?.toString() ?? 'N/A';
        final total = orden['total_venta'] ?? 0;
        final metodo = orden['metodo_pago'] ?? 'EFECTIVO';
        
        // Manejamos la fecha robustamente
        String fechaFormat = 'RECIENTE';
        if (orden['createdAt'] != null) {
          final dt = DateTime.tryParse(orden['createdAt'])?.toLocal();
          if (dt != null) {
            fechaFormat = '${dt.day}/${dt.month}/${dt.year} - ${dt.hour}:${dt.minute.toString().padLeft(2, '0')} hrs';
          }
        }

        return Card(
           color: Colors.black,
           margin: const EdgeInsets.only(bottom: 12),
           shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.05)),
           ),
           child: ListTile(
             contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             leading: Container(
               padding: const EdgeInsets.all(10),
               decoration: BoxDecoration(
                 color: Colors.greenAccent.withOpacity(0.1),
                 borderRadius: BorderRadius.circular(8),
               ),
               child: const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 24),
             ),
             title: Text(
               // Solo los últimos 6 chars del Mongo Hash
               '#${id.length > 6 ? id.substring(id.length - 6).toUpperCase() : id}',
               style: const TextStyle(
                 color: Colors.white,
                 fontFamily: 'monospace',
                 fontWeight: FontWeight.bold,
                 letterSpacing: 1.0
               ),
             ),
             subtitle: Padding(
               padding: const EdgeInsets.only(top: 4.0),
               child: Text(
                 '$metodo | $fechaFormat',
                 style: const TextStyle(
                   color: Colors.white54,
                   fontFamily: 'monospace',
                   fontSize: 10,
                 ),
               ),
             ),
             trailing: Text(
               '\$${total.toStringAsFixed(2)}',
               style: const TextStyle(
                 color: Colors.greenAccent,
                 fontFamily: 'monospace',
                 fontSize: 18,
                 fontWeight: FontWeight.w900,
               ),
             ),
           ),
        );
      },
    );
  }

  // Molde de Error
  Widget _buildErrorForm(ResumenProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 16),
            Text(
              'FATAL_ERROR: ${provider.errorMessage}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.redAccent, fontFamily: 'monospace'),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => provider.cargarDatos('tu_usuario_id_de_mongo'), 
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.redAccent,
                side: const BorderSide(color: Colors.redAccent),
              ),
              child: const Text('RELOAD_SYSTEM()', style: TextStyle(fontFamily: 'monospace')),
            )
          ],
        ),
      ),
    );
  }
}
