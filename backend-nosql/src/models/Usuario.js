const mongoose = require('mongoose');

const usuarioSchema = new mongoose.Schema({
  nombre: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  // 🔥 IMPORTANTE
  estado: {
    type: String,
    enum: ['pendiente', 'activo'],
    default: 'pendiente'
  },

  id_rol: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Rol',
    default: null
  },

  id_sucursal: { type: Number },

  // ❌ ELIMINAMOS ESTO (YA NO LO USAS)
  // activo: { type: Boolean, default: true }

}, { timestamps: true });

module.exports = mongoose.model('Usuario', usuarioSchema, 'users');