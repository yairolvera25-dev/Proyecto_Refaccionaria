require('dotenv').config();
const express = require('express');
const cors = require('cors');
const conectarDB = require('./config/db');

const app = express();

// 1. Conexión a la base de datos
conectarDB();

// 2. Configuración de CORS (Permite que Vue se conecte sin problemas)
app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));

// 3. Middlewares (Debe ir ANTES de las rutas)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 4. Definición de Rutas
app.use('/api/auth', require('./routes/auth'));
app.use('/api/ventas', require('./routes/venta'));
app.use('/api/ventas', require('./routes/venta')); // 💡 Esta línea ya carga todo lo de ventas

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('API de Refaccionaria funcionando 🚀');
});

// 5. Puerto y encendido
const PORT = process.env.PORT || 4000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Servidor corriendo en el puerto: ${PORT}`);
  console.log(`🔗 Local: http://localhost:${PORT}`);
  console.log(`✅ ¡Conexión exitosa a MongoDB Atlas!`);
});