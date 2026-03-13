const mongoose = require('mongoose');

const conectarDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('✅ ¡Conexión exitosa a la Refaccionaria, abejito!');
    } catch (error) {
        console.error('❌ Error al conectar:', error.message);
        process.exit(1);
    }
};

module.exports = conectarDB;