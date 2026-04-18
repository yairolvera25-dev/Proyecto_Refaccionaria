<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";

const busqueda = ref("");
const productos = ref([]);

const API_PROD = `${import.meta.env.VITE_API_URL_SQL}/productos`;

const cargarProductos = async () => {
  try {
    const res = await axios.get(API_PROD);
    productos.value = res.data;
  } catch (error) {
    console.error("Error al cargar productos:", error);
  }
};

const datosFiltrados = computed(() => {
  return productos.value.filter((item) =>
    `${item.nombre || ""} ${item.sku || ""}`.toLowerCase().includes(busqueda.value.toLowerCase())
  );
});

onMounted(cargarProductos);
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <input
        v-model="busqueda"
        type="text"
        placeholder="Buscar refacciones..."
        class="glass-input"
      >
    </header>

    <div class="table-container shadow-neon">
      <div class="overflow-x-auto w-full">
        <table class="main-table">
          <thead>
            <tr>
              <th>SKU</th>
              <th>PRODUCTO</th>
              <th>MARCA</th>
              <th>CATEGORÍA</th>
              <th>PROVEEDOR</th>
              <th>VENTA</th>
              <th>STOCK</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="item in datosFiltrados" :key="item.id">
              <td class="sku-text">{{ item.sku }}</td>
              <td class="bold">{{ item.nombre }}</td>
              <td>{{ item.marca?.nombre_marca || '-' }}</td>
              <td>{{ item.categoria?.nombre || '-' }}</td>
              <td>{{ item.proveedor?.nombre_empresa || '-' }}</td>
              <td class="price">$ {{ item.precio_venta }}</td>
              <td>{{ item.stock }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
.view-container {
  display: flex;
  flex-direction: column;
  gap: 30px;
  animation: fadeIn 0.4s ease-out;
  width: 100%;
  box-sizing: border-box;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.top-bar {
  display: flex;
  justify-content: space-between;
}

.glass-input {
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.3);
  padding: 12px 20px;
  border-radius: 25px;
  color: white;
  width: 350px;
  transition: all 0.3s;
}

.glass-input:focus {
  border-color: #00d2ff;
  outline: none;
  box-shadow: 0 0 10px rgba(0, 210, 255, 0.2);
}

.table-container {
  width: 100%;
  box-sizing: border-box;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border: 1px solid rgba(0, 210, 255, 0.2);
  padding: 10px;
}

.main-table {
  width: 100%;
  border-collapse: collapse;
}

.main-table th {
  padding: 15px;
  text-align: left;
  color: #8ba3cb;
  font-size: 0.8rem;
  border-bottom: 1px solid rgba(0, 210, 255, 0.1);
  letter-spacing: 1px;
}

.main-table td {
  padding: 15px;
  border-bottom: 1px solid rgba(0, 210, 255, 0.05);
  color: #e2e8f0;
}

.main-table tr {
  transition: background 0.3s;
}

.main-table tr:hover {
  background: rgba(0, 210, 255, 0.05);
}

.bold {
  color: #00d2ff;
  font-weight: bold;
}

.sku-text {
  color: #94a3b8;
  font-family: monospace;
}

.price {
  color: #10b981;
  font-weight: bold;
}
</style>

