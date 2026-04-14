const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.get('/', authController.getUsers);
router.post('/register', authController.register);
router.post('/login', authController.login);
router.put('/:id', authController.updateUser);
router.delete('/:id', authController.deleteUser);

module.exports = router;
