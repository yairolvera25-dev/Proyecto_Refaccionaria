import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/providers/vendedor/resumen_provider.dart';
import '../../../../core/providers/vendedor/stats_provider.dart';

class ResumenScreen extends StatelessWidget {
  final String userId;

  const ResumenScreen({
    Key? key,
    this.userId = 'tu_usuario_id_de_mongo',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ResumenProvider()..cargarDatos(userId),
        ),
        ChangeNotifierProvider(
          create: (_) => StatsProvider()..fetchWeeklyStats(userId),
        ),
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
            letterSpacing: 2,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.5),
              boxShadow: const [
                BoxShadow(
                  color: Colors.greenAccent,
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.greenAccent,
              ),
            )
          : provider.errorMessage.isNotEmpty
              ? _buildErrorForm(provider)
              : _buildBody(context, provider),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ResumenProvider provider,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
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

  Widget _buildKPIsGrid(ResumenProvider provider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 3,
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

  Widget _buildKpiCard({
    required String title,
    required String value,
    required String subtitle,
    bool isAlert = false,
  }) {
    final colorBase =
        isAlert ? Colors.orangeAccent : Colors.greenAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorBase.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorBase.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 9,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value,
              style: TextStyle(
                color: colorBase,
                fontSize: 24,
                fontWeight: FontWeight.bold,
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

  Widget _buildChart(BuildContext context) {
    final stats = context.watch<StatsProvider>();

    if (stats.isLoading) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.greenAccent,
          ),
        ),
      );
    }

    if (stats.errorMessage.isNotEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            'ERR_CHART_SYNC: ${stats.errorMessage}',
            style: const TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ),
      );
    }

    if (stats.spots.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text(
            '// NO_DATA //',
            style: TextStyle(color: Colors.white38),
          ),
        ),
      );
    }

    double maxY = 0;
    for (var spot in stats.spots) {
      if (spot.y > maxY) maxY = spot.y;
    }

    if (maxY == 0) maxY = 100;
    maxY *= 1.2;

    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),

          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),

            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();

                  if (index >= 0 &&
                      index < stats.dias.length) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        _getShortDay(stats.dias[index]),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
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
                interval: maxY / 4,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 9,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          lineBarsData: [
            LineChartBarData(
              spots: stats.spots,
              isCurved: true,
              color: Colors.greenAccent,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.greenAccent.withOpacity(0.3),
                    Colors.transparent,
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
    try {
      final date = DateTime.parse(fechaIso);

      switch (date.weekday) {
        case 1:
          return 'Lun';
        case 2:
          return 'Mar';
        case 3:
          return 'Mié';
        case 4:
          return 'Jue';
        case 5:
          return 'Vie';
        case 6:
          return 'Sáb';
        default:
          return 'Dom';
      }
    } catch (_) {
      return '';
    }
  }

  Widget _buildOperacionesRecientesTitle() {
    return const Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'OPERACIONES RECIENTES',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '// NOSQL_LOGS',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildOperacionesList(
    ResumenProvider provider,
  ) {
    if (provider.ordenes.isEmpty) {
      return const Center(
        child: Text(
          'SIN ÓRDENES REGISTRADAS',
          style: TextStyle(
            color: Colors.white38,
          ),
        ),
      );
    }

    final ordenesMostrar =
        provider.ordenes.take(5).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount: ordenesMostrar.length,
      itemBuilder: (context, index) {
        final orden = ordenesMostrar[index];

        final id =
            orden['_id']?.toString() ?? 'N/A';

        final total =
            (orden['total_venta'] ?? 0)
                .toDouble();

        return Card(
          color: Colors.black,
          child: ListTile(
            title: Text(
              '#$id',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              orden['metodo_pago'] ??
                  'EFECTIVO',
              style: const TextStyle(
                color: Colors.white54,
              ),
            ),
            trailing: Text(
              '\$${total.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.greenAccent,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorForm(
    ResumenProvider provider,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.redAccent,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            provider.errorMessage,
            style: const TextStyle(
              color: Colors.redAccent,
            ),
          ),
        ],
      ),
    );
  }
}