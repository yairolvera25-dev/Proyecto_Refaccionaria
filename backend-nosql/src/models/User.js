const mongoose = require('mongoose');

const UserSchema = new mongoose.Schema({
    nombre: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    // Aquí definimos los puestos de la refaccionaria
    role: { 
        type: String, 
        enum: ['cliente', 'administrador', 'consultor', 'vendedor'], 
        default: 'cliente' 
    }
});

module.exports = mongoose.model('User', UserSchema);