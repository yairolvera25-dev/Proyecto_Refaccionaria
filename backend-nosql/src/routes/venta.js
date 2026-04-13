const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

// Ruta para crear venta
router.post('/', ventaController.registrarVenta);

// Ruta para obtener ventas por ID de vendedor
router.get('/vendedor/:id_vendedor', ventaController.obtenerVentasPorVendedor);

module.exports = router;