<template>
  <div class="w-full min-h-screen bg-[#0d1117] text-gray-300 font-sans flex flex-col overflow-x-hidden">
    
    <header class="w-full h-20 border-b border-gray-800 bg-[#161b22] flex items-center justify-between px-10 shrink-0">
      <div class="flex items-center gap-4">
        <span class="text-3xl">🛡️</span>
        <h1 class="text-2xl font-black text-white tracking-tighter uppercase">Inteligencia de Negocio <span class="text-blue-500 font-light">| Consultoría</span></h1>
      </div>
      <div class="flex items-center gap-6">
        <div class="bg-blue-500/10 border border-blue-500/20 px-4 py-1.5 rounded-full">
          <p class="text-[10px] text-blue-400 font-black uppercase tracking-widest text-center">Modo Solo Lectura</p>
        </div>
        <button @click="$router.push('/')" class="bg-gray-800 hover:bg-gray-700 text-white px-6 py-2.5 rounded-xl text-xs font-bold transition-all">SALIR AL PORTAL</button>
      </div>
    </header>

    <main class="w-full flex-1 p-10 flex flex-col gap-10">
      
      <section class="w-full grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
        <div class="bg-[#161b22] p-8 rounded-[2rem] border border-gray-800 shadow-2xl">
          <p class="text-[11px] uppercase font-black text-gray-500 mb-3 tracking-[0.2em]">Valor de Inventario</p>
          <p class="text-4xl font-mono font-bold text-white">$1,450,280</p>
          <div class="w-full bg-gray-800 h-1.5 rounded-full mt-4 overflow-hidden">
            <div class="bg-blue-500 w-3/4 h-full"></div>
          </div>
        </div>
        <div class="bg-[#161b22] p-8 rounded-[2rem] border border-gray-800 shadow-2xl">
          <p class="text-[11px] uppercase font-black text-gray-500 mb-3 tracking-[0.2em]">Margen de Utilidad</p>
          <p class="text-4xl font-mono font-bold text-green-500">32.4%</p>
          <p class="text-xs opacity-50 mt-2">Promedio acumulado anual</p>
        </div>
        <div class="bg-[#161b22] p-8 rounded-[2rem] border border-gray-800 shadow-2xl">
          <p class="text-[11px] uppercase font-black text-gray-500 mb-3 tracking-[0.2em]">Crecimiento Ventas</p>
          <p class="text-4xl font-mono font-bold text-blue-500">+18.2%</p>
          <p class="text-xs text-green-500 mt-2">▲ Superior al Q1 2025</p>
        </div>
        <div class="bg-[#161b22] p-8 rounded-[2rem] border border-gray-800 shadow-2xl">
          <p class="text-[11px] uppercase font-black text-gray-500 mb-3 tracking-[0.2em]">Índice de Rotación</p>
          <p class="text-4xl font-mono font-bold text-white">4.2x</p>
          <p class="text-xs opacity-50 mt-2">Días promedio en stock: 18</p>
        </div>
      </section>

      <section class="w-full flex flex-col lg:flex-row gap-10 flex-1">
        
        <div class="flex-grow bg-[#161b22] rounded-[2rem] border border-gray-800 overflow-hidden shadow-2xl flex flex-col">
          <div class="p-8 border-b border-gray-800 flex justify-between items-center bg-black/10">
            <div>
              <h2 class="text-sm font-black uppercase tracking-[0.3em] text-gray-400">Reporte de Auditoría de Stock</h2>
              <p class="text-[10px] text-gray-600 mt-1 uppercase">Última actualización: hace 5 minutos</p>
            </div>
            <div class="flex gap-2">
              <button class="bg-[#0d1117] border border-gray-700 p-3 rounded-xl hover:text-blue-500 transition-colors">📥 Exportar CSV</button>
              <button class="bg-[#0d1117] border border-gray-700 p-3 rounded-xl hover:text-blue-500 transition-colors">📊 Ver Gráficas</button>
            </div>
          </div>
          
          <div class="flex-1 overflow-x-auto">
            <table class="w-full text-left border-collapse">
              <thead>
                <tr class="text-[11px] uppercase text-gray-600 border-b border-gray-800 bg-[#0d1117]/50 font-black tracking-widest">
                  <th class="px-10 py-6">Categoría</th>
                  <th class="px-10 py-6">Estatus</th>
                  <th class="px-10 py-6 text-center">Demanda</th>
                  <th class="px-10 py-6 text-right">Valor Estimado</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-800/30">
                <tr v-for="item in reporteMock" :key="item.cat" class="hover:bg-blue-500/[0.04] transition-colors">
                  <td class="px-10 py-6 font-bold text-gray-200">{{ item.cat }}</td>
                  <td class="px-10 py-6">
                    <span :class="['px-4 py-1.5 rounded-full text-[9px] font-black uppercase border', item.color]">
                      {{ item.status }}
                    </span>
                  </td>
                  <td class="px-10 py-6 text-center">
                    <div class="flex items-center justify-center gap-2">
                      <span class="font-mono font-bold">{{ item.demanda }}%</span>
                      <div class="w-12 h-1.5 bg-gray-800 rounded-full overflow-hidden">
                        <div class="bg-blue-500 h-full" :style="{ width: item.demanda + '%' }"></div>
                      </div>
                    </div>
                  </td>
                  <td class="px-10 py-6 text-right font-mono font-bold text-white text-lg">${{ item.valor }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <aside class="lg:w-[400px] flex flex-col gap-10">
          <div class="bg-[#161b22] rounded-[2rem] border border-gray-800 p-10 shadow-xl">
            <h2 class="text-sm font-black uppercase tracking-[0.3em] text-red-500 mb-8">Puntos de Atención</h2>
            <div class="space-y-6">
              <div v-for="alerta in alertas" :key="alerta.titulo" class="p-4 bg-red-500/5 border border-red-500/10 rounded-2xl">
                <p class="text-xs font-black text-red-400 uppercase tracking-widest mb-1">{{ alerta.titulo }}</p>
                <p class="text-[11px] text-gray-500 leading-relaxed">{{ alerta.desc }}</p>
              </div>
            </div>
          </div>

          <div class="bg-gradient-to-br from-gray-800 to-[#161b22] rounded-[2.5rem] p-10 border border-gray-700 shadow-2xl">
            <h3 class="text-xl font-black text-white mb-6 italic">Conclusión de Auditoría</h3>
            <p class="text-xs leading-relaxed text-gray-400 mb-8">
              El flujo de caja se mantiene estable. Se recomienda aumentar el stock en la categoría de <span class="text-blue-400 font-bold">Frenos</span> debido al incremento de demanda proyectado para abril.
            </p>
            <div class="flex items-center gap-4 border-t border-gray-700 pt-6">
              <div class="w-10 h-10 rounded-full bg-blue-500 flex items-center justify-center font-bold text-white italic">AI</div>
              <p class="text-[10px] text-gray-500 font-medium">Análisis generado por sistema de métricas Los Amigos.</p>
            </div>
          </div>
        </aside>

      </section>
    </main>
  </div>
</template>

<script setup>
import { ref } from 'vue';

const reporteMock = ref([
  { cat: 'Sistemas de Frenado', status: 'Alta Demanda', valor: '420,500', demanda: 88, color: 'text-green-400 bg-green-400/10 border-green-500/20' },
  { cat: 'Suspensión y Dirección', status: 'Estable', valor: '380,000', demanda: 65, color: 'text-blue-400 bg-blue-400/10 border-blue-500/20' },
  { cat: 'Componentes de Motor', status: 'Stock Crítico', valor: '150,000', demanda: 92, color: 'text-red-400 bg-red-400/10 border-red-500/20' },
  { cat: 'Iluminación y Eléctrico', status: 'Exceso Stock', valor: '220,000', demanda: 30, color: 'text-yellow-400 bg-yellow-400/10 border-yellow-500/20' },
]);

const alertas = ref([
  { titulo: 'Baja Rotación', desc: 'Hay 45 SKUs en Iluminación que no han tenido movimiento en 90 días.' },
  { titulo: 'Pérdida de Margen', desc: 'El costo de proveedores de Suspensión subió un 4% este mes.' },
]);
</script>