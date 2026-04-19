<script setup>
import { ref } from "vue";
import axios from "axios";

const fechaInicio = ref("");
const fechaFin = ref("");
const cargando = ref(false);
const ventas = ref([]);
const totalVentas = ref(0);
const totalRegistros = ref(0);

const API_REPORTES = `${import.meta.env.VITE_API_URL_NOSQL}/ventas/reporte`;

const consultarReporte = async () => {
  if (!fechaInicio.value || !fechaFin.value) {
    alert("Selecciona fecha inicial y final");
    return;
  }

  try {
    cargando.value = true;
    const res = await axios.get(API_REPORTES, {
      params: {
        fechaInicio: fechaInicio.value,
        fechaFin: fechaFin.value
      }
    });

    ventas.value = res.data.ventas || [];
    totalVentas.value = res.data.totalVentas || 0;
    totalRegistros.value = res.data.totalRegistros || 0;
  } catch (error) {
    console.error("Error al consultar reporte:", error);
    ventas.value = [];
    totalVentas.value = 0;
    totalRegistros.value = 0;
    alert(error?.response?.data?.msg || "Error al consultar reporte");
  } finally {
    cargando.value = false;
  }
};
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <div class="filters">
        <input v-model="fechaInicio" type="date" class="glass-input" />
        <input v-model="fechaFin" type="date" class="glass-input" />
        <button class="btn-action btn-new" @click="consultarReporte">
          Consultar
        </button>
      </div>
    </header>

    <div class="stats">
      <div class="card-stat">
        <span class="label">Registros</span>
        <strong>{{ totalRegistros }}</strong>
      </div>
      <div class="card-stat">
        <span class="label">Total vendido</span>
        <strong>$ {{ Number(totalVentas).toFixed(2) }}</strong>
      </div>
    </div>

    <div class="table-container">
      <table class="main-table">
        <thead>
          <tr>
            <th>FOLIO</th>
            <th>FECHA</th>
            <th>CLIENTE</th>
            <th>VENDEDOR</th>
            <th>TOTAL</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="!ventas.length">
            <td colspan="5" class="empty-cell">
              {{ cargando ? "Cargando reporte..." : "No hay ventas para mostrar" }}
            </td>
          </tr>

          <tr v-for="venta in ventas" :key="venta._id">
            <td>{{ venta.folio || venta._id }}</td>
            <td>{{ venta.fecha_formateada || venta.createdAt }}</td>
            <td>{{ venta.cliente_nombre || "-" }}</td>
            <td>{{ venta.vendedor_nombre || "-" }}</td>
            <td>$ {{ Number(venta.total || 0).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.view-container {
  display: flex;
  flex-direction: column;
  gap: 24px;
  width: 100%;
}
.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.filters {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}
.glass-input {
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.3);
  padding: 12px 16px;
  border-radius: 12px;
  color: white;
}
.btn-action {
  border: none;
  border-radius: 10px;
  padding: 10px 14px;
  font-weight: 700;
  cursor: pointer;
}
.btn-new {
  background: #00ff88;
  color: #03131d;
}
.stats {
  display: flex;
  gap: 16px;
  flex-wrap: wrap;
}
.card-stat {
  min-width: 180px;
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.2);
  border-radius: 16px;
  padding: 16px;
  color: white;
}
.label {
  display: block;
  color: #8ba3cb;
  margin-bottom: 8px;
}
.table-container {
  width: 100%;
  background: rgba(15, 23, 42, 0.6);
  border-radius: 20px;
  border: 1px solid rgba(0, 210, 255, 0.2);
  padding: 10px;
}
.main-table {
  width: 100%;
  border-collapse: collapse;
}
.main-table th,
.main-table td {
  padding: 15px;
  text-align: left;
  color: #e2e8f0;
  border-bottom: 1px solid rgba(0, 210, 255, 0.08);
}
.main-table th {
  color: #8ba3cb;
}
.empty-cell {
  text-align: center;
  color: #94a3b8;
}
</style>
