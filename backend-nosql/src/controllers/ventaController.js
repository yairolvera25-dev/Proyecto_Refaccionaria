const Venta = require('../models/Venta');

const registrarVenta = async (req, res) => {
    try {
        // 💡 MAPEO EXACTO PARA MONGOOSE
        // Cambiamos los nombres para que coincidan con tu Schema de Venta.js
        const productosParaMongo = req.body.items.map(item => ({
            id_producto: item.id || item.id_producto,          // Requerido por Mongoose
            sku: item.sku || 'SIN-SKU',                        // Requerido por Mongoose
            nombre_pieza: item.nombre || item.nombre_pieza,    // Requerido por Mongoose
            cantidad: item.cantidad || 1,
            precio_unitario: item.precio || 0,                 // Requerido por Mongoose
            // Opcional, pero bueno tenerlo:
            subtotal: (item.cantidad || 1) * (item.precio || 0)
        }));

        // 1. Guardamos la venta en MongoDB Atlas
        const nuevaVenta = new Venta({
            ...req.body,
            productos_vendidos: productosParaMongo
        });

        await nuevaVenta.save();

        // 2. Avisarle a Laravel (MySQL) que descuente el stock
        const itemsVendidos = req.body.items.map(item => ({
            id: item.id,
            cantidad: item.cantidad
        }));

        try {
            await fetch('http://localhost:8000/api/productos/descontar-stock', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ items: itemsVendidos })
            });
            console.log("✅ Laravel fue notificado para descontar stock.");
        } catch (errorLaravel) {
            console.error("⚠️ La venta se guardó en Mongo, pero Laravel no respondió:", errorLaravel.message);
        }

        // 3. Respondemos al Frontend
        res.status(201).json({
            exito: true,
            mensaje: "✅ Venta registrada correctamente",
            venta: nuevaVenta
        });

    } catch (error) {
        console.error("Error en registrarVenta:", error);
        res.status(500).json({ msg: "❌ Error al procesar venta", error: error.message });
    }
};

// ... tu otra función obtenerVentasPorVendedor se queda igual ...

const obtenerVentasPorVendedor = async (req, res) => {
    try {
        // 🛡️ BLINDAJE: Dependiendo de cómo definiste la ruta en routes/venta.js
        // puede llegar como req.params.id_vendedor o req.params.id
        const id_vendedor = req.params.id_vendedor || req.params.id;

        const ventas = await Venta.find({ id_vendedor }).sort({ createdAt: -1 });
        res.json({ exito: true, ventas });
    } catch (error) {
        res.status(500).json({ msg: "Error al obtener las ventas", error: error.message });
    }
};

module.exports = { registrarVenta, obtenerVentasPorVendedor };