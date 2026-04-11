const mongoose = require('mongoose');
const Role = require('./src/models/Role'); // Asegúrate de que el nombre del archivo sea Role.js
require('dotenv').config();

const inicializarRoles = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('✅ Conectado a MongoDB para crear roles...');

        const roles = [
            {
                nombre_rol: "Administrador",
                permisos: ["crear_usuarios", "ver_reportes", "gestionar_stock", "eliminar_datos"]
            },
            {
                nombre_rol: "Vendedor",
                permisos: ["crear_ventas", "consultar_productos", "ver_mis_ventas"]
            },
            {
                nombre_rol: "Consultor",
                permisos: ["consultar_productos", "ver_stock_sucursales"]
            }
        ];

        // Borra roles existentes para no duplicar si lo corres dos veces
        await Role.deleteMany({});

        // Inserta los nuevos roles
        await Role.insertMany(roles);

        console.log('🚀 ¡Roles creados exitosamente!');
        console.log('1. Administrador');
        console.log('2. Vendedor');
        console.log('3. Consultor');

        process.exit();
    } catch (error) {
        console.error('❌ Error al crear roles:', error);
        process.exit(1);
    }
};

inicializarRoles();