require('dotenv').config();
const express = require('express');
const cors = require('cors');
const conectarDB = require('./config/db');

const app = express();

// 1. Conexión a la base de datos
conectarDB();

// 2. Configuración de CORS Mejorada
// Al usar app.use(cors()) sin parámetros, permites TODO por defecto.
// Es lo mejor para desarrollo local entre varios dispositivos.
app.use(cors());

// 3. Middleware para entender datos JSON (Debe ir antes de las rutas)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 4. Rutas del Sistema
app.use('/api/auth', require('./routes/auth'));

// Ruta de prueba para verificar que el backend responde
app.get('/', (req, res) => {
  res.send('API de Refaccionaria funcionando 🚀');
});

// 5. Puerto dinámico
const PORT = process.env.PORT || 4000; // Cambié a 4000 que es el que usas en tu .env

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor corriendo en el puerto: ${PORT}`);
  console.log(`🔗 Local: http://localhost:${PORT}`);
  console.log(`✅ ¡Conexión exitosa a la Refaccionaria, abejito!`);
});