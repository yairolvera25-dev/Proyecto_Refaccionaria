const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    nombre: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    id_rol: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Role',
        required: true
    },
    id_sucursal: { type: Number, required: true },
    activo: { type: Boolean, default: true }
}, { timestamps: true });

module.exports = mongoose.model('User', UserSchema);
