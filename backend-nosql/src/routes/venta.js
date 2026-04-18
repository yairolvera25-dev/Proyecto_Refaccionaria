const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

// 💡 POST /api/ventas
router.post('/', ventaController.crearVenta);

// 💡 GET /api/ventas/vendedor/:id_vendedor
// Asegúrate de que en ventaController.js la función se llame 'obtenerVentasPorVendedor'
router.get('/vendedor/:id_vendedor', ventaController.obtenerVentasPorVendedor);

module.exports = router;