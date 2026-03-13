const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// --- RUTA PARA REGISTRAR (Guardar usuarios nuevos) ---
router.post('/register', authController.register);

// --- RUTA PARA EL LOGIN (Ajustada para la App de Flutter de tu compañero) ---
router.post('/login', authController.login);

module.exports = router; 