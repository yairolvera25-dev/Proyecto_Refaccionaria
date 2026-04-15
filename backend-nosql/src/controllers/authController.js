const User = require('../models/User');
const Role = require('../models/Role');

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
        const { nombre, email, password, nombre_rol } = req.body;
        const rolDoc = await Role.findOne({ nombre_rol: nombre_rol || 'Vendedor' });
        const nuevoUsuario = new User({
            nombre, email, password,
            id_rol: rolDoc ? rolDoc._id : null,
            id_sucursal: 1
        });
        await nuevoUsuario.save();
        res.json({ msg: "✅ Usuario creado" });
    } catch (error) {
        res.status(500).json({ msg: "Error al crear", error: error.message });
    }
};

exports.updateUser = async (req, res) => {
    try {
        const { nombre, email, nombre_rol } = req.body;
        const rolDoc = await Role.findOne({ nombre_rol });
        const updateData = { nombre, email };
        if (rolDoc) updateData.id_rol = rolDoc._id;
        await User.findByIdAndUpdate(req.params.id, updateData);
        res.json({ msg: "✅ Usuario actualizado" });
    } catch (error) { res.status(500).json({ msg: "Error" }); }
};

exports.deleteUser = async (req, res) => {
    try {
        await User.findByIdAndDelete(req.params.id);
        res.json({ msg: "✅ Usuario eliminado" });
    } catch (error) { res.status(500).json({ msg: "Error" }); }
};

exports.login = async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await User.findOne({ email }).populate('id_rol');
        if (!user || user.password !== password) return res.status(401).json({ msg: "Error" });
        res.json({ exito: true, user: { id: user._id, nombre: user.nombre, rol: user.id_rol?.nombre_rol } });
    } catch (error) { res.status(500).json({ error: error.message }); }
};
