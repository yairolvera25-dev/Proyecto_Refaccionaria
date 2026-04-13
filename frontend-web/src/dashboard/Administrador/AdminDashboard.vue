<template>
  <div class="min-h-screen bg-[#080d17] text-white p-8">
    <div class="max-w-7xl mx-auto">
      <header class="flex justify-between items-center mb-12 border-b border-gray-800 pb-6">
        <div>
          <h1 class="text-3xl font-bold tracking-wider text-red-500">PANEL ADMINISTRADOR</h1>
          <p class="text-gray-500 text-sm mt-1 uppercase tracking-widest">Refaccionaria Los Amigos</p>
        </div>
        <button @click="cerrarSesion" class="bg-gray-800 hover:bg-red-600 px-6 py-2 rounded-lg transition-all text-sm font-bold">
          CERRAR SESIÓN
        </button>
      </header>

      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
        <div class="bg-[#0d1424] p-6 rounded-2xl border border-gray-800 shadow-xl">
          <p class="text-gray-500 text-xs uppercase font-bold mb-2">Ventas del Día</p>
          <p class="text-2xl font-bold">$12,450.00</p>
        </div>
        <div class="bg-[#0d1424] p-6 rounded-2xl border border-gray-800 shadow-xl">
          <p class="text-gray-500 text-xs uppercase font-bold mb-2">Productos en Stock</p>
          <p class="text-2xl font-bold">1,240</p>
        </div>
        <div class="bg-[#0d1424] p-6 rounded-2xl border border-gray-800 shadow-xl">
          <p class="text-gray-500 text-xs uppercase font-bold mb-2">Alertas de Inventario</p>
          <p class="text-2xl font-bold text-red-500">12</p>
        </div>
      </div>

      <div class="bg-[#0d1424] rounded-2xl border border-gray-800 p-8 min-h-[400px] flex items-center justify-center">
        <p class="text-gray-600 italic">Bienvenido al sistema. Selecciona un módulo del menú para comenzar.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router';

const router = useRouter();

const cerrarSesion = () => {
  localStorage.removeItem('user');
  router.push('/');
};
</script>

<style scoped>
/* Estilos específicos si los necesitas */
</style>