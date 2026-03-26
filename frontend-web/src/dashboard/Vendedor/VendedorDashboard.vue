<template>
  <div class="w-full min-h-screen bg-[#0d1117] text-gray-300 font-sans flex flex-col overflow-x-hidden">
    
    <header class="w-full h-20 border-b border-gray-800 bg-[#161b22] flex items-center justify-between px-10 shrink-0">
      <div class="flex items-center gap-4">
        <span class="text-3xl">📈</span>
        <h1 class="text-2xl font-black text-white tracking-tighter uppercase">Gestión de Ventas <span class="text-gray-600 font-light">| Panel de Control</span></h1>
      </div>
      <div class="flex items-center gap-6">
        <div class="text-right hidden xl:block">
          <p class="text-[10px] text-gray-500 uppercase font-black tracking-widest">Vendedor Activo</p>
          <p class="text-lg font-bold text-blue-400">Yair Olvera</p>
        </div>
        <div class="flex gap-3">
          <button class="bg-[#21262d] border border-gray-700 px-6 py-2.5 rounded-xl text-xs font-bold hover:bg-[#30363d] transition-all">REPORTE MENSUAL</button>
          <button @click="$router.push('/')" class="bg-red-500/10 text-red-500 border border-red-500/20 px-6 py-2.5 rounded-xl text-xs font-bold hover:bg-red-600 hover:text-white transition-all">SALIR</button>
        </div>
      </div>
    </header>

    <main class="w-full flex-1 p-10 flex flex-col gap-10">
      
      <section class="w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
        <div v-for="kpi in kpis" :key="kpi.label" class="bg-[#161b22] p-8 rounded-[2rem] border border-gray-800 shadow-2xl hover:border-blue-500/50 transition-all group">
          <p class="text-[11px] uppercase font-black text-gray-500 mb-3 tracking-[0.2em]">{{ kpi.label }}</p>
          <p :class="['text-4xl font-mono font-bold mb-2', kpi.color]">{{ kpi.value }}</p>
          <p class="text-xs opacity-50 font-medium">{{ kpi.sub }}</p>
        </div>
      </section>

      <section class="w-full flex flex-col lg:flex-row gap-10 flex-1">
        
        <div class="flex-grow bg-[#161b22] rounded-[2rem] border border-gray-800 overflow-hidden shadow-2xl flex flex-col">
          <div class="p-8 border-b border-gray-800 flex justify-between items-center bg-black/10">
            <h2 class="text-sm font-black uppercase tracking-[0.3em] text-gray-400">Historial de Ventas Recientes</h2>
            <div class="relative w-80">
              <input type="text" placeholder="Buscar orden..." class="w-full bg-[#0d1117] border border-gray-700 text-sm px-5 py-3 rounded-2xl outline-none focus:border-blue-500 transition-all">
            </div>
          </div>
          
          <div class="flex-1 overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="text-[11px] uppercase text-gray-600 border-b border-gray-800 bg-[#0d1117]/50 font-black tracking-widest">
                  <th class="px-10 py-6">ID Orden</th>
                  <th class="px-10 py-6">Cliente</th>
                  <th class="px-10 py-6">Estado</th>
                  <th class="px-10 py-6 text-right">Total</th>
                  <th class="px-10 py-6 text-center">Acción</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-800/30">
                <tr v-for="order in ordenesMock" :key="order.id" class="hover:bg-blue-500/[0.04] transition-colors group">
                  <td class="px-10 py-6 font-mono font-bold text-blue-500 text-lg">{{ order.id }}</td>
                  <td class="px-10 py-6">
                    <p class="font-bold text-gray-100 text-base">{{ order.cliente }}</p>
                    <p class="text-[11px] text-gray-500 mt-1 font-medium">{{ order.fecha }}</p>
                  </td>
                  <td class="px-10 py-6">
                    <span :class="['px-4 py-1.5 rounded-full text-[10px] font-black uppercase border', getStatusStyle(order.estado)]">
                      {{ order.estado }}
                    </span>
                  </td>
                  <td class="px-10 py-6 text-right font-mono font-bold text-white text-xl">${{ order.total }}</td>
                  <td class="px-10 py-6 text-center">
                    <button class="bg-[#21262d] hover:bg-blue-600 hover:text-white p-3 rounded-xl transition-all shadow-lg">⚙️</button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <aside class="lg:w-[400px] flex flex-col gap-10">
          <div class="bg-[#161b22] rounded-[2rem] border border-gray-800 p-10 shadow-xl flex-1">
            <h2 class="text-sm font-black uppercase tracking-[0.3em] text-gray-400 mb-10">Top Rendimiento</h2>
            <div class="space-y-10">
              <div v-for="prod in topProductos" :key="prod.name">
                <div class="flex justify-between text-xs mb-4 font-black uppercase tracking-widest">
                  <span class="text-gray-300">{{ prod.name }}</span>
                  <span class="text-blue-500 font-mono">{{ prod.ventas }} vts</span>
                </div>
                <div class="w-full bg-gray-800 h-3 rounded-full overflow-hidden shadow-inner">
                  <div class="bg-gradient-to-r from-blue-700 to-blue-400 h-full transition-all duration-1000" :style="{ width: prod.perc + '%' }"></div>
                </div>
              </div>
            </div>
          </div>

          <div class="bg-gradient-to-br from-blue-600 to-indigo-800 rounded-[2.5rem] p-10 text-white shadow-2xl relative overflow-hidden group">
            <div class="relative z-10">
              <h3 class="text-2xl font-black uppercase mb-3 italic tracking-tighter">Bono de Meta</h3>
              <p class="text-xs opacity-90 leading-relaxed mb-8 font-medium">Estás a <span class="font-black underline">5 ventas</span> de duplicar tu comisión este viernes. ¡Dale con todo!</p>
              <button class="w-full bg-white text-blue-900 font-black py-4 rounded-2xl uppercase text-xs tracking-[0.2em] shadow-2xl hover:scale-105 active:scale-95 transition-all">Ver Recompensas 🏆</button>
            </div>
            <div class="absolute -right-10 -bottom-10 text-[12rem] opacity-10 rotate-12 group-hover:rotate-0 transition-all duration-700">🏆</div>
          </div>
        </aside>

      </section>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const kpis = ref([
  { label: 'Ingresos Mensuales', value: '$45,280', color: 'text-green-500', sub: '▲ 12.5% rendimiento' },
  { label: 'Órdenes Cerradas', value: '128', color: 'text-white', sub: '92% de la meta' },
  { label: 'Comisión Actual', value: '$2,264', color: 'text-blue-500', sub: 'Corte: 30 de marzo' },
  { label: 'Promedio Ticket', value: '$353', color: 'text-white', sub: 'Refacciones Motor' }
]);

const ordenesMock = ref([
  { id: '#ORD-9921', cliente: 'Marcos Fabián', fecha: '19 Mar 2026, 13:20', estado: 'Completado', total: '1,250.00' },
  { id: '#ORD-9922', cliente: 'Rafael Pérez', fecha: '19 Mar 2026, 14:45', estado: 'Pendiente', total: '345.50' },
  { id: '#ORD-9923', cliente: 'Ismael Refacciones', fecha: '20 Mar 2026, 09:12', estado: 'Enviado', total: '2,890.00' },
  { id: '#ORD-9924', cliente: 'Karel Dev', fecha: '20 Mar 2026, 11:30', estado: 'Cancelado', total: '890.00' },
]);

const topProductos = ref([
  { name: 'Filtro Aceite Premium', ventas: 45, perc: 85 },
  { name: 'Amortiguador Sentra', ventas: 32, perc: 60 },
  { name: 'Bujías Iridium (4P)', ventas: 28, perc: 45 },
]);

const getStatusStyle = (status) => {
  switch (status) {
    case 'Completado': return 'text-green-400 bg-green-400/10 border-green-500/20';
    case 'Pendiente': return 'text-yellow-400 bg-yellow-400/10 border-yellow-500/20';
    case 'Enviado': return 'text-blue-400 bg-blue-400/10 border-blue-500/20';
    case 'Cancelado': return 'text-red-400 bg-red-400/10 border-red-500/20';
    default: return 'text-gray-400 bg-gray-400/10 border-gray-400/20';
  }
};
</script>

<style scoped>
/* Scrollbar estilo moderno para tu Fedora */
::-webkit-scrollbar { width: 8px; }
::-webkit-scrollbar-thumb { background: #30363d; border-radius: 10px; }
::-webkit-scrollbar-thumb:hover { background: #484f58; }
</style>