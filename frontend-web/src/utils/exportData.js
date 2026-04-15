import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";
import * as XLSX from "xlsx";

export const generarPDF = (items) => {
    try {
        const doc = new jsPDF();
        const fecha = new Date().toLocaleDateString().replace(/\//g, '-');

        doc.setFontSize(16);
        doc.text('REPORTE DE INVENTARIO - LOS AMIGOS CORE', 14, 20);
        doc.setFontSize(10);
        doc.setTextColor(100);
        doc.text(`Generado el: ${new Date().toLocaleString()}`, 14, 28);

        const rows = items.map(i => [
            (i.nombreOriginal || i.producto || 'SIN NOMBRE').toUpperCase(),
            i.sku || 'N/A',
            i.cantidad,
            `$${i.precio.toFixed(2)}`,
            i.cantidad < 5 ? 'CRÍTICO' : (i.cantidad < 10 ? 'BAJO' : 'OK')
        ]);

        // ─── LA SOLUCIÓN PARA VITE: Usar autoTable como función independiente ───
        autoTable(doc, {
            startY: 35,
            head: [['PRODUCTO', 'SKU', 'STOCK', 'PRECIO', 'ESTADO']],
            body: rows,
            headStyles: { fillColor: [57, 255, 20], textColor: [0, 0, 0] },
            theme: 'grid'
        });

        // Descarga directa a tu carpeta de Descargas en Fedora
        doc.save(`Reporte_Inventario_${fecha}.pdf`);

    } catch (error) {
        console.error("Error creando PDF:", error);
        alert("Error al exportar. Revisa la consola (F12) para más detalles.");
    }
};

export const generarExcel = (items) => {
    try {
        const data = items.map(i => ({
            PRODUCTO: (i.nombreOriginal || i.producto || 'SIN NOMBRE').toUpperCase(),
            SKU: i.sku || 'N/A',
            STOCK: i.cantidad,
            PRECIO: i.precio,
            ESTADO: i.cantidad < 5 ? 'CRÍTICO' : (i.cantidad < 10 ? 'BAJO' : 'OK')
        }));

        const ws = XLSX.utils.json_to_sheet(data);
        const wb = XLSX.utils.book_new();
        XLSX.utils.book_append_sheet(wb, ws, "Inventario");

        // Descarga directa a tu carpeta de Descargas
        const fecha = new Date().toLocaleDateString().replace(/\//g, '-');
        XLSX.writeFile(wb, `Reporte_Inventario_${fecha}.xlsx`);

    } catch (error) {
        console.error("Error creando Excel:", error);
    }
};