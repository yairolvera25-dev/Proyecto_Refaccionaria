<template>
  <div class="flex flex-col gap-10 animate-fade-in w-full">
    
    <section class="w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
      <div v-for="kpi in kpis" :key="kpi.label" 
        class="bg-[#0c1215] p-8 rounded-[2rem] border border-[#ffffff]/5 shadow-2xl hover:border-[#00ff88]/50 transition-all group relative overflow-hidden">
        <div class="absolute -top-2 -right-2 w-8 h-8 bg-[#00ff88]/10 rounded-full blur-xl group-hover:bg-[#00ff88]/30 transition-all"></div>
        
        <p class="text-[11px] uppercase font-black text-[#819da7] mb-3 tracking-[0.2em]">{{ kpi.label }}</p>
        <p :class="['text-4xl font-mono font-black mb-2 drop-shadow-[0_0_10px_rgba(0,255,136,0.2)]', kpi.color]">{{ kpi.value }}</p>
        <p class="text-xs text-[#819da7]/50 font-medium font-mono italic">{{ kpi.sub }}</p>
      </div>
    </section>

    <section class="grid grid-cols-1 lg:grid-cols-3 gap-10">
      
      <div class="lg:col-span-2 flex flex-col gap-10">
        
        <div class="bg-[#0c1215] p-8 rounded-[2rem] border border-[#ffffff]/5 shadow-2xl">
          <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 mb-8">
            <h2 class="text-sm font-black uppercase tracking-[0.3em] text-[#819da7]">
              Rendimiento Temporal <span class="text-[#00ff88]/50 font-mono text-[10px]">// {{ rangoActivo.toUpperCase() }}_STATS</span>
            </h2>

            <div class="flex bg-[#05080a] p-1.5 rounded-2xl border border-[#ffffff]/10 gap-3">
              <button 
                v-for="r in ['Semana', 'Mes', 'Año']" 
                :key="r"
                @click="cambiarRango(r)"
                :class="['px-6 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all duration-300', 
                         rangoActivo === r ? 'bg-[#00ff88] text-black shadow-neon scale-105' : 'text-[#819da7] hover:text-[#00ff88]']"
              >
                {{ r }}
              </button>
            </div>
          </div>
          
          <apexchart type="area" height="350" :options="chartOptions" :series="series"></apexchart>
        </div>
        
        <div class="bg-[#0c1215] rounded-[2rem] border border-[#ffffff]/5 overflow-hidden shadow-2xl">
          <div class="p-8 border-b border-[#ffffff]/5 bg-[#05080a]/50 flex justify-between items-center">
            <h2 class="text-sm font-black uppercase tracking-[0.3em] text-[#819da7]">Registro de Operaciones Recientes</h2>
            <span class="text-[10px] font-mono text-[#00ff88]/50">CLICK_ROW_FOR_DETAILS</span>
          </div>

          <div class="overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead class="text-[10px] uppercase text-[#819da7] bg-[#05080a] font-black border-b border-[#ffffff]/5">
                <tr>
                  <th class="px-8 py-5 tracking-widest">Hash ID</th>
                  <th class="px-8 py-5 tracking-widest">Fecha y Hora</th>
                  <th class="px-8 py-5 text-center tracking-widest">Estado</th>
                  <th class="px-8 py-5 tracking-widest">Método</th>
                  <th class="px-8 py-5 text-right tracking-widest">Monto Final</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-[#ffffff]/5">
                <tr 
                  v-for="order in ordenes.slice(0, 5)" 
                  :key="order._id" 
                  @click="abrirDetalles(order)"
                  class="hover:bg-[#00ff88]/[0.03] transition-colors group cursor-pointer"
                >
                  <td class="px-8 py-5 font-mono text-[#00ff88]/80 group-hover:text-[#00ff88] text-xs">
                    #{{ order._id.slice(-6).toUpperCase() }}
                  </td>
                  <td class="px-8 py-5">
                    <p class="text-xs text-white font-bold">{{ formatearFecha(order.createdAt) }}</p>
                    <p class="text-[10px] text-[#819da7] font-mono uppercase">{{ formatearHora(order.createdAt) }}</p>
                  </td>
                  <td class="px-8 py-5 text-center">
                    <span class="px-2 py-1 rounded-md text-[9px] font-black uppercase border border-[#00ff88]/20 bg-[#00ff88]/5 text-[#00ff88]">
                      Completada
                    </span>
                  </td>
                  <td class="px-8 py-5 text-[10px] font-bold text-[#819da7] tracking-widest">
                    {{ order.metodo_pago || 'EFECTIVO' }}
                  </td>
                  <td class="px-8 py-5 text-right font-black text-white text-lg font-mono">
                    {{ formatearDinero(order.total_venta) }}
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <aside class="flex flex-col gap-10">
        <div class="bg-[#0c1215] rounded-[3rem] border border-[#f97316]/20 p-8 shadow-2xl relative overflow-hidden h-full min-h-[400px]">
          <div class="absolute top-0 right-0 w-48 h-48 bg-[#f97316]/10 rounded-bl-full blur-3xl pointer-events-none"></div>

          <div class="flex justify-between items-center mb-8 z-10 relative">
            <h2 class="text-xs font-black uppercase tracking-[0.2em] text-[#f97316] flex items-center gap-2">
              <span class="animate-pulse">⚠️</span> Alerta de Inventario
            </h2>
            <span class="text-[8px] font-mono text-[#f97316]/60 border border-[#f97316]/20 px-2 py-1 rounded-md bg-[#f97316]/5">
              SQL_SYNC
            </span>
          </div>

          <div class="space-y-3 overflow-y-auto max-h-[500px] pr-2 z-10 relative custom-scrollbar">
            
            <div v-if="!productosBajoStock?.length" class="text-center py-10">
              <p class="text-3xl mb-2">✅</p>
              <p class="text-xs font-black text-[#819da7] uppercase tracking-widest">Niveles Estables</p>
            </div>

            <div v-for="prod in productosBajoStock" :key="prod.id || prod.sku" 
              class="flex justify-between items-center bg-[#05080a] p-4 rounded-2xl border border-[#ffffff]/5 hover:border-[#f97316]/40 transition-all group relative overflow-hidden">
              
              <div class="absolute inset-0 bg-gradient-to-r from-transparent to-[#f97316]/5 opacity-0 group-hover:opacity-100 transition-opacity"></div>

              <div class="z-10 w-2/3">
                <p class="text-[11px] font-black text-white mb-1 truncate" :title="prod.nombre || prod.nombre_producto">
                  {{ prod.nombre || prod.nombre_producto || 'Producto Desconocido' }}
                </p>
                <span class="text-[8px] font-mono text-[#819da7] bg-[#ffffff]/5 px-2 py-0.5 rounded-md uppercase border border-[#ffffff]/5">
                  SKU: {{ prod.sku || 'N/A' }}
                </span>
              </div>

              <div class="z-10 flex flex-col items-end">
                <span class="text-[7px] text-[#f97316] font-black uppercase tracking-widest mb-1 opacity-70">En Bodega</span>
                <p class="text-[#f97316] font-mono font-black text-lg bg-[#f97316]/10 px-3 py-1 rounded-xl border border-[#f97316]/20 min-w-[3.5rem] text-center flex items-baseline justify-center gap-1 shadow-[0_0_10px_rgba(249,115,22,0.1)]">
                  {{ prod.cantidad ?? prod.stock ?? prod.stock_actual ?? 0 }}
                  <span class="text-[9px] font-sans opacity-50 font-normal">pz</span>
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
import { ref, onMounted, watch, computed } from 'vue'; // 💡 Agregamos computed
import apexchart from 'vue3-apexcharts'; 
import { useDashboard } from '../../../core/composables/useDashboard';
import OrderModal from './OrderModal.vue';

const props = defineProps(['userId']);

const { 
  ordenes, productosBajoStock, rangoActivo, series, kpis, categoriasGrafica, // 💡 Traemos las categorias
  formatearDinero, formatearFecha, formatearHora, 
  cargarDatos, procesarDatosGrafica 
} = useDashboard(
  import.meta.env.VITE_API_URL_NOSQL, 
  import.meta.env.VITE_API_URL_SQL
);

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

// 💡 Cambiamos ref() por computed() para que se actualice al hacer clic en los botones
const chartOptions = computed(() => ({
  chart: { type: 'area', toolbar: { show: false }, background: 'transparent' },
  colors: ['#00ff88'],
  stroke: { curve: 'smooth', width: 4 },
  fill: { type: 'gradient', gradient: { opacityFrom: 0.4, opacityTo: 0, stops: [0, 90, 100] } },
  xaxis: { 
    categories: categoriasGrafica.value, // 💡 Inyectamos los días/meses aquí
    labels: { style: { colors: '#819da7', fontFamily: 'monospace', fontWeight: 700 } } 
  },
  yaxis: { 
    labels: { 
      style: { colors: '#819da7', fontFamily: 'monospace' },
      formatter: (value) => "$" + value.toFixed(0) // 💡 Le ponemos el signo de Dólar/Peso
    } 
  },
  theme: { mode: 'dark' },
  grid: { borderColor: 'rgba(255, 255, 255, 0.05)', strokeDashArray: 4 },
  dataLabels: { enabled: false },
  tooltip: { theme: 'dark' }
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

::-webkit-scrollbar { height: 6px; width: 6px; }
::-webkit-scrollbar-track { background: #05080a; }
::-webkit-scrollbar-thumb { background: #0c1215; border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 10px; }
</style>