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
      <div class="table-wrap">
        <table class="main-table">
          <thead>
            <tr>
              <th>EMPRESA</th>
              <th>CONTACTO</th>
              <th>EMAIL</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="!proveedores.length">
              <td colspan="3" style="text-align: center; padding: 20px; color: #8ba3cb;">
                No hay proveedores registrados aún.
              </td>
            </tr>
            <tr v-for="p in proveedores" :key="p._id">
              <td class="bold">{{ p.nombre_empresa }}</td>
              <td>{{ p.contacto }}</td>
              <td class="email-link">{{ p.email }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* --- CONTENEDORES PRINCIPALES --- */
.view-container { 
  display: flex; 
  flex-direction: column; 
  gap: 20px; 
  animation: fadeIn 0.4s ease-out; 
  width: 100%;
  max-width: 100%;
  box-sizing: border-box; /* 👈 Evita que se desborde */
}

.top-bar {
  margin-bottom: 10px;
}

.neon-title { 
  color: #fff; 
  text-shadow: 0 0 10px #a855f7; 
  margin: 0; 
}

.count-tag { 
  color: #8ba3cb; 
  font-size: 0.8rem; 
  margin-top: 5px;
}

/* --- TABLA Y SCROLL RESPONSIVO --- */
.table-container { 
  background: rgba(15, 23, 42, 0.6); 
  backdrop-filter: blur(10px); 
  border-radius: 20px; 
  border: 1px solid rgba(168, 85, 247, 0.2); 
  overflow: hidden; 
  padding: 10px; 
  width: 100%;
  box-sizing: border-box;
}

/* 👈 NUEVO: Clase para habilitar el deslizamiento táctil */
.table-wrap {
  width: 100%;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
}

.main-table { 
  width: 100%; 
  border-collapse: collapse; 
  min-width: 500px; /* 👈 Asegura que los correos no apachurren el diseño */
}

.main-table th { 
  padding: 15px; 
  text-align: left; 
  color: #a855f7; 
  font-size: 0.75rem; 
  background: rgba(168, 85, 247, 0.05); 
  white-space: nowrap;
}

.main-table td { 
  padding: 15px; 
  border-bottom: 1px solid rgba(255, 255, 255, 0.05); 
  color: #fff; 
}

.bold { 
  color: #d8b4fe; 
  font-weight: bold; 
}

.email-link { 
  color: #3a7bd5; 
}

@keyframes fadeIn { 
  from { opacity: 0; transform: translateY(10px); } 
  to { opacity: 1; transform: translateY(0); } 
}

/* --- AJUSTES EXTRA PARA MÓVILES --- */
@media (max-width: 768px) {
  .neon-title {
    font-size: 1.5rem; /* Título un poco más pequeño en celular */
  }
  .table-container {
    padding: 5px;
  }
}
</style>