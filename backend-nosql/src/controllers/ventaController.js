const Venta = require('../models/Venta');

const registrarVenta = async (req, res) => {
    try {
        // Recibimos el JSON con el formato que definiste
        const nuevaVenta = new Venta(req.body);
        await nuevaVenta.save();

        // AQUÍ ES DONDE DESPUÉS CONECTAREMOS CON LARAVEL
        // Para restar el stock en MySQL.

        res.status(201).json({
            mensaje: "✅ Venta registrada en NoSQL",
            venta: nuevaVenta
        });
    } catch (error) {
        res.status(500).json({ msg: "❌ Error al procesar venta", error: error.message });
    }
};

module.exports = { registrarVenta };