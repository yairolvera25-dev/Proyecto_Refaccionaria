const mongoose = require('mongoose');

const VentasSchema = new mongoose.Schema({
    id_vendedor: { 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User', 
        required: true 
    },
    productos_vendidos: [{
        id_producto: { type: String, required: true },
        cantidad: { type: Number, required: true },
        precio_unitario: Number,
        subtotal: Number
    }],
    total_venta: { type: Number, required: true },
    estatus: { type: String, default: 'Completada' },
    fecha_hora: { type: Date, default: Date.now }
}, { timestamps: true });

module.exports = mongoose.model('Venta', VentasSchema);
