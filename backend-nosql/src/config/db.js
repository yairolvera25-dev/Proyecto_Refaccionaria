const mongoose = require('mongoose');
require('dotenv').config(); // Esto carga el archivo .env

const conectarDB = async () => {
    try {
        const url = process.env.MONGO_URI;

        await mongoose.connect(url);
        console.log('✅ ¡Conexión exitosa a MongoDB Atlas!');
    } catch (error) {
        console.error('❌ Error al conectar a MongoDB:', error.message);
        process.exit(1);
    }
};

module.exports = conectarDB;