const Venta = require('../models/Venta');

exports.getVentas = async (req, res) => {
    try {
        const ventas = await Venta.find().populate('id_vendedor', 'nombre email');
        res.json(ventas);
    } catch (error) {
        res.status(500).json({ msg: "Error al obtener ventas", error: error.message });
    }
};

exports.crearVenta = async (req, res) => {
    try {
        const nuevaVenta = new Venta(req.body);
        await nuevaVenta.save();
        res.json({ msg: "✅ Venta registrada", venta: nuevaVenta });
    } catch (error) {
        res.status(500).json({ msg: "Error al crear la venta", error: error.message });
    }
};

exports.obtenerVentasPorVendedor = async (req, res) => {
    try {
        const ventas = await Venta.find({ id_vendedor: req.params.id_vendedor }).populate('id_vendedor', 'nombre email');
        res.json(ventas);
    } catch (error) {
        res.status(500).json({ msg: "Error", error: error.message });
    }
};

exports.eliminarVenta = async (req, res) => {
    try {
        await Venta.findByIdAndDelete(req.params.id);
        res.json({ msg: "✅ Venta eliminada" });
    } catch (error) {
        res.status(500).json({ msg: "Error al eliminar", error: error.message });
    }
};

exports.reportePorFecha = async (req, res) => {
    try {
        const { fechaInicio, fechaFin } = req.query;

        if (!fechaInicio || !fechaFin) {
            return res.status(400).json({
                msg: "fechaInicio y fechaFin son obligatorias"
            });
        }

        const inicio = new Date(`${fechaInicio}T00:00:00.000Z`);
        const fin = new Date(`${fechaFin}T23:59:59.999Z`);

        const ventas = await Venta.find({
            fecha_hora: { $gte: inicio, $lte: fin }
        })
        .populate('id_vendedor', 'nombre email')
        .sort({ fecha_hora: -1 });

        const ventasFormateadas = ventas.map((venta) => ({
            _id: venta._id,
            folio: venta._id,
            fecha: venta.fecha_hora,
            fecha_formateada: new Date(venta.fecha_hora).toLocaleString(),
            cliente_nombre: "Público general",
            vendedor_nombre: venta.id_vendedor?.nombre || venta.id_vendedor?.email || "-",
            total: Number(venta.total_venta || 0),
            estatus: venta.estatus || "Completada"
        }));

        const totalVentas = ventasFormateadas.reduce((acc, venta) => acc + Number(venta.total || 0), 0);

        return res.json({
            totalRegistros: ventasFormateadas.length,
            totalVentas,
            ventas: ventasFormateadas
        });
    } catch (error) {
        console.error("Error en reportePorFecha:", error);
        return res.status(500).json({
            msg: "Error al generar el reporte",
            error: error.message
        });
    }
};
