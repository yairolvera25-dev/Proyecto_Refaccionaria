require('dotenv').config();
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const User = require('../src/models/User');
const Role = require('../src/models/Role');

async function main() {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('Mongo conectado');

    let role = await Role.findOne({ nombre_rol: 'Administrador' });

    if (!role) {
      role = await Role.create({ nombre_rol: 'Administrador' });
      console.log('Rol Administrador creado');
    }

    const email = 'admin@refaccionaria.com';
    const plainPassword = 'Admin123*';
    const hashedPassword = await bcrypt.hash(plainPassword, 10);

    let user = await User.findOne({ email });

    if (user) {
      user.nombre = 'Administrador General';
      user.password = hashedPassword;
      user.estado = 'activo';
      user.id_rol = role._id;
      await user.save();
      console.log('Admin actualizado');
    } else {
      user = await User.create({
        nombre: 'Administrador General',
        email: email,
        password: hashedPassword,
        estado: 'activo',
        id_rol: role._id
      });
      console.log('Admin creado');
    }

    console.log('--------------------------------');
    console.log('EMAIL: admin@refaccionaria.com');
    console.log('PASSWORD: Admin123*');
    console.log('--------------------------------');

    await mongoose.disconnect();
    process.exit(0);
  } catch (error) {
    console.error('Error:', error);
    process.exit(1);
  }
}

main();
