<template>
  <header class="w-full min-h-[6rem] lg:h-24 border-b border-[#00ff88]/20 bg-[#0c1215] flex flex-wrap lg:flex-nowrap items-center justify-between px-4 md:px-8 xl:px-12 py-4 lg:py-0 gap-y-4 shrink-0 z-30 shadow-[0_10px_30px_rgba(0,0,0,0.5)]">
    
    <div class="flex items-center gap-3 md:gap-6 lg:gap-10 group order-1">
      <div class="bg-[#00ff88]/10 p-2 md:p-3 rounded-xl md:rounded-2xl border border-[#00ff88]/20 group-hover:border-[#00ff88]/50 transition-all">
        <span class="text-xl md:text-3xl">🛠️</span>
      </div>
      <h1 class="text-sm md:text-xl lg:text-2xl font-black text-white tracking-tighter uppercase italic leading-tight">
        Refaccionaria <br class="block sm:hidden" /> 
        <span class="text-[#00ff88] drop-shadow-[0_0_15px_rgba(0,255,136,0.6)]">Los Amigos</span>
      </h1>
    </div>
    
    <div class="flex items-center gap-4 md:gap-8 order-2 lg:order-3">
      <div class="text-right hidden xl:block border-r border-[#ffffff]/10 pr-8">
        <p class="text-[10px] text-[#00ff88] uppercase font-black tracking-widest mb-1">{{ userName }}</p>
      </div>
      
      <button 
        @click="logout" 
        class="bg-transparent border-2 border-[#ef4444]/40 text-[#ef4444] px-4 md:px-6 py-2 md:py-2.5 rounded-lg md:rounded-xl text-[10px] md:text-xs font-black hover:bg-[#ef4444] hover:text-white transition-all hover:shadow-[0_0_20px_rgba(239,68,68,0.3)]"
      >
        SALIR
      </button>
    </div>

    <nav class="flex w-full lg:w-auto overflow-x-auto scrollbar-hide bg-[#05080a] p-1.5 md:p-2 rounded-xl md:rounded-2xl border border-[#ffffff]/5 gap-2 md:gap-6 order-3 lg:order-2">
      <button 
        v-for="tab in [['dashboard', '📊 DASHBOARD'], ['pos', '🛒 VENTA'], ['inventory', '📦 INVENTARIO']]" 
        :key="tab[0]"
        @click="$emit('cambiarTab', tab[0])" 
        :class="['px-4 md:px-8 py-2.5 md:py-3 rounded-lg md:rounded-xl text-[9px] md:text-[11px] font-black uppercase tracking-widest md:tracking-[0.25em] transition-all duration-300 whitespace-nowrap', 
                 activeTab === tab[0] 
                 ? 'bg-[#00ff88] text-[#000000] shadow-[0_0_15px_rgba(0,255,136,0.4)] md:shadow-[0_0_25px_rgba(0,255,136,0.4)] lg:scale-105' 
                 : 'text-[#819da7] hover:text-[#00ff88] hover:bg-[#00ff88]/5']"
      >
        {{ tab[1] }}
      </button>
    </nav>

  </header>
</template>

<script setup>
import { useRouter } from 'vue-router';

defineProps(['userName', 'activeTab']);
defineEmits(['cambiarTab']);

const router = useRouter();

const logout = () => {
  localStorage.clear();
  router.push('/');
};
</script>

<style scoped>
/* 💡 Magia para que en celular se pueda deslizar el menú sin que se vea la fea barra de scroll */
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}
.scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>