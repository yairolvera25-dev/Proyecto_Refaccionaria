const User = require('../models/User');

// Lógica para registrar usuarios
const register = async (req, res) => {
    try {
        const { nombre, email, password, role } = req.body;

        // Verificar si el usuario ya existe para evitar duplicados
        const existeUsuario = await User.findOne({ email });
        if (existeUsuario) {
            return res.status(400).json({ msg: "❌ El correo ya está registrado" });
        }

        const nuevoUsuario = new User({ nombre, email, password, role });
        await nuevoUsuario.save();

        res.json({ mensaje: "✅ Usuario registrado con éxito, abejito" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ msg: "❌ Error al registrar el usuario" });
    }
};

// Lógica para iniciar sesión
const login = async (req, res) => {
    try {
        const { email, password } = req.body;

        // 1. Buscamos al usuario por correo
        const usuarioEncontrado = await User.findOne({ email });

        // 2. Si no existe, mandamos error 401 (No autorizado)
        if (!usuarioEncontrado) {
            return res.status(401).json({ msg: "❌ El correo no está registrado" });
        }

        // 3. Verificamos la contraseña (texto plano por ahora)
        if (usuarioEncontrado.password !== password) {
            return res.status(401).json({ msg: "❌ Contraseña incorrecta" });
        }

        // 4. RESPUESTA ESPECIAL: Envolvemos los datos en un objeto "user"
        res.json({
            exito: true,
            user: {
                nombre: usuarioEncontrado.nombre,
                email: usuarioEncontrado.email,
                role: usuarioEncontrado.role // Aquí dirá 'administrador', 'vendedor', etc.
            }
        });

    } catch (error) {
        console.error("Error en el servidor:", error);
        res.status(500).json({ msg: "❌ Error interno del servidor" });
    }
};

// Exportamos las funciones
module.exports = { register, login };