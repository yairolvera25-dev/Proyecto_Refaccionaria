import { ref, computed, onMounted } from "vue";
import { userService } from "../../services/userService";
import { productoService } from "../../services/productoService";
import { userService } from "../../services/userService";
import { productoService } from "../../services/productoService";
<script setup>
import axios from 'axios';

const seccionActiva = ref("dashboard");
const busqueda = ref('');
const usuarios = ref([]);
const productos = ref([]);
const mostrarModal = ref(false);
const modoEdicion = ref(false);
const itemSeleccionado = ref(null);

// Formulario único reactivo
const form = ref({});


onMounted(() => { cargarTodo(); });
const cargarTodo = async () => {
  try {
    const resUsers = await userService.getAll();
    usuarios.value = Array.isArray(resUsers) ? resUsers : (resUsers.usuarios || []);
    const resProds = await productoService.getAll();
    productos.value = Array.isArray(resProds) ? resProds : (resProds.data || []);
    console.log("Dashboard Admin Sincronizado");
  } catch (error) {
    console.error("Error en CRUD:", error);
  }
};

// --- FUNCIONES CRUD ---

const abrirModal = (item = null) => {
  itemSeleccionado.value = item;
  modoEdicion.value = !!item;
  
  if (seccionActiva.value === 'usuarios') {
    form.value = item ? { ...item, nombre_rol: item.id_rol?.nombre_rol || 'Vendedor' } 
                      : { nombre: '', email: '', password: '', nombre_rol: 'Vendedor' };
  } else {
    form.value = item ? { ...item } 
                      : { sku: '', nombre: '', marca: '', precio_venta: 0, stock_minimo: 5, id_categoria: 1 };
  }
  mostrarModal.value = true;
};

const guardar = async () => {
  try {
    if (seccionActiva.value === "usuarios") {
      if (modoEdicion.value) await userService.update(itemSeleccionado.value._id, form.value);
      else await userService.create(form.value);
    } else {
      if (modoEdicion.value) await productoService.update(itemSeleccionado.value.id, form.value);
      else await productoService.create(form.value);
    }
    await cargarTodo();
    mostrarModal.value = false;
    mostrarModal.value = false;
  } catch (e) { alert("Error en la operación. Revisa los servicios."); }
};

const eliminar = async (id) => {
  if (!confirm("¿Confirmas la eliminación definitiva?")) return;
  try {
    if (seccionActiva.value === "usuarios") await userService.delete(id);
    else await productoService.delete(id);
    await cargarTodo();
  } catch (e) { alert("Error al eliminar."); }
};

const datosFiltrados = computed(() => {
  const lista = seccionActiva.value === "usuarios" ? usuarios.value : productos.value;
  if (busqueda.value === "") return lista;
  return lista.filter(item => 
    Object.values(item).some(val => 
      String(val).toLowerCase().includes(busqueda.value.toLowerCase())
    )
  );
});

</script>

<template>
  <div class="app-shell">
    <aside class="sidebar">
      <div class="brand-box">
        <div class="logo-neon">R</div>
        <h2>REFA<span>AMIGOS</span></h2>
      </div>
      <nav class="menu">
        <div class="nav-item" :class="{active: seccionActiva==='dashboard'}" @click="seccionActiva='dashboard'">📊 Overview</div>
        <div class="nav-item" :class="{active: seccionActiva==='usuarios'}" @click="seccionActiva='usuarios'">👥 Personal</div>
        <div class="nav-item" :class="{active: seccionActiva==='productos'}" @click="seccionActiva='productos'">📦 Almacén</div>
      </nav>
    </aside>

    <main class="viewport">
      <header class="top-bar" v-if="seccionActiva !== 'dashboard'">
        <input v-model="busqueda" type="text" :placeholder="'Buscar en ' + seccionActiva + '...'" class="glass-input">
        <button class="btn-glow" @click="abrirModal()">+ NUEVO REGISTRO</button>
      </header>

      <div class="table-container shadow-neon" v-if="seccionActiva !== 'dashboard'">
        <p style="color: yellow; font-size: 12px;">DEBUG: Registros en lista: {{ datosFiltrados.length }}</p>
        <table class="main-table">
          <thead>
            <tr v-if="seccionActiva === 'usuarios'">
              <th>NOMBRE</th><th>ROL</th><th>EMAIL</th><th>ACCIONES</th>
            </tr>
            <tr v-else>
              <th>SKU</th><th>PRODUCTO</th><th>MARCA</th><th>VENTA</th><th>ACCIONES</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in datosFiltrados" :key="index">
              <template v-if="seccionActiva === 'usuarios'">
                <td>{{ item.nombre || item.name }}</td>
                <td><span class="badge">{{ item.rol }}</span></td>
                <td colspan="2">{{ item.email }}</td>
              </template>
              <template v-else>
                <td>{{ item.sku || "N/A" }}</td>
                <td>{{ item.nombre }}</td>
                <td>{{ item.marca }}</td>
                <td class="text-green-400 font-bold">${{ item.precio_venta || item.precio }}</td>
              </template>
                <td class="px-4 py-2 flex gap-2 justify-center">
                  <button @click="abrirModal(item)" class="hover:scale-125 transition-all opacity-80 hover:opacity-100">✏️</button>
                  <button @click="eliminar(item._id || item.id)" class="hover:scale-125 transition-all opacity-80 hover:opacity-100">🗑️</button>
                </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div v-else class="welcome-screen">
        <h1>SISTEMA DE GESTIÓN INTEGRAL</h1>
        <p>Conectado a MongoDB Atlas (Cloud) y MariaDB (Local)</p>
      </div>
    </main>

    <div v-if="mostrarModal" class="modal-overlay">
      <div class="modal-card border-neon">
        <h3>{{ modoEdicion ? 'EDITAR' : 'REGISTRAR' }} {{ seccionActiva.toUpperCase() }}</h3>
        
        <div class="form-grid">
          <template v-if="seccionActiva === 'usuarios'">
            <input v-model="form.nombre" placeholder="Nombre Completo" class="neon-input">
            <input v-model="form.email" placeholder="Correo Electrónico" class="neon-input">
            <select v-model="form.rol" class="neon-input">
              <option value="vendedor">Vendedor</option>
              <option value="administrador">Administrador</option>
            </select>
          </template>
          <template v-else>
            <input v-model="form.sku" placeholder="SKU" class="neon-input">
            <input v-model="form.nombre" placeholder="Nombre del Producto" class="neon-input">
            <input v-model="form.precio" type="number" placeholder="Precio" class="neon-input">
          </template>

        </div>

        <div class="modal-footer">
          <button @click="mostrarModal=false" class="btn-cancel">CANCELAR</button>
          <button @click="guardar" class="btn-save">GUARDAR CAMBIOS</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.app-shell { display: flex; height: 100vh; background: #05080f; color: #fff; font-family: 'Inter', sans-serif; }
.sidebar { width: 260px; background: #0f172a; padding: 30px; border-right: 1px solid #1e293b; }
.logo-neon { background: #22d3ee; color: #000; width: 40px; height: 40px; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-weight: 900; box-shadow: 0 0 15px #22d3ee; }
.nav-item { padding: 15px; margin: 10px 0; border-radius: 10px; cursor: pointer; color: #64748b; }
.nav-item.active { background: #22d3ee; color: #000; font-weight: bold; }

.viewport { flex: 1; padding: 40px; overflow-y: auto; }
.top-bar { display: flex; justify-content: space-between; margin-bottom: 30px; }
.glass-input { background: #0f172a; border: 1px solid #1e293b; padding: 12px 20px; border-radius: 25px; color: white; width: 350px; }
.btn-glow { background: #22d3ee; border: none; padding: 12px 25px; border-radius: 25px; font-weight: bold; cursor: pointer; box-shadow: 0 0 15px #22d3ee44; }

.table-container { background: #0f172a; border-radius: 20px; border: 1px solid #1e293b; padding: 10px; }
.main-table { width: 100%; border-collapse: collapse; }
.main-table th { padding: 15px; text-align: left; color: #64748b; font-size: 0.8rem; border-bottom: 1px solid #1e293b; }
.main-table td { padding: 15px; border-bottom: 1px solid #1e293b; }
.bold { color: #22d3ee; font-weight: bold; }
.price { color: #10b981; font-weight: bold; }
.tag { background: rgba(34, 211, 238, 0.1); color: #22d3ee; padding: 4px 8px; border-radius: 6px; font-size: 0.8rem; }

.actions { display: flex; gap: 10px; }
.edit-btn, .del-btn { background: #1e293b; border: none; padding: 8px; border-radius: 8px; cursor: pointer; }
.del-btn:hover { background: #ef4444; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.85); backdrop-filter: blur(5px); display: flex; align-items: center; justify-content: center; z-index: 100; }
.modal-card { background: #0f172a; width: 450px; padding: 30px; border-radius: 20px; border: 1px solid #22d3ee; }
.form-grid { display: flex; flex-direction: column; gap: 15px; margin: 20px 0; }
.form-grid input, .form-grid select { background: #05080f; border: 1px solid #1e293b; padding: 12px; border-radius: 10px; color: white; }
.modal-footer { display: flex; gap: 10px; }
.btn-save { flex: 1; background: #22d3ee; border: none; padding: 12px; border-radius: 10px; font-weight: bold; cursor: pointer; }
.btn-cancel { flex: 1; background: #334155; border: none; padding: 12px; border-radius: 10px; color: white; cursor: pointer; }
</style>
