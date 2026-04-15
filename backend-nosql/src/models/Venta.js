const mongoose = require('mongoose');

const VentaSchema = new mongoose.Schema({
    fecha_hora: { type: Date, default: Date.now },
    id_vendedor: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    id_sucursal_orig: { type: Number, required: true },
    total_venta: { type: Number, required: true },
    estatus: {
        type: String,
        enum: ['Completada', 'Cancelada', 'Fallida'],
        default: 'Completada'
    },
    // Arreglo de productos vendidos
    productos_vendidos: [
        {
            id_producto: { type: Number, required: true }, // ID de MySQL
            sku: { type: String, required: true },
            nombre_pieza: { type: String, required: true },
            cantidad: { type: Number, required: true },
            precio_unitario: { type: Number, required: true }
        }
    ]
}, { timestamps: true });

module.exports = mongoose.model('Venta', VentaSchema);