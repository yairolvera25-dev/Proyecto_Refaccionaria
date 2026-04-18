<script setup>
import { ref, onMounted } from "vue";
import axios from 'axios';

const proveedores = ref([]);

// ✅ CORREGIDO: URL limpia para MongoDB Atlas
const API_URL = `${import.meta.env.VITE_API_URL_NOSQL}/proveedores`;

const cargarProveedores = async () => {
  try {
    const res = await axios.get(API_URL);
    proveedores.value = res.data;
  } catch (e) {
    console.error("Error al cargar proveedores:", e);
  }
};

onMounted(cargarProveedores);
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <div class="title-group">
        <h2 class="neon-title">DIRECTORIO DE PROVEEDORES</h2>
        <p class="count-tag">{{ proveedores.length }} Socios comerciales registrados</p>
      </div>
    </header>

    <div class="table-container shadow-neon">
      <table class="main-table">
        <thead>
          <tr>
            <th>EMPRESA</th>
            <th>CONTACTO</th>
            <th>EMAIL</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="p in proveedores" :key="p._id">
            <td class="bold">{{ p.nombre_empresa }}</td>
            <td>{{ p.contacto }}</td>
            <td class="email-link">{{ p.email }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.view-container { display: flex; flex-direction: column; gap: 20px; animation: fadeIn 0.4s ease-out; }
.neon-title { color: #fff; text-shadow: 0 0 10px #a855f7; margin: 0; }
.count-tag { color: #8ba3cb; font-size: 0.8rem; }
.table-container { background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(10px); border-radius: 20px; border: 1px solid rgba(168, 85, 247, 0.2); overflow: hidden; padding: 10px; }
.main-table { width: 100%; border-collapse: collapse; }
.main-table th { padding: 15px; text-align: left; color: #a855f7; font-size: 0.75rem; background: rgba(168, 85, 247, 0.05); }
.main-table td { padding: 15px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); color: #fff; }
.bold { color: #d8b4fe; font-weight: bold; }
.email-link { color: #3a7bd5; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
</style>