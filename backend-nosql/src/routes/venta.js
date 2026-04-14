const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

// Ruta para crear venta
router.post('/', ventaController.registrarVenta);

// Ruta para obtener ventas por ID de vendedor
router.get('/vendedor/:id_vendedor', ventaController.obtenerVentasPorVendedor);

// Ruta para obtener TODAS las ventas (la que necesita tu Dashboard)
router.get('/', ventaController.obtenerTodasLasVentas);

module.exports = router;