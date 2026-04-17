import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:refaccionaria_app/features/vendedor/models/venta_model.dart';

class ReportService {
  // ─── PDF ──────────────────────────────────────────────────────────────────

  static Future<void> generarPDF(
      BuildContext context, List<VentaItem> items) async {
    final pdf = pw.Document();

    final criticos = items.where((i) => i.estado == 'critico').length;
    final pendientes = items.where((i) => i.estado == 'pendiente').length;
    final totalIngresos = items.fold(0.0, (s, i) => s + i.totalVenta);
    final fecha = DateTime.now();
    final fechaStr =
        '${fecha.day}/${fecha.month}/${fecha.year} ${fecha.hour}:${fecha.minute.toString().padLeft(2, '0')}';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('REFACCIONARIA',
                        style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey,
                            letterSpacing: 2)),
                    pw.Text('LOS AMIGOS CORE',
                        style: pw.TextStyle(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.black)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('REPORTE DE INVENTARIO',
                        style: pw.TextStyle(
                            fontSize: 10,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.grey700)),
                    pw.Text(fechaStr,
                        style: const pw.TextStyle(
                            fontSize: 9, color: PdfColors.grey)),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Divider(color: PdfColors.grey300, thickness: 0.5),
            pw.SizedBox(height: 8),
          ],
        ),
        build: (_) => [
          // Resumen
          pw.Container(
            padding: const pw.EdgeInsets.all(16),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: [
                _pdfStatBox('TOTAL PIEZAS', '${items.length}',
                    PdfColors.blue700),
                _pdfStatBox('INGRESOS',
                    '\$${totalIngresos.toStringAsFixed(2)}', PdfColors.green700),
                _pdfStatBox(
                    'CRÍTICOS', '$criticos', PdfColors.red700),
                _pdfStatBox(
                    'PENDIENTES', '$pendientes', PdfColors.orange700),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          // Tabla
          pw.Text('DETALLE DE INVENTARIO',
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                  letterSpacing: 1.5)),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder(
              horizontalInside: const pw.BorderSide(
                  color: PdfColors.grey200, width: 0.5),
              bottom:
                  const pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(1.2),
              3: const pw.FlexColumnWidth(1.5),
              4: const pw.FlexColumnWidth(1.5),
              5: const pw.FlexColumnWidth(1.5),
            },
            children: [
              // Header
              pw.TableRow(
                decoration:
                    const pw.BoxDecoration(color: PdfColors.grey800),
                children: [
                  'PRODUCTO',
                  'SKU',
                  'STOCK',
                  'PRECIO',
                  'TOTAL',
                  'ESTADO',
                ]
                    .map((h) => pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 8, vertical: 6),
                          child: pw.Text(h,
                              style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 8,
                                  fontWeight: pw.FontWeight.bold)),
                        ))
                    .toList(),
              ),
              // Filas
              ...items.asMap().entries.map((e) {
                final i = e.value;
                final isOdd = e.key % 2 == 1;
                final estadoColor = i.estado == 'critico'
                    ? PdfColors.red700
                    : i.estado == 'pendiente'
                        ? PdfColors.orange700
                        : PdfColors.green700;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: isOdd ? PdfColors.grey50 : PdfColors.white,
                  ),
                  children: [
                    i.producto,
                    i.sku,
                    '${i.cantidad}',
                    '\$${i.precio.toStringAsFixed(2)}',
                    '\$${i.totalVenta.toStringAsFixed(2)}',
                    i.estado.toUpperCase(),
                  ]
                      .asMap()
                      .entries
                      .map((cell) => pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: pw.Text(
                              cell.value,
                              style: pw.TextStyle(
                                fontSize: 8,
                                color: cell.key == 5
                                    ? estadoColor
                                    : PdfColors.grey800,
                                fontWeight: cell.key == 5
                                    ? pw.FontWeight.bold
                                    : pw.FontWeight.normal,
                              ),
                            ),
                          ))
                      .toList(),
                );
              }),
            ],
          ),
          pw.SizedBox(height: 20),
          // Footer resumen
          pw.Divider(color: PdfColors.grey300, thickness: 0.5),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Total de registros: ${items.length}',
                  style: const pw.TextStyle(
                      fontSize: 9, color: PdfColors.grey)),
              pw.Text(
                  'Ingresos totales: \$${totalIngresos.toStringAsFixed(2)}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.green700)),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (_) async => pdf.save(),
      name: 'reporte_inventario_${fecha.day}-${fecha.month}-${fecha.year}.pdf',
    );
  }

  static pw.Widget _pdfStatBox(
          String label, String value, PdfColor color) =>
      pw.Column(
        children: [
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: color)),
          pw.SizedBox(height: 2),
          pw.Text(label,
              style:
                  const pw.TextStyle(fontSize: 7, color: PdfColors.grey600)),
        ],
      );

  // ─── EXCEL ARREGLADO ──────────────────────────────────────────────────────

  static Future<void> generarExcel(
      BuildContext context, List<VentaItem> items) async {
    final excel = Excel.createExcel();
    final sheet = excel['Inventario'];

    // Estilos
    final headerStyle = CellStyle(
      bold: true,
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      backgroundColorHex: ExcelColor.fromHexString('#1A1D24'),
      horizontalAlign: HorizontalAlign.Center,
    );
    final critStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('#FF5252'),
      bold: true,
    );
    final pendStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('#FFB300'),
      bold: true,
    );
    final okStyle = CellStyle(
      fontColorHex: ExcelColor.fromHexString('#00C853'),
      bold: true,
    );

    // Título
    sheet.merge(
        CellIndex.indexByString('A1'), CellIndex.indexByString('F1'));
    final titleCell = sheet.cell(CellIndex.indexByString('A1'));
    titleCell.value = TextCellValue('REFACCIONARIA LOS AMIGOS CORE — REPORTE DE INVENTARIO');
    titleCell.cellStyle = CellStyle(
      bold: true,
      fontSize: 14,
      horizontalAlign: HorizontalAlign.Center,
    );

    // Fecha
    sheet.merge(
        CellIndex.indexByString('A2'), CellIndex.indexByString('F2'));
    final dateCell = sheet.cell(CellIndex.indexByString('A2'));
    final now = DateTime.now();
    dateCell.value = TextCellValue(
        'Generado: ${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}');
    dateCell.cellStyle =
        CellStyle(italic: true, fontColorHex: ExcelColor.fromHexString('#888888'));

    // Espacio
    sheet.appendRow([TextCellValue('')]);

    // Headers (Usando appendRow directo)
    final headers = [
      'PRODUCTO',
      'SKU',
      'STOCK',
      'PRECIO UNITARIO',
      'TOTAL VENTA',
      'ESTADO',
    ];
    sheet.appendRow(headers.map((h) => TextCellValue(h)).toList());
    
    // Aplicar estilo al header
    final headerRowIdx = sheet.maxRows - 1;
    for (var i = 0; i < headers.length; i++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: headerRowIdx)).cellStyle = headerStyle;
    }

    // Datos (Usando appendRow directo para evitar errores de espacios en blanco)
    for (final item in items) {
      sheet.appendRow([
        TextCellValue(item.producto),
        TextCellValue(item.sku),
        IntCellValue(item.cantidad),
        DoubleCellValue(item.precio),
        DoubleCellValue(item.totalVenta),
        TextCellValue(item.estado.toUpperCase()),
      ]);
      
      // Aplicar color a la columna de ESTADO
      final currentRowIdx = sheet.maxRows - 1;
      final estadoCell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: currentRowIdx));
      estadoCell.cellStyle = item.estado == 'critico'
          ? critStyle
          : item.estado == 'pendiente'
              ? pendStyle
              : okStyle;
    }

    // Ancho de columnas
    sheet.setColumnWidth(0, 35);
    sheet.setColumnWidth(1, 18);
    sheet.setColumnWidth(2, 10);
    sheet.setColumnWidth(3, 16);
    sheet.setColumnWidth(4, 16);
    sheet.setColumnWidth(5, 14);

    // Guardar
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/reporte_${now.day}-${now.month}-${now.year}.xlsx';
    final fileBytes = excel.save();
    
    if (fileBytes != null) {
      File(path).writeAsBytesSync(fileBytes);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1A1D24),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF39FF14), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Excel generado',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      Text(path, style: const TextStyle(color: Colors.white54, fontSize: 9),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}