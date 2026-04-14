const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

// Ruta para crear venta
router.post('/', ventaController.registrarVenta);

// Ruta para obtener ventas por ID de vendedor
router.get('/vendedor/:id_vendedor', ventaController.obtenerVentasPorVendedor);

// Ruta para obtener estadísticas de los últimos 7 días
router.get('/stats/:idVendedor', ventaController.obtenerStatsVentas);

module.exports = router;