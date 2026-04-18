<script setup>
import { ref, onMounted, computed } from 'vue';
import axios from 'axios';

const ventas = ref([]);
const filtroFecha = ref("");

// ✅ URL CORREGIDA MANUALMENTE
const API_VENTAS = `${import.meta.env.VITE_API_URL_NOSQL}/ventas`;

const cargarVentas = async () => {
  try {
    const res = await axios.get(API_VENTAS);
    ventas.value = res.data;
  } catch (e) {
    console.error("Error al cargar historial:", e);
  }
};

const ventasFiltradas = computed(() => {
  if (!filtroFecha.value) return ventas.value;
  return ventas.value.filter(v => v.fecha_hora && v.fecha_hora.startsWith(filtroFecha.value));
});

const ingresosTotales = computed(() => {
  return ventasFiltradas.value.reduce((acc, v) => acc + parseFloat(v.total_venta || 0), 0);
});

onMounted(cargarVentas);
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <div class="title-group">
        <h2 class="neon-title">AUDITORÍA DE VENTAS</h2>
        <p class="money-total">Ingresos: <span>$ {{ ingresosTotales.toFixed(2) }}</span></p>
      </div>
      <div class="filter-box">
        <label>Fecha:</label>
        <input type="date" v-model="filtroFecha" class="glass-input">
      </div>
    </header>

    <div class="table-container shadow-neon">
      <table class="main-table">
        <thead>
          <tr>
            <th>TICKET</th>
            <th>FECHA / HORA</th>
            <th>VENDEDOR</th>
            <th>PRODUCTOS</th>
            <th>TOTAL</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="v in ventasFiltradas" :key="v._id">
            <td class="id-text">#{{ v._id.slice(-6).toUpperCase() }}</td>
            <td class="time-text">{{ v.fecha_hora ? new Date(v.fecha_hora).toLocaleString() : 'S/F' }}</td>
            <td class="bold">User: {{ v.id_vendedor?.slice(-4) || 'Admin' }}</td>
            <td>
              <div class="p-list">
                <span v-for="(p, i) in v.productos_vendidos" :key="i" class="p-tag">
                   ID: {{ p.id_producto?.slice(-4) }} ({{ p.cantidad }}pza)
                </span>
              </div>
            </td>
            <td class="price">$ {{ parseFloat(v.total_venta || 0).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.neon-title { color: #fff; text-shadow: 0 0 10px #00ff88; margin: 0; }
.money-total span { color: #00ff88; font-weight: bold; font-size: 1.5rem; }
.top-bar { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px; }
.glass-input { background: rgba(30, 41, 59, 0.7); border: 1px solid #00ff88; color: white; padding: 8px; border-radius: 8px; }
.table-container { background: rgba(15, 23, 42, 0.8); border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 15px; padding: 20px; }
.main-table { width: 100%; border-collapse: collapse; color: white; }
.main-table th { color: #00ff88; text-align: left; padding: 12px; border-bottom: 2px solid rgba(0,255,136,0.1); }
.main-table td { padding: 12px; border-bottom: 1px solid rgba(255,255,255,0.05); }
.p-tag { background: rgba(0, 210, 255, 0.1); color: #00d2ff; padding: 2px 5px; border-radius: 4px; font-size: 0.7rem; margin-right: 5px; }
.price { font-weight: bold; color: #00ff88; }
.id-text { color: #64748b; font-family: monospace; }
</style>