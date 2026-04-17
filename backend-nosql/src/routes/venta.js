const express = require('express');
const router = express.Router();
const ventaController = require('../controllers/ventaController');

// POST /api/ventas (Registrado en index.js)
router.post('/', ventaController.crearVenta);

module.exports = router;