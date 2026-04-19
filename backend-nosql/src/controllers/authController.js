const User = require('../models/User');
const Role = require('../models/Role');
const bcrypt = require('bcryptjs');

exports.getUsers = async (req, res) => {
    try {
        const users = await User.find().populate('id_rol');
        res.json(users);
    } catch (error) {
        res.status(500).json({ msg: "Error", error: error.message });
    }
};

exports.register = async (req, res) => {
    try {
        const { nombre, email, password } = req.body;

        const existeUsuario = await User.findOne({ email });
        if (existeUsuario) {
            return res.status(400).json({ msg: "El correo ya está registrado" });
        }

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        const nuevoUsuario = new User({
            nombre,
            email,
            password: hashedPassword,
            id_rol: null,
            activo: false
        });

        await nuevoUsuario.save();

        res.json({
            msg: "Usuario creado y pendiente de aprobación",
            exito: true
        });

    } catch (error) {
        res.status(500).json({ msg: "Error al crear", error: error.message });
    }
};

exports.updateUser = async (req, res) => {
    try {
        const { nombre, email, nombre_rol, activo } = req.body;

        const updateData = {};

        if (nombre !== undefined) updateData.nombre = nombre;
        if (email !== undefined) updateData.email = email;

        if (nombre_rol) {
            const rolDoc = await Role.findOne({ nombre_rol });

            if (!rolDoc) {
                return res.status(404).json({ msg: "Rol no encontrado" });
            }

            updateData.id_rol = rolDoc._id;
        }

        if (activo !== undefined) {
            updateData.activo = activo;
        }

        const usuarioActualizado = await User.findByIdAndUpdate(
            req.params.id,
            updateData,
            { new: true }
        ).populate('id_rol');

        if (!usuarioActualizado) {
            return res.status(404).json({ msg: "Usuario no encontrado" });
        }

        res.json({
            msg: "Usuario actualizado",
            user: usuarioActualizado
        });

    } catch (error) {
        res.status(500).json({ msg: "Error", error: error.message });
    }
};

exports.deleteUser = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);

        if (!user) {
            return res.status(404).json({ msg: "Usuario no encontrado" });
        }

        await User.findByIdAndDelete(req.params.id);

        res.json({ msg: "Usuario eliminado" });

    } catch (error) {
        res.status(500).json({ msg: "Error", error: error.message });
    }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email }).populate('id_rol');

        if (!user) {
            return res.status(401).json({ msg: "Usuario no encontrado" });
        }

        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(401).json({ msg: "Contraseña incorrecta" });
        }

        if (!user.activo) {
            return res.status(403).json({ msg: "Usuario pendiente de aprobación" });
        }

        res.json({
            exito: true,
            user: {
                id: user._id,
                nombre: user.nombre,
                rol: user.id_rol?.nombre_rol || null,
                activo: user.activo
            }
        });

    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.aprobarUsuario = async (req, res) => {
    try {
        const { nombre_rol } = req.body;

        const rolDoc = await Role.findOne({ nombre_rol });

        if (!rolDoc) {
            return res.status(404).json({ msg: "Rol no encontrado" });
        }

        const user = await User.findByIdAndUpdate(
            req.params.id,
            {
                id_rol: rolDoc._id,
                activo: true
            },
            { new: true }
        ).populate('id_rol');

        if (!user) {
            return res.status(404).json({ msg: "Usuario no encontrado" });
        }

        res.json({
            msg: "Usuario aprobado correctamente",
            user
        });

    } catch (error) {
        res.status(500).json({ msg: "Error al aprobar", error: error.message });
    }
};

exports.rechazarUsuario = async (req, res) => {
    try {
        const user = await User.findById(req.params.id);

        if (!user) {
            return res.status(404).json({ msg: "Usuario no encontrado" });
        }

        await User.findByIdAndDelete(req.params.id);

        res.json({ msg: "Usuario eliminado correctamente" });

    } catch (error) {
        res.status(500).json({ msg: "Error al eliminar", error: error.message });
    }
};
