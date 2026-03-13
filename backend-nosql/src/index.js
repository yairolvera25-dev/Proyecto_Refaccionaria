require('dotenv').config();
const express = require('express');
const cors = require('cors'); // El guardia de seguridad de tu servidor
const conectarDB = require('./config/db');

const app = express();

// 1. Conexión a la base de datos de MongoDB Atlas
conectarDB();

// 2. Configuración de CORS (Permisos para tu compañero)
app.use(cors({
  origin: '*', // Permite que cualquier laptop se conecte
  methods: ['GET', 'POST', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'ngrok-skip-browser-warning']
}));

// 3. Middleware para entender datos JSON
app.use(express.json());

// 4. Rutas del Sistema
app.use('/api/auth', require('./routes/auth'));

// Nota: La ruta de productos sigue comentada hasta que la necesites
// app.use('/api/products', require('./routes/products')); 

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Servidor listo para trabajar con tu equipo`);
    console.log(`✅ ¡Conexión exitosa a la Refaccionaria, abejito!`);
});