const Venta = require('../models/Venta');

exports.crearVenta = async (req, res) => {
    try {
        const { id_vendedor, productos, total, metodo_pago } = req.body;

        const nuevaVenta = new Venta({
            id_vendedor,
            productos,
            total,
            metodo_pago
        });

        await nuevaVenta.save();

        res.status(201).json({ exito: true, venta: nuevaVenta });
    } catch (error) {
        console.error("Error al crear venta:", error);
        res.status(500).json({ error: "Error en el servidor al procesar la venta" });
    }
};
