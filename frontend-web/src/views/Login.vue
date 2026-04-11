<script setup>
import { ref, computed } from 'vue';
import FondoMeteoritos from '../components/FondoMeteoritos.vue'; 
import { useRouter } from 'vue-router';

const router = useRouter();
const rolActivo = ref('administrador'); 

const tema = computed(() => {
  switch (rolActivo.value) {
    case 'administrador': return { texto: 'text-[#ef4444]', borde: 'border-[#ef4444] shadow-[0_0_40px_rgba(239,68,68,0.2)]', boton: 'bg-[#ef4444] hover:bg-[#dc2626]' };
    case 'vendedor': return { texto: 'text-[#22c55e]', borde: 'border-[#22c55e] shadow-[0_0_40px_rgba(34,197,94,0.2)]', boton: 'bg-[#22c55e] hover:bg-[#16a34a]' };
    case 'consultor': return { texto: 'text-[#3b82f6]', borde: 'border-[#3b82f6] shadow-[0_0_40px_rgba(59,130,246,0.2)]', boton: 'bg-[#3b82f6] hover:bg-[#2563eb]' };
    default: return { texto: 'text-gray-500', borde: 'border-gray-800', boton: 'bg-gray-800' };
  }
});

// FUNCIÓN MÁGICA: Pasa directo sin validar nada
const accesoDirecto = (rol) => {
  rolActivo.value = rol;
  
  // Simulamos que guardamos un usuario ficticio para que no truene el sistema
  localStorage.setItem('user', JSON.stringify({ nombre: 'Usuario Prueba', role: rol }));
  
  // Redirección inmediata
  if (rol === 'administrador') router.push('/admin');
  else if (rol === 'vendedor') router.push('/vendedor');
  else if (rol === 'consultor') router.push('/consultor');
};
</script>

<template>
  <div class="fixed inset-0 bg-[#080d17] text-white flex flex-col font-sans overflow-hidden">
    <FondoMeteoritos />
    
    <div class="flex-1 w-full max-w-[1400px] mx-auto flex flex-col px-6 md:px-12 py-10 z-10 overflow-y-auto">
      
      <div class="text-center mt-4 mb-16 md:mb-24">
        <div class="text-5xl md:text-6xl mb-4">🧑‍🔧⚙️</div>
        <h1 class="text-4xl md:text-5xl font-bold tracking-[0.3em] mt-2 drop-shadow-lg">LOS AMIGOS</h1>
        <p class="text-xs md:text-sm text-gray-500 tracking-[0.4em] mt-3 uppercase">Modo Desarrollo: Acceso Directo</p>
      </div>

      <div class="w-full flex justify-between md:justify-around items-center px-4 md:px-20 mb-16 md:mb-24">
        
        <div @click="accesoDirecto('administrador')" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'administrador' ? tema.borde : 'border-gray-800/50 group-hover:border-red-500']">🛡️</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'administrador' ? tema.texto : 'text-gray-600']">Entrar como Admin</span>
        </div>

        <div @click="accesoDirecto('vendedor')" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'vendedor' ? tema.borde : 'border-gray-800/50 group-hover:border-green-500']">📠</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'vendedor' ? tema.texto : 'text-gray-600']">Entrar como Vendedor</span>
        </div>

        <div @click="accesoDirecto('consultor')" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'consultor' ? tema.borde : 'border-gray-800/50 group-hover:border-blue-500']">🔍</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'consultor' ? tema.texto : 'text-gray-600']">Entrar como Consultor</span>
        </div>

      </div>

      <div class="w-full max-w-3xl mx-auto flex flex-col items-center">
        <p class="text-gray-500 animate-pulse">Haz clic en un icono arriba para entrar directamente</p>
      </div>

    </div>
  </div>
</template>