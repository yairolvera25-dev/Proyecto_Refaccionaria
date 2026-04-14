<script setup>
import { ref, computed, onMounted } from "vue";
import axios from 'axios';

const seccionActiva = ref("dashboard");
const busqueda = ref("");
const usuarios = ref([]);
const productos = ref([]);
const mostrarModal = ref(false);
const modoEdicion = ref(false);
const itemSeleccionado = ref(null);

// Formulario único reactivo
const form = ref({});

const API_USER = 'http://localhost:4000/api/auth';
const API_PROD = 'http://localhost:8000/api/productos';

const cargarTodo = async () => {
  try {
    const [resU, resP] = await Promise.all([
      axios.get(API_USER),
      axios.get(API_PROD)
    ]);
    usuarios.value = resU.data;
    productos.value = resP.data;
  } catch (e) { console.error("Error de sincronización:", e); }
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
    if (seccionActiva.value === 'usuarios') {
      if (modoEdicion.value) {
        await axios.put(`${API_USER}/${itemSeleccionado.value._id}`, form.value);
      } else {
        await axios.post(`${API_USER}/register`, form.value);
      }
    } else {
      if (modoEdicion.value) {
        await axios.put(`${API_PROD}/${itemSeleccionado.value.id}`, form.value);
      } else {
        await axios.post(API_PROD, form.value);
      }
    }
    await cargarTodo();
    mostrarModal.value = false;
  } catch (e) { alert("Error en la operación. Revisa los servicios."); }
};

const eliminar = async (id) => {
  if (!confirm("¿Confirmas la eliminación definitiva?")) return;
  try {
    const url = seccionActiva.value === 'usuarios' ? `${API_USER}/${id}` : `${API_PROD}/${id}`;
    await axios.delete(url);
    await cargarTodo();
  } catch (e) { alert("Error al eliminar."); }
};

const datosFiltrados = computed(() => {
  const lista = seccionActiva.value === 'usuarios' ? usuarios.value : productos.value;
  return lista.filter(i => (i.nombre || i.sku || "").toLowerCase().includes(busqueda.value.toLowerCase()));
});

onMounted(cargarTodo);
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
            <tr v-for="item in datosFiltrados" :key="item._id || item.id">
              <template v-if="seccionActiva === 'usuarios'">
                <td class="bold">{{ item.nombre }}</td>
                <td><span class="tag">{{ item.id_rol?.nombre_rol || 'Staff' }}</span></td>
                <td>{{ item.email }}</td>
              </template>
              <template v-else>
                <td class="sku-text">{{ item.sku }}</td>
                <td class="bold">{{ item.nombre }}</td>
                <td>{{ item.marca }}</td>
                <td class="price">$ {{ item.precio_venta }}</td>
              </template>
              <td class="actions">
                <button class="edit-btn" @click="abrirModal(item)">✏️</button>
                <button class="del-btn" @click="eliminar(item._id || item.id)">🗑️</button>
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
            <input v-model="form.nombre" placeholder="Nombre completo">
            <input v-model="form.email" placeholder="Correo electrónico">
            <input v-if="!modoEdicion" v-model="form.password" type="password" placeholder="Contraseña">
            <select v-model="form.nombre_rol">
              <option value="Administrador">Administrador</option>
              <option value="Vendedor">Vendedor</option>
            </select>
          </template>

          <template v-else>
            <input v-model="form.sku" placeholder="SKU (Ej. FR-001)">
            <input v-model="form.nombre" placeholder="Nombre de refacción">
            <input v-model="form.marca" placeholder="Marca">
            <input v-model="form.precio_venta" type="number" placeholder="Precio Venta">
            <input v-model="form.stock_minimo" type="number" placeholder="Stock Mínimo">
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
