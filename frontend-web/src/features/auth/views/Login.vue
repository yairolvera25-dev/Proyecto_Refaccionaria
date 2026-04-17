<script setup>
import { ref, computed, reactive } from 'vue';
import FondoMeteoritos from '../../../shared/components/FondoMeteoritos.vue';
import { useRouter } from 'vue-router';
import { authService } from '../../../core/services/authService';

const router = useRouter();

// Variables de estado
const rolActivo = ref('administrador'); 
const cargando = ref(false);
const mensaje = reactive({ texto: '', tipo: '' }); // Para errores o éxito
const credenciales = reactive({ email: '', password: '' });

// Configuración de Temas (Colores Neón)
const tema = computed(() => {
  switch (rolActivo.value) {
    case 'administrador': 
      return { 
        texto: 'text-[#ef4444]', 
        borde: 'border-[#ef4444] shadow-[0_0_40px_rgba(239,68,68,0.2)]', 
        boton: 'bg-[#ef4444] hover:bg-[#dc2626]',
        inputFocus: 'focus:border-[#ef4444]'
      };
    case 'vendedor': 
      return { 
        texto: 'text-[#22c55e]', 
        borde: 'border-[#22c55e] shadow-[0_0_40px_rgba(34,197,94,0.2)]', 
        boton: 'bg-[#22c55e] hover:bg-[#16a34a]',
        inputFocus: 'focus:border-[#22c55e]'
      };
    case 'consultor': 
      return { 
        texto: 'text-[#3b82f6]', 
        borde: 'border-[#3b82f6] shadow-[0_0_40px_rgba(59,130,246,0.2)]', 
        boton: 'bg-[#3b82f6] hover:bg-[#2563eb]',
        inputFocus: 'focus:border-[#3b82f6]'
      };
    default: return { texto: 'text-gray-500', borde: 'border-gray-800', boton: 'bg-gray-800', inputFocus: 'focus:border-gray-600' };
  }
});

// FUNCIÓN DE LOGIN REAL
const iniciarSesion = async () => {
  mensaje.texto = '';
  router.push('/dashboard/administrador');
  cargando.value = true;

  try {
    const data = await authService.login(credenciales.email, credenciales.password);
    
    if (data.exito) {
      // Guardamos al usuario de MongoDB
      localStorage.setItem('user', JSON.stringify(data.user));
      
      mensaje.texto = "¡Acceso concedido!";
      mensaje.tipo = 'success';

      // Redirección por Rol (el rol viene de la BD NoSQL)
      const rolDB = data.user.rol.toLowerCase();
      
      setTimeout(() => {
        if (rolDB === 'administrador') router.push('/admin');
        else if (rolDB === 'vendedor') router.push('/vendedor');
        else if (rolDB === 'consultor') router.push('/consultor');
      }, 1000);
    }
  } catch (error) {
    mensaje.texto = error.message || "Error al conectar con el servidor";
    mensaje.tipo = 'error';
  } finally {
    cargando.value = false;
  }
};
</script>

<template>
  <div class="fixed inset-0 bg-[#080d17] text-white flex flex-col font-sans overflow-hidden">
    
    <FondoMeteoritos />

    <div class="flex-1 w-full max-w-[1400px] mx-auto flex flex-col px-6 md:px-12 py-10 z-10 overflow-y-auto">
      
      <div class="text-center mt-4 mb-16 md:mb-24">
        <div class="text-5xl md:text-6xl mb-4">🧑‍🔧⚙️</div>
        <h1 class="text-4xl md:text-5xl font-bold tracking-[0.3em] mt-2 drop-shadow-lg uppercase">LOS AMIGOS</h1>
        <p class="text-xs md:text-sm text-gray-500 tracking-[0.4em] mt-3 uppercase">Refaccionaria Automotriz</p>
      </div>

      <div class="w-full flex justify-between md:justify-around items-center px-4 md:px-20 mb-16 md:mb-24">
        <div @click="rolActivo = 'administrador'" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'administrador' ? tema.borde : 'border-gray-800/50 opacity-50 group-hover:opacity-100 group-hover:border-gray-600']">🛡️</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'administrador' ? tema.texto : 'text-gray-600']">Administrador</span>
        </div>

        <div @click="rolActivo = 'vendedor'" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'vendedor' ? tema.borde : 'border-gray-800/50 opacity-50 group-hover:opacity-100 group-hover:border-gray-600']">📠</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'vendedor' ? tema.texto : 'text-gray-600']">Vendedor</span>
        </div>

        <div @click="rolActivo = 'consultor'" class="flex flex-col items-center cursor-pointer group w-1/3">
          <div :class="['w-20 h-20 md:w-28 md:h-28 rounded-3xl flex items-center justify-center text-4xl md:text-5xl border-[3px] transition-all duration-500 bg-[#0d1424]/80 backdrop-blur-sm', rolActivo === 'consultor' ? tema.borde : 'border-gray-800/50 opacity-50 group-hover:opacity-100 group-hover:border-gray-600']">🔍</div>
          <span :class="['mt-6 text-xs md:text-sm font-bold tracking-[0.2em] uppercase transition-colors duration-500', rolActivo === 'consultor' ? tema.texto : 'text-gray-600']">Consultor</span>
        </div>
      </div>

      <div class="w-full max-w-3xl mx-auto flex flex-col items-center">
        <h2 :class="['text-lg md:text-xl font-bold tracking-[0.3em] uppercase mb-10 transition-colors duration-500', tema.texto]">
          Iniciando como {{ rolActivo }}
        </h2>

        <div v-if="mensaje.texto" :class="['w-full p-4 rounded-lg text-sm text-center font-bold mb-6 tracking-wider backdrop-blur-md transition-all', mensaje.tipo === 'error' ? 'bg-red-500/10 text-red-400 border border-red-500/30' : 'bg-green-500/10 text-green-400 border border-green-500/30']">
          {{ mensaje.texto }}
        </div>

        <form @submit.prevent="iniciarSesion" class="w-full space-y-6">
          <div class="relative">
            <input v-model="credenciales.email" type="email" placeholder="Correo Electrónico" required :class="['w-full bg-[#0d1424]/80 backdrop-blur-sm border-b-2 border-gray-800 rounded-t-lg px-6 py-5 text-white placeholder-gray-600 outline-none transition-all duration-300 text-base md:text-lg', tema.inputFocus]">
          </div>
          <div class="relative">
            <input v-model="credenciales.password" type="password" placeholder="Contraseña" required :class="['w-full bg-[#0d1424]/80 backdrop-blur-sm border-b-2 border-gray-800 rounded-t-lg px-6 py-5 text-white placeholder-gray-600 outline-none transition-all duration-300 text-base md:text-lg', tema.inputFocus]">
          </div>
          
          <button type="submit" :disabled="cargando" :class="['w-full text-white font-bold py-5 rounded-lg mt-8 transition-all duration-500 text-sm md:text-base tracking-[0.3em] uppercase shadow-xl hover:-translate-y-1', tema.boton, cargando ? 'opacity-50 cursor-not-allowed' : '']">
            {{ cargando ? 'Validando en la Red...' : 'Iniciar Sesión' }}
          </button>
        </form>
      </div>

    </div>
  </div>
</template>