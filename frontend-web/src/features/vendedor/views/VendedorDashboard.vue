<template>
  <div class="w-full min-h-screen bg-[#05080a] text-white flex flex-col overflow-x-hidden relative selection:bg-[#00ff88] selection:text-black">
    
    <div class="fixed top-0 left-0 w-full h-full bg-[radial-gradient(circle_at_top_left,_var(--tw-gradient-stops))] from-[#00ff88]/5 via-transparent to-transparent pointer-events-none"></div>

    <HeaderVendedor 
      :userName="userName" 
      :activeTab="activeTab" 
      @cambiarTab="activeTab = $event" 
    />

    <main class="w-full flex-1 p-6 lg:p-10 relative z-10">
      <TabResumen v-if="activeTab === 'dashboard'" :userId="userId" />
      <TabPOS v-if="activeTab === 'pos'" :userId="userId" />
      <TabInventario v-if="activeTab === 'inventory'" />
    </main>

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';

// Importamos los componentes
import HeaderVendedor from '@/features/vendedor/components/HeaderVendedor.vue';
import TabResumen from '@/features/vendedor/components/TabResumen.vue';
import TabPOS from '@/features/vendedor/components/TabPOS.vue';
import TabInventario from '@/features/vendedor/components/TabInventario.vue';

const router = useRouter();
const activeTab = ref('dashboard');
const userName = ref('');
const userId = ref('');

// Al montar, validamos la sesión y sacamos el ID
onMounted(() => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (!user) return router.push('/');
  
  userName.value = user.nombre;
  userId.value = user._id || user.id;
});
</script>

<style scoped>
/* Scrollbar estilo Terminal Cyberpunk */
::-webkit-scrollbar { 
  width: 8px; 
}
::-webkit-scrollbar-track { 
  background: #05080a; 
}
::-webkit-scrollbar-thumb { 
  background: #0c1215; 
  border: 1px solid rgba(0, 255, 136, 0.2); 
  border-radius: 10px; 
}
::-webkit-scrollbar-thumb:hover { 
  background: rgba(0, 255, 136, 0.1); 
  border: 1px solid rgba(0, 255, 136, 0.6); 
}
</style>