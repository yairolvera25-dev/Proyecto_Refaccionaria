<template>
  <header class="w-full h-24 border-b border-[#00ff88]/20 bg-[#0c1215] flex items-center justify-between px-12 shrink-0 z-30 shadow-[0_10px_30px_rgba(0,0,0,0.5)]">
    
    <div class="flex items-center gap-10 group">
      <div class="bg-[#00ff88]/10 p-3 rounded-2xl border border-[#00ff88]/20 group-hover:border-[#00ff88]/50 transition-all">
        <span class="text-3xl">🛠️</span>
      </div>
      <h1 class="text-2xl font-black text-white tracking-tighter uppercase italic">
        Refaccionaria <span class="text-[#00ff88] drop-shadow-[0_0_15px_rgba(0,255,136,0.6)]">Los Amigos</span>
      </h1>
    </div>
    
    <nav class="flex bg-[#05080a] p-2 rounded-2xl border border-[#ffffff]/5 gap-6">
      <button 
        v-for="tab in [['dashboard', '📊 DASHBOARD'], ['pos', '🛒 VENTA'], ['inventory', '📦 INVENTARIO']]" 
        :key="tab[0]"
        @click="$emit('cambiarTab', tab[0])" 
        :class="['px-8 py-3 rounded-xl text-[11px] font-black uppercase tracking-[0.25em] transition-all duration-300', 
                 activeTab === tab[0] 
                 ? 'bg-[#00ff88] text-[#000000] shadow-[0_0_25px_rgba(0,255,136,0.4)] scale-105' 
                 : 'text-[#819da7] hover:text-[#00ff88] hover:bg-[#00ff88]/5']"
      >
        {{ tab[1] }}
      </button>
    </nav>

    <div class="flex items-center gap-8">
      <div class="text-right hidden xl:block border-r border-[#ffffff]/10 pr-8">
        <p class="text-[10px] text-[#819da7] uppercase font-black tracking-widest mb-1">{{ userName }}</p>
        <p class="text-[11px] font-bold text-[#00ff88] font-mono">SUCURSAL_PACHUCA</p>
      </div>
      
      <button 
        @click="logout" 
        class="bg-transparent border-2 border-[#ef4444]/40 text-[#ef4444] px-6 py-2.5 rounded-xl text-xs font-black hover:bg-[#ef4444] hover:text-white transition-all hover:shadow-[0_0_20px_rgba(239,68,68,0.3)]"
      >
        SALIR
      </button>
    </div>
  </header>
</template>

<script setup>
import { useRouter } from 'vue-router';

// Recibimos variables del archivo Padre
defineProps(['userName', 'activeTab']);
// Definimos los eventos
defineEmits(['cambiarTab']);

const router = useRouter();

const logout = () => {
  localStorage.clear();
  router.push('/');
};
</script>