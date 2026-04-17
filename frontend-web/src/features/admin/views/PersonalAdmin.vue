<script setup>
import { ref, computed, onMounted } from "vue";
import axios from 'axios';
import UserFormModal from '../modals/UserFormModal.vue';

const busqueda = ref("");
const usuarios = ref([]);
const mostrarModal = ref(false);
const modoEdicion = ref(false);
const itemSeleccionado = ref(null);
const form = ref({});

// Concatenamos la URL base de Node con el endpoint de auth
const API_USER = `${import.meta.env.VITE_API_URL_NOSQL}/auth`;

const cargarUsuarios = async () => {
  try {
    const resU = await axios.get(API_USER);
    usuarios.value = resU.data;
  } catch (e) { console.error("Error al cargar usuarios:", e); }
};

const abrirModal = (item = null) => {
  itemSeleccionado.value = item;
  modoEdicion.value = !!item;
  form.value = item ? { ...item, nombre_rol: item.id_rol?.nombre_rol || 'Vendedor' } 
                    : { nombre: '', email: '', password: '', nombre_rol: 'Vendedor' };
  mostrarModal.value = true;
};

const guardar = async () => {
  try {
    if (modoEdicion.value) {
      await axios.put(`${API_USER}/${itemSeleccionado.value._id}`, form.value);
    } else {
      await axios.post(`${API_USER}/register`, form.value);
    }
    await cargarUsuarios();
    mostrarModal.value = false;
  } catch (e) { alert("Error en la operación."); }
};

const eliminar = async (id) => {
  if (!confirm("¿Confirmas la eliminación definitiva?")) return;
  try {
    await axios.delete(`${API_USER}/${id}`);
    await cargarUsuarios();
  } catch (e) { alert("Error al eliminar."); }
};

const datosFiltrados = computed(() => {
  return usuarios.value.filter(i => (i.nombre || "").toLowerCase().includes(busqueda.value.toLowerCase()));
});

onMounted(cargarUsuarios);
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <input v-model="busqueda" type="text" placeholder="Buscar usuarios..." class="glass-input">
      <button class="btn-glow" @click="abrirModal()">+ NUEVO USUARIO</button>
    </header>

    <div class="table-container shadow-neon">
      <table class="main-table">
        <thead>
          <tr>
            <th>NOMBRE</th><th>ROL</th><th>EMAIL</th><th>ACCIONES</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="item in datosFiltrados" :key="item._id">
            <td class="bold">{{ item.nombre }}</td>
            <td><span class="tag">{{ item.id_rol?.nombre_rol || 'Staff' }}</span></td>
            <td>{{ item.email }}</td>
            <td class="actions">
              <button class="edit-btn" @click="abrirModal(item)">✏️</button>
              <button class="del-btn" @click="eliminar(item._id)">🗑️</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <UserFormModal 
      v-if="mostrarModal" 
      :form="form" 
      :modoEdicion="modoEdicion" 
      @guardar="guardar" 
      @cerrar="mostrarModal = false" 
    />
  </div>
</template>

<style scoped>
.view-container { display: flex; flex-direction: column; gap: 30px; animation: fadeIn 0.4s ease-out; width: 100%; box-sizing: border-box; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

.top-bar { display: flex; justify-content: space-between; }
.glass-input { background: rgba(15, 23, 42, 0.6); border: 1px solid rgba(0, 210, 255, 0.3); padding: 12px 20px; border-radius: 25px; color: white; width: 350px; transition: all 0.3s; }
.glass-input:focus { border-color: #00d2ff; outline: none; box-shadow: 0 0 10px rgba(0, 210, 255, 0.2); }
.btn-glow { background: #00d2ff; color: #000; border: none; padding: 12px 25px; border-radius: 25px; font-weight: bold; cursor: pointer; box-shadow: 0 0 15px rgba(0, 210, 255, 0.4); transition: all 0.3s; }
.btn-glow:hover { transform: translateY(-2px); box-shadow: 0 5px 20px rgba(0, 210, 255, 0.6); }

.table-container { width: 100%; box-sizing: border-box; background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); border-radius: 20px; border: 1px solid rgba(0, 210, 255, 0.2); padding: 10px; }
.main-table { width: 100%; border-collapse: collapse; }
.main-table th { padding: 15px; text-align: left; color: #8ba3cb; font-size: 0.8rem; border-bottom: 1px solid rgba(0, 210, 255, 0.1); letter-spacing: 1px; }
.main-table td { padding: 15px; border-bottom: 1px solid rgba(0, 210, 255, 0.05); color: #e2e8f0; }
.main-table tr { transition: background 0.3s; }
.main-table tr:hover { background: rgba(0, 210, 255, 0.05); }
.bold { color: #00d2ff; font-weight: bold; }
.tag { background: rgba(0, 210, 255, 0.1); color: #00d2ff; padding: 6px 10px; border-radius: 8px; font-size: 0.8rem; border: 1px solid rgba(0, 210, 255, 0.2); }

.actions { display: flex; gap: 10px; }
.edit-btn, .del-btn { background: rgba(30, 41, 59, 0.8); border: 1px solid transparent; padding: 8px; border-radius: 8px; cursor: pointer; transition: all 0.2s; }
.edit-btn:hover { border-color: #00d2ff; background: rgba(0, 210, 255, 0.1); }
.del-btn:hover { border-color: #ef4444; background: rgba(239, 68, 68, 0.1); }
</style>
