const Venta = require('../models/Venta');

// 1. Obtener TODAS las ventas (La que usa tu Dashboard de Consultor)
const obtenerTodasLasVentas = async (req, res) => {
    try {
        // Buscamos todas las ventas y las ordenamos de la más reciente a la más vieja
        const ventas = await Venta.find().sort({ createdAt: -1 });

        // Enviamos directamente el arreglo para que el FutureBuilder de Flutter lo lea bien
        res.json(ventas);
    } catch (error) {
        console.error("Error al obtener todas las ventas:", error);
        res.status(500).json({ msg: "Error al obtener las ventas", error: error.message });
    }
};

// 2. Registrar venta (La que ya tenías, está bien mapeada)
const registrarVenta = async (req, res) => {
    try {
        const productosParaMongo = req.body.items.map(item => ({
            id_producto: item.id || item.id_producto,
            sku: item.sku || 'SIN-SKU',
            nombre_pieza: item.nombre || item.nombre_pieza,
            cantidad: item.cantidad || 1,
            precio_unitario: item.precio || 0,
            subtotal: (item.cantidad || 1) * (item.precio || 0)
        }));

        const nuevaVenta = new Venta({
            ...req.body,
            productos_vendidos: productosParaMongo
        });

        await nuevaVenta.save();

        // Notificación opcional a Laravel
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
            console.log("✅ Laravel fue notificado.");
        } catch (errorLaravel) {
            console.error("⚠️ Laravel no respondió.");
        }

        res.status(201).json({
            exito: true,
            mensaje: "✅ Venta registrada correctamente",
            venta: nuevaVenta
        });

    } catch (error) {
        res.status(500).json({ msg: "❌ Error al procesar venta", error: error.message });
    }
};

// 3. Obtener ventas por vendedor específico
const obtenerVentasPorVendedor = async (req, res) => {
    try {
        const id_vendedor = req.params.id_vendedor || req.params.id;
        const ventas = await Venta.find({ id_vendedor }).sort({ createdAt: -1 });
        res.json({ exito: true, ventas });
    } catch (error) {
        res.status(500).json({ msg: "Error al obtener las ventas", error: error.message });
    }
};

// IMPORTANTE: Exporta la nueva función también
module.exports = {
    registrarVenta,
    obtenerVentasPorVendedor,
    obtenerTodasLasVentas
};