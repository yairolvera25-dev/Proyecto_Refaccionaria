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

    <div class="table-container shadow-neon">
      <div class="table-wrap">
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
              <td class="price">$ {{ Number(venta.total || 0).toFixed(2) }}</td>
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
  gap: 24px;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box; /* 👈 Evita desbordamiento */
  animation: fadeIn 0.4s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.top-bar {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

/* --- FILTROS (FECHAS) --- */
.filters {
  display: flex;
  gap: 12px;
  flex-wrap: wrap; /* 👈 Permite que los inputs bajen si no caben */
  width: 100%;
}

.glass-input {
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.3);
  padding: 12px 16px;
  border-radius: 12px;
  color: white;
  color-scheme: dark; /* 👈 Hace que el calendario nativo sea oscuro */
  box-sizing: border-box;
}

.glass-input:focus {
  border-color: #00d2ff;
  outline: none;
  box-shadow: 0 0 10px rgba(0, 210, 255, 0.2);
}

.btn-action {
  border: none;
  border-radius: 10px;
  padding: 10px 14px;
  font-weight: 700;
  cursor: pointer;
  transition: all 0.3s;
}

.btn-new {
  background: #00ff88;
  color: #03131d;
}

.btn-new:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 15px rgba(0, 255, 136, 0.3);
}

/* --- TARJETAS DE ESTADÍSTICAS --- */
.stats {
  display: flex;
  gap: 16px;
  flex-wrap: wrap; /* 👈 Permite que se apilen en móvil */
}

.card-stat {
  flex: 1; /* 👈 Hace que crezcan parejo */
  min-width: 150px;
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.2);
  border-radius: 16px;
  padding: 16px;
  color: white;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.card-stat strong {
  font-size: 1.5rem;
  color: #00d2ff;
}

.label {
  display: block;
  color: #8ba3cb;
  margin-bottom: 8px;
  font-size: 0.9rem;
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* --- TABLA Y SCROLL RESPONSIVO --- */
.table-container {
  width: 100%;
  box-sizing: border-box;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border: 1px solid rgba(0, 210, 255, 0.2);
  padding: 10px;
}

.table-wrap {
  width: 100%;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch; /* 👈 Scroll suave táctil */
}

.main-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 650px; /* 👈 Fuerza el scroll si la pantalla es menor a 650px */
}

.main-table th,
.main-table td {
  padding: 15px;
  text-align: left;
  color: #e2e8f0;
  border-bottom: 1px solid rgba(0, 210, 255, 0.08);
  white-space: nowrap; /* 👈 Evita que las fechas se partan en 2 renglones */
}

.main-table th {
  color: #8ba3cb;
  font-size: 0.85rem;
  letter-spacing: 1px;
}

.main-table tr:hover {
  background: rgba(0, 210, 255, 0.05);
}

.price {
  color: #10b981;
  font-weight: bold;
}

.empty-cell {
  text-align: center;
  color: #94a3b8;
  padding: 30px !important;
}

/* --- MEDIA QUERIES PARA CELULAR --- */
@media (max-width: 768px) {
  .glass-input {
    width: 100%; /* 👈 Inputs toman todo el ancho */
  }
  
  .btn-new {
    width: 100%; /* 👈 Botón toma todo el ancho */
    padding: 15px;
  }
  
  .card-stat {
    min-width: 100%; /* 👈 Tarjetas se apilan una arriba de la otra */
  }
}
</style>