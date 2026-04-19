const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

router.get('/', ventaController.getVentas);
router.get('/reporte', ventaController.reportePorFecha);
router.post('/', ventaController.crearVenta);
router.get('/vendedor/:id_vendedor', ventaController.obtenerVentasPorVendedor);
router.delete('/:id', ventaController.eliminarVenta);

module.exports = router;
