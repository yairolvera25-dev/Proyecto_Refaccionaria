const User = require('../models/User');
const Role = require('../models/Role');

exports.register = async (req, res) => {
    try {
        const { nombre, email, password, nombre_rol, id_sucursal } = req.body;

        const existe = await User.findOne({ email });
        if (existe) return res.status(400).json({ msg: "❌ El correo ya existe" });

        // Buscamos el rol en la colección 'roles'
        const rolDoc = await Role.findOne({ nombre_rol: nombre_rol || 'Vendedor' });
        if (!rolDoc) return res.status(400).json({ msg: "❌ El rol no existe en la base de datos" });

        const nuevoUsuario = new User({
            nombre,
            email,
            password,
            id_rol: rolDoc._id,
            id_sucursal: id_sucursal || 1
        });

        await nuevoUsuario.save();
        res.json({ msg: "✅ Registrado con éxito", rol: rolDoc.nombre_rol });
    } catch (error) {
        res.status(500).json({ msg: "❌ Error", error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        // El .populate trae el nombre del rol en lugar de solo el ID
        const user = await User.findOne({ email }).populate('id_rol');

        if (!user || user.password !== password) {
            return res.status(401).json({ msg: "❌ Credenciales incorrectas" });
        }

        res.json({
            exito: true,
            user: {
                id: user._id,
                nombre: user.nombre,
                rol: user.id_rol.nombre_rol,
                id_sucursal: user.id_sucursal
            }
        });
    } catch (error) {
        res.status(500).json({ msg: "❌ Error en login" });
    }
};