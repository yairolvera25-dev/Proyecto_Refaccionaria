<template>
  <div class="flex flex-col gap-6 sm:gap-10 animate-fade-in w-full">
    
    <section class="w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 sm:gap-8">
      <div v-for="kpi in kpis" :key="kpi.label" 
        class="bg-[#0c1215] p-5 sm:p-8 rounded-[1.5rem] sm:rounded-[2rem] border border-[#ffffff]/5 shadow-2xl hover:border-[#00ff88]/50 transition-all group relative overflow-hidden">
        <div class="absolute -top-2 -right-2 w-8 h-8 bg-[#00ff88]/10 rounded-full blur-xl group-hover:bg-[#00ff88]/30 transition-all"></div>
        
        <p class="text-[10px] sm:text-[11px] uppercase font-black text-[#819da7] mb-2 sm:mb-3 tracking-[0.2em]">{{ kpi.label }}</p>
        <p :class="['text-3xl sm:text-4xl font-mono font-black mb-1 sm:mb-2 drop-shadow-[0_0_10px_rgba(0,255,136,0.2)]', kpi.color]">{{ kpi.value }}</p>
        <p class="text-[10px] sm:text-xs text-[#819da7]/50 font-medium font-mono italic">{{ kpi.sub }}</p>
      </div>
    </section>

    <section class="grid grid-cols-1 lg:grid-cols-3 gap-6 sm:gap-10">
      
      <div class="lg:col-span-2 flex flex-col gap-6 sm:gap-10">
        
        <div class="bg-[#0c1215] p-5 sm:p-8 rounded-[1.5rem] sm:rounded-[2rem] border border-[#ffffff]/5 shadow-2xl">
          <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 sm:gap-6 mb-6 sm:mb-8">
            <h2 class="text-xs sm:text-sm font-black uppercase tracking-[0.3em] text-[#819da7]">
              Rendimiento Temporal <span class="text-[#00ff88]/50 font-mono text-[9px] sm:text-[10px]">// {{ rangoActivo.toUpperCase() }}_STATS</span>
            </h2>

            <div class="flex bg-[#05080a] p-1.5 rounded-2xl border border-[#ffffff]/10 gap-1 sm:gap-3 w-full md:w-auto justify-between md:justify-start">
              <button 
                v-for="r in ['Semana', 'Mes', 'Año']" 
                :key="r"
                @click="cambiarRango(r)"
                :class="['px-4 sm:px-6 py-2 rounded-xl text-[9px] sm:text-[10px] font-black uppercase tracking-widest transition-all duration-300 flex-1 md:flex-none text-center', 
                         rangoActivo === r ? 'bg-[#00ff88] text-black shadow-neon scale-105' : 'text-[#819da7] hover:text-[#00ff88]']"
              >
                {{ r }}
              </button>
            </div>
          </div>
          
          <apexchart type="area" height="300" sm:height="350" :options="chartOptions" :series="series"></apexchart>
        </div>
        
        <div class="bg-[#0c1215] rounded-[1.5rem] sm:rounded-[2rem] border border-[#ffffff]/5 overflow-hidden shadow-2xl w-full">
          <div class="p-5 sm:p-8 border-b border-[#ffffff]/5 bg-[#05080a]/50 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-2">
            <h2 class="text-xs sm:text-sm font-black uppercase tracking-[0.3em] text-[#819da7]">Registro de Operaciones Recientes</h2>
            <span class="text-[9px] sm:text-[10px] font-mono text-[#00ff88]/50">CLICK_ROW_FOR_DETAILS</span>
          </div>

          <div class="overflow-x-auto overflow-y-hidden w-full table-wrap">
            <table class="w-full text-left border-collapse min-w-[600px]">
              <thead class="text-[9px] sm:text-[10px] uppercase text-[#819da7] bg-[#05080a] font-black border-b border-[#ffffff]/5">
                <tr>
                  <th class="px-4 sm:px-8 py-4 sm:py-5 tracking-widest">Hash ID</th>
                  <th class="px-4 sm:px-8 py-4 sm:py-5 tracking-widest">Fecha y Hora</th>
                  <th class="px-4 sm:px-8 py-4 sm:py-5 text-center tracking-widest">Estado</th>
                  <th class="px-4 sm:px-8 py-4 sm:py-5 tracking-widest">Método</th>
                  <th class="px-4 sm:px-8 py-4 sm:py-5 text-right tracking-widest">Monto Final</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-[#ffffff]/5">
                <tr 
                  v-for="order in (ordenes || []).slice(0, 5)" 
                  :key="order._id" 
                  @click="abrirDetalles(order)"
                  class="hover:bg-[#00ff88]/[0.03] transition-colors group cursor-pointer"
                >
                  <td class="px-4 sm:px-8 py-4 sm:py-5 font-mono text-[#00ff88]/80 group-hover:text-[#00ff88] text-[10px] sm:text-xs">
                    #{{ order._id ? order._id.slice(-6).toUpperCase() : 'N/A' }}
                  </td>
                  <td class="px-4 sm:px-8 py-4 sm:py-5">
                    <p class="text-[11px] sm:text-xs text-white font-bold">{{ formatearFecha(order.createdAt) }}</p>
                    <p class="text-[9px] sm:text-[10px] text-[#819da7] font-mono uppercase">{{ formatearHora(order.createdAt) }}</p>
                  </td>
                  <td class="px-4 sm:px-8 py-4 sm:py-5 text-center">
                    <span class="px-2 py-1 rounded-md text-[8px] sm:text-[9px] font-black uppercase border border-[#00ff88]/20 bg-[#00ff88]/5 text-[#00ff88]">
                      Completada
                    </span>
                  </td>
                  <td class="px-4 sm:px-8 py-4 sm:py-5 text-[9px] sm:text-[10px] font-bold text-[#819da7] tracking-widest">
                    {{ order.metodo_pago || 'EFECTIVO' }}
                  </td>
                  <td class="px-4 sm:px-8 py-4 sm:py-5 text-right font-black text-white text-base sm:text-lg font-mono">
                    {{ formatearDinero(order.total_venta) }}
                  </td>
                </tr>
                <tr v-if="!ordenes || ordenes.length === 0">
                    <td colspan="5" class="px-4 sm:px-8 py-8 sm:py-10 text-center text-[#819da7] font-mono text-[10px] sm:text-xs">No hay ventas registradas aún.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <aside class="flex flex-col gap-6 sm:gap-10 h-full w-full">
        <div class="bg-[#0c1215] rounded-[2rem] sm:rounded-[3rem] border border-[#f97316]/20 p-5 sm:p-8 shadow-2xl relative overflow-hidden flex flex-col h-full min-h-[350px] sm:min-h-[400px] max-h-[500px] sm:max-h-[650px] w-full">
          <div class="absolute top-0 right-0 w-32 sm:w-48 h-32 sm:h-48 bg-[#f97316]/10 rounded-bl-full blur-2xl sm:blur-3xl pointer-events-none"></div>

          <div class="flex justify-between items-center mb-6 sm:mb-8 z-10 relative shrink-0">
            <h2 class="text-[10px] sm:text-xs font-black uppercase tracking-[0.2em] text-[#f97316] flex items-center gap-2">
              <span class="animate-pulse">⚠️</span> Alerta de Inventario
            </h2>
            <span class="text-[7px] sm:text-[8px] font-mono text-[#f97316]/60 border border-[#f97316]/20 px-2 py-1 rounded-md bg-[#f97316]/5">
              SQL_SYNC
            </span>
          </div>

          <div class="space-y-3 overflow-y-auto flex-1 pr-1 sm:pr-2 z-10 relative custom-scrollbar">
            
            <div v-if="!productosBajoStock?.length" class="text-center py-8 sm:py-10">
              <p class="text-2xl sm:text-3xl mb-2">✅</p>
              <p class="text-[10px] sm:text-xs font-black text-[#819da7] uppercase tracking-widest">Niveles Estables</p>
            </div>

            <div v-for="prod in productosBajoStock" :key="prod.id || prod.sku" 
              class="flex justify-between items-center bg-[#05080a] p-3 sm:p-4 rounded-xl sm:rounded-2xl border border-[#ffffff]/5 hover:border-[#f97316]/40 transition-all group relative overflow-hidden shrink-0">
              
              <div class="absolute inset-0 bg-gradient-to-r from-transparent to-[#f97316]/5 opacity-0 group-hover:opacity-100 transition-opacity"></div>

              <div class="z-10 w-2/3">
                <p class="text-[10px] sm:text-[11px] font-black text-white mb-1 truncate" :title="prod.nombre || prod.nombre_producto">
                  {{ prod.nombre || prod.nombre_producto || 'Producto Desconocido' }}
                </p>
                <span class="text-[7px] sm:text-[8px] font-mono text-[#819da7] bg-[#ffffff]/5 px-2 py-0.5 rounded-md uppercase border border-[#ffffff]/5">
                  SKU: {{ prod.sku || 'N/A' }}
                </span>
              </div>

              <div class="z-10 flex flex-col items-end">
                <span class="text-[6px] sm:text-[7px] text-[#f97316] font-black uppercase tracking-widest mb-1 opacity-70">En Bodega</span>
                <p class="text-[#f97316] font-mono font-black text-base sm:text-lg bg-[#f97316]/10 px-2 sm:px-3 py-1 rounded-lg sm:rounded-xl border border-[#f97316]/20 min-w-[3rem] sm:min-w-[3.5rem] text-center flex items-baseline justify-center gap-1 shadow-[0_0_10px_rgba(249,115,22,0.1)]">
                  {{ prod.cantidad ?? prod.stock ?? prod.stock_actual ?? 0 }}
                  <span class="text-[8px] sm:text-[9px] font-sans opacity-50 font-normal">pz</span>
                </p>
              </div>
            </div>

          </div>
        </div>
      </aside>
      
    </section>

    <OrderModal 
      :isOpen="isModalOpen" 
      :order="selectedOrder" 
      @close="cerrarModal" 
    />
  </div>
</template>

<script setup>
import { ref, onMounted, watch, computed } from 'vue'; 
import apexchart from 'vue3-apexcharts'; 
import { useDashboard } from '@/core/composables/useDashboard';
import OrderModal from '@/features/vendedor/components/OrderModal.vue';

const props = defineProps(['userId']);

// 💡 Llamamos a useDashboard sin pasarle parámetros
const { 
  ordenes, productosBajoStock, rangoActivo, series, kpis, categoriasGrafica, 
  formatearDinero, formatearFecha, formatearHora, 
  cargarDatos, procesarDatosGrafica 
} = useDashboard(); 

const isModalOpen = ref(false);
const selectedOrder = ref(null);

const abrirDetalles = (order) => {
  selectedOrder.value = order;
  isModalOpen.value = true;
};

const cerrarModal = () => {
  isModalOpen.value = false;
  selectedOrder.value = null;
};

const cambiarRango = (nuevoRango) => {
  rangoActivo.value = nuevoRango;
  procesarDatosGrafica();
};

const chartOptions = computed(() => ({
  chart: { type: 'area', toolbar: { show: false }, background: 'transparent' },
  colors: ['#00ff88'],
  stroke: { curve: 'smooth', width: 4 },
  fill: { type: 'gradient', gradient: { opacityFrom: 0.4, opacityTo: 0, stops: [0, 90, 100] } },
  xaxis: { 
    categories: categoriasGrafica.value, 
    labels: { style: { colors: '#819da7', fontFamily: 'monospace', fontWeight: 700 } } 
  },
  yaxis: { 
    decimalsInFloat: 0, 
    labels: { 
      style: { colors: '#819da7', fontFamily: 'monospace' },
      formatter: (value) => "$" + Number(value || 0).toFixed(0)
    } 
  }, 
  theme: { mode: 'dark' },
  grid: { borderColor: 'rgba(255, 255, 255, 0.05)', strokeDashArray: 4 },
  dataLabels: { enabled: false },
  tooltip: { 
    theme: 'dark',
    y: { 
      formatter: (value) => "$" + Number(value || 0).toLocaleString('es-MX', { minimumFractionDigits: 2 }) 
    }
  }
}));

onMounted(() => {
  if (props.userId) cargarDatos(props.userId);
});
 
watch(() => props.userId, (nuevoId) => {
  if (nuevoId) cargarDatos(nuevoId);
}, { immediate: true });
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.4s ease-out; }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

/* Ajustes de scroll personalizados */
::-webkit-scrollbar { height: 6px; width: 6px; }
::-webkit-scrollbar-track { background: #05080a; }
::-webkit-scrollbar-thumb { background: #0c1215; border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 10px; }

/* 👈 NUEVO: Mejora el deslizamiento horizontal en celulares */
.table-wrap {
  -webkit-overflow-scrolling: touch;
}
</style>