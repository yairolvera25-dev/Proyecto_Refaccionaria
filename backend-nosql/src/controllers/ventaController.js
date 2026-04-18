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
        const ventas = await Venta.find({ id_vendedor: req.params.id_vendedor });
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
