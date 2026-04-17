const mongoose = require('mongoose');

const VentasSchema = new mongoose.Schema({
    id_vendedor: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    productos: [
        {
            id_producto: { type: String, required: true },
            cantidad: { type: Number, required: true }
        }
    ],
    total: { type: Number, required: true },
    metodo_pago: { type: String, required: true },
    fecha: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model('Venta', VentasSchema);