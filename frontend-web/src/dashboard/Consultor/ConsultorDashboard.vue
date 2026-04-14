<template>
  <div class="dashboard-root" :class="{ 'is-loading': isRefreshing }">
    
    <header class="top-header">
      <div class="brand">
        <span class="brand-subtitle">REFACCIONARIA</span>
        <h1 class="brand-title">LOS AMIGOS CORE</h1>
      </div>
      <div class="header-actions">
        <button class="icon-btn" @click="showNotifications = true">
          <i class="icon">🔔</i>
          <span v-if="criticosCount > 0" class="badge-red">{{ criticosCount }}</span>
        </button>

        <button class="logout-btn" @click="cerrarSesion" title="Cerrar Sesión">
          <span class="logout-icon">Logout</span>
          <i class="icon">🚪</i>
        </button>
      </div>
    </header>

    <TopStats :items="inventory" />
    
    <TopStockChart 
      :items="inventory" 
      @selectProduct="openProductDetails" 
    />
    
    <InventoryList 
      :items="inventory" 
      @selectProduct="openProductDetails"
    />

    <div class="fab-container">
      <button class="fab-mini" @click="showExport = true" title="Exportar Reporte">
        📊
      </button>
      
      <button 
        class="fab-main" 
        @click="cargarDatos" 
        :class="{ 'btn-loading': isRefreshing }"
      >
        <span v-if="!isRefreshing" class="fab-text">ACTUALIZAR ↻</span>
        <span v-else class="fab-text">CARGANDO...</span>
      </button>
    </div>

    <ActionModals 
      :showNotifs="showNotifications" 
      :showExport="showExport" 
      :selectedItem="selectedItem"
      :items="inventory"
      @closeAll="closeModals" 
      @doExport="ejecutarExportacion"
    />

    <div v-if="isRefreshing" class="refresh-overlay">
      <div class="loader-content">
        <div class="spinner"></div>
        <p>Sincronizando con Atlas...</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router'; // Para la redirección del botón salir

// IMPORTACIÓN DE COMPONENTES DE INTERFAZ
import TopStats from '../../components/ConsultorUI/TopStats.vue';
import TopStockChart from '../../components/ConsultorUI/TopStockChart.vue';
import InventoryList from '../../components/ConsultorUI/InventoryList.vue';
import ActionModals from '../../components/ConsultorUI/ActionModals.vue';

// LÓGICA DE EXPORTACIÓN A EXCEL Y PDF
import { generarPDF, generarExcel } from '../../utils/exportData.js';

// Inicializamos el enrutador
const router = useRouter();

// ESTADOS REACTIVOS
const inventory = ref([]);
const isRefreshing = ref(false);
const showNotifications = ref(false);
const showExport = ref(false);
const selectedItem = ref(null);

// Lógica para cerrar sesión y volver a la raíz
const cerrarSesion = () => {
  console.log("Cerrando sesión...");
  router.push('/'); 
};

// Contador dinámico para la campana de alertas
const criticosCount = computed(() => {
  return inventory.value.filter(i => i.cantidad < 5).length;
});

// Control de ventanas emergentes
const openProductDetails = (product) => {
  selectedItem.value = product;
};

const closeModals = () => {
  showNotifications.value = false;
  showExport.value = false;
  selectedItem.value = null;
};

// Ejecución de descarga de archivos
const ejecutarExportacion = (tipo) => {
  if (inventory.value.length === 0) return;
  
  if (tipo === 'pdf') {
    generarPDF(inventory.value);
  } else {
    generarExcel(inventory.value);
  }
  closeModals();
};

/**
 * ─── ESCÁNER PROFUNDO ───
 * Busca una propiedad dentro de un objeto, sin importar qué tan profundo esté.
 * Esto soluciona el problema de los productos "SIN NOMBRE".
 */
const buscarDatoProfundo = (obj, posiblesNombres) => {
  if (!obj || typeof obj !== 'object') return null;

  // Intenta encontrar la llave en el nivel actual
  for (let key of posiblesNombres) {
    if (obj[key] !== undefined && obj[key] !== null && obj[key] !== '') {
      return obj[key];
    }
  }

  // Si no está, busca recursivamente en los hijos (arreglos o sub-objetos)
  for (let key in obj) {
    if (typeof obj[key] === 'object') {
      let encontrado = buscarDatoProfundo(obj[key], posiblesNombres);
      if (encontrado) return encontrado;
    }
  }
  return null;
};

/**
 * CARGAR DATOS
 * Se conecta a tu API de Node.js y mapea los resultados usando el Escáner.
 */
const cargarDatos = async () => {
  isRefreshing.value = true;
  const apiUrl = import.meta.env.VITE_API_URL_NOSQL || 'http://localhost:4000/api';
  
  try {
    const response = await fetch(`${apiUrl}/ventas`);
    if (response.ok) {
      const rawData = await response.json();
      
      // Estandarizamos los datos para que InventoryList pueda filtrarlos
      inventory.value = rawData.map(item => {
        const nombre = buscarDatoProfundo(item, ['nombre_pieza', 'producto', 'nombre', 'descripcion']);
        const sku = buscarDatoProfundo(item, ['sku', 'codigo', 'id_sku']);
        const qty = buscarDatoProfundo(item, ['cantidad', 'stock', 'existencia', 'cantidad_disponible']);
        const precio = buscarDatoProfundo(item, ['precio', 'precio_unitario', 'costo', 'total']);

        return {
          ...item,
          nombreOriginal: nombre || 'PIEZA SIN NOMBRE',
          sku: sku || 'REF-XXXX',
          cantidad: parseInt(qty) || 0,
          precio: parseFloat(precio) || 0
        };
      });
    }
  } catch (error) {
    console.error("Error al conectar con el backend:", error);
  } finally {
    // Pequeño retardo para suavizar la animación de carga
    setTimeout(() => {
      isRefreshing.value = false;
    }, 1000);
  }
};

onMounted(cargarDatos);
</script>

<style scoped>
.dashboard-root {
  min-height: 100vh;
  background-color: #0D0F14;
  color: #FFFFFF;
  padding: 20px;
  padding-bottom: 130px; /* Espacio para que el botón flotante no tape los datos */
  font-family: 'Segoe UI', system-ui, sans-serif;
  transition: opacity 0.3s ease;
  position: relative;
}

.is-loading {
  opacity: 0.6;
  pointer-events: none; /* Bloquea clics mientras carga */
}

/* HEADER */
.top-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 25px;
}

.brand-subtitle {
  font-size: 0.65rem;
  color: rgba(255, 255, 255, 0.3);
  letter-spacing: 4px;
  display: block;
}

.brand-title {
  margin: 0;
  font-size: 1.7rem;
  color: #39FF14;
  font-weight: 900;
  text-shadow: 0 0 20px rgba(57, 255, 20, 0.2);
}

/* CONTENEDOR DE BOTONES DE CABECERA */
.header-actions {
  display: flex;
  gap: 12px;
  align-items: center;
}

/* BOTÓN DE NOTIFICACIONES */
.icon-btn {
  background: #1A1D24;
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 50%;
  width: 48px;
  height: 48px;
  color: #39FF14;
  cursor: pointer;
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.3rem;
  transition: all 0.2s;
}

.icon-btn:hover {
  background: #232730;
  border-color: #39FF14;
}

/* ESTILOS DEL NUEVO BOTÓN DE SALIR */
.logout-btn {
  background: #1A1D24; 
  border: 1px solid rgba(255, 255, 255, 0.1);
  border-radius: 30px; 
  padding: 0 15px; 
  height: 48px; 
  color: #FF5252;
  cursor: pointer; 
  display: flex; 
  align-items: center; 
  justify-content: center; 
  gap: 8px;
  transition: all 0.2s;
}
.logout-btn:hover { background: #2a1a1a; border-color: #FF5252; }
.logout-icon { font-size: 0.75rem; font-weight: bold; letter-spacing: 1px; }

.badge-red {
  position: absolute;
  top: -2px;
  right: -2px;
  background: #FF5252;
  color: white;
  font-size: 0.7rem;
  font-weight: bold;
  padding: 2px 6px;
  border-radius: 10px;
  border: 2px solid #0D0F14;
}

/* BOTONES FLOTANTES (FAB) */
.fab-container {
  position: fixed;
  bottom: 30px;
  right: 30px;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 15px;
  z-index: 999;
}

.fab-mini {
  background: #1A1D24;
  color: #39FF14;
  border: 1px solid rgba(57, 255, 20, 0.4);
  width: 50px;
  height: 50px;
  border-radius: 50%;
  cursor: pointer;
  font-size: 1.3rem;
  box-shadow: 0 5px 15px rgba(0,0,0,0.3);
  transition: transform 0.2s, background 0.2s;
}

.fab-mini:hover { transform: scale(1.1); background: #232730; }

.fab-main {
  background: #39FF14;
  color: #000;
  border: none;
  padding: 15px 35px;
  border-radius: 35px;
  font-weight: 900;
  font-size: 0.9rem;
  letter-spacing: 1px;
  cursor: pointer;
  box-shadow: 0 10px 25px rgba(57, 255, 20, 0.3);
  min-width: 180px;
  transition: all 0.2s ease;
}

.fab-main:hover { transform: translateY(-3px); box-shadow: 0 15px 30px rgba(57, 255, 20, 0.5); }

.btn-loading {
  background: #1f8a0d;
  color: rgba(255,255,255,0.8);
  cursor: not-allowed;
  transform: scale(0.98);
}

/* OVERLAY DE CARGA */
.refresh-overlay {
  position: fixed;
  top: 0; left: 0; right: 0; bottom: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 2000;
  background: rgba(0,0,0,0.4);
}

.loader-content {
  background: #1A1D24;
  padding: 30px;
  border-radius: 20px;
  text-align: center;
  border: 1px solid #39FF14;
  box-shadow: 0 0 30px rgba(57, 255, 20, 0.2);
}

.spinner {
  width: 40px;
  height: 40px;
  border: 4px solid rgba(57, 255, 20, 0.1);
  border-left-color: #39FF14;
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
  margin: 0 auto 15px;
}

@keyframes spin { to { transform: rotate(360deg); } }
</style>