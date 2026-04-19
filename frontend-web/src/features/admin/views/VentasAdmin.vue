<template>
  <div class="w-full min-h-screen bg-[#05080a] text-white flex flex-col overflow-x-hidden relative selection:bg-[#00ff88] selection:text-black">
    <div class="fixed top-0 left-0 w-full h-full bg-[radial-gradient(circle_at_top_left,_var(--tw-gradient-stops))] from-[#00ff88]/5 via-transparent to-transparent pointer-events-none"></div>

    <div class="w-full flex flex-wrap gap-3 mb-6 relative z-10">
      <button
        @click="activeTab = 'dashboard'"
        :class="botonClase('dashboard')"
      >
        Resumen
      </button>

      <button
        @click="activeTab = 'pos'"
        :class="botonClase('pos')"
      >
        Punto de venta
      </button>

      <button
        @click="activeTab = 'inventory'"
        :class="botonClase('inventory')"
      >
        Inventario
      </button>
    </div>

    <main class="w-full flex-1 relative z-10">
      <TabResumen v-if="activeTab === 'dashboard'" :userId="userId" />
      <TabPOS v-if="activeTab === 'pos'" :userId="userId" />
      <TabInventario v-if="activeTab === 'inventory'" />
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

import TabResumen from '@/features/vendedor/components/TabResumen.vue';
import TabPOS from '@/features/vendedor/components/TabPOS.vue';
import TabInventario from '@/features/vendedor/components/TabInventario.vue';

const activeTab = ref('pos');
const userId = ref('');
const userName = ref('');

onMounted(() => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (!user) return;

  userName.value = user.nombre || 'Administrador';
  userId.value = user._id || user.id || '';
});

const botonClase = (tab) => {
  return [
    'px-5 py-3 rounded-2xl text-sm font-black uppercase tracking-wider transition-all border',
    activeTab.value === tab
      ? 'bg-[#00ff88] text-[#05080a] border-[#00ff88] shadow-[0_0_15px_rgba(0,255,136,0.4)]'
      : 'bg-[#0c1215] text-[#819da7] border-[#ffffff]/10 hover:border-[#00ff88]/50 hover:text-[#00ff88]'
  ];
};
</script>
