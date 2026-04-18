require('dotenv').config();
const express = require('express');
const cors = require('cors');
const conectarDB = require('./config/db');

const app = express();

// 1. ConexiÃ³n a la base de datos
conectarDB();

// 2. ConfiguraciÃ³n de CORS (Permite que Vue se conecte sin problemas)
app.use(cors({ origin: '*', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));

// 3. Middlewares (Debe ir ANTES de las rutas)
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// 4. DefiniciÃ³n de Rutas
app.use('/api/auth', require('./routes/auth'));
app.use('/api/ventas', require('./routes/venta')); // ðŸ’¡ Esta lÃ­nea ya carga todo lo de ventas

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('API de Refaccionaria funcionando ðŸš€');
});

// 5. Puerto y encendido
const PORT = process.env.PORT || 4000;

app.listen(PORT, '0.0.0.0', () => {
  console.log(`ðŸš€ Servidor corriendo en el puerto: ${PORT}`);
  console.log(`ðŸ”— Local: http://localhost:${PORT}`);
  console.log(`âœ… Â¡ConexiÃ³n exitosa a MongoDB Atlas!`);
});

