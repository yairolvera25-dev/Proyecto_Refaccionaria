const mongoose = require('mongoose');

const VentasSchema = new mongoose.Schema({
    fecha_hora: { type: Date, default: Date.now },
    id_vendedor: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    total_venta: { type: Number, required: true },
    estatus: {
        type: String,
        enum: ['Completada', 'Cancelada', 'Fallida'],
        default: 'Completada'
    },
    productos_vendidos: [
        {
            id_producto: { type: Number, required: true },
            sku: { type: String, required: true },
            nombre_pieza: { type: String, required: true },
            cantidad: { type: Number, required: true },
            precio: { type: Number, required: true } // Cambio de precio_unitario a precio
        }
    ]
}, { timestamps: true });

module.exports = mongoose.model('Venta', VentasSchema);