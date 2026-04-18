<script setup>
import { ref, reactive } from 'vue';
import FondoMeteoritos from '@/shared/components/FondoMeteoritos.vue';
import { useRouter } from 'vue-router';
import { authService } from '@/core/services/authService';
import { z } from 'zod';

const router = useRouter();

const cargando = ref(false);
const mensaje = reactive({ texto: '', tipo: '' });
const form = reactive({ nombre: '', email: '', password: '' });
const erroresZod = reactive({ nombre: '', email: '', password: '' });

// Validaciones Zod Estrictas
const registerSchema = z.object({
  nombre: z.string().min(1, 'El nombre no puede estar vacÃ­o').min(3, 'El nombre debe tener al menos 3 letras'),
  email: z.string().min(1, 'El correo no puede estar vacÃ­o').email('Formato de correo invÃ¡lido'),
  password: z.string().min(3, 'MÃ­nimo 3 caracteres')
});

import { computed } from 'vue';
const botonBloqueado = computed(() => {
  if (!form.nombre || !form.email || !form.password) return true;
  return !registerSchema.safeParse(form).success;
});


const solicitarRol = async () => {
  mensaje.texto = '';
  erroresZod.nombre = '';
  erroresZod.email = '';
  erroresZod.password = '';

  const result = registerSchema.safeParse(form);
  if (!result.success) {
    const fieldErrors = result.error.format();
    if (fieldErrors.nombre) erroresZod.nombre = fieldErrors.nombre._errors[0];
    if (fieldErrors.email) erroresZod.email = fieldErrors.email._errors[0];
    if (fieldErrors.password) erroresZod.password = fieldErrors.password._errors[0];
    
    mensaje.texto = "Error. Corrige los campos resaltados en neÃ³n naranja.";
    mensaje.tipo = 'error';
    return;
  }

  cargando.value = true;
  try {
    const respuesta = await authService.register({
      nombre: form.nombre,
      email: form.email,
      password: form.password,
      nombre_rol: 'Consultor' // Default role unless overridden
    });

    mensaje.texto = "ÂSolicitud enviada. Queda pendiente de aprobación por un administrador.";
    mensaje.tipo = 'success';
    
    setTimeout(() => {
      router.push('/');
    }, 1500);

  } catch (error) {
    mensaje.texto = error.message || "Error al registrar en el servidor.";
    mensaje.tipo = 'error';
  } finally {
    cargando.value = false;
  }
};
</script>

<template>
  <div class="fixed inset-0 bg-[#080d17] text-white flex flex-col font-sans overflow-hidden">
    <FondoMeteoritos />

    <div class="flex-1 w-full max-w-[1400px] mx-auto flex flex-col px-6 md:px-12 py-10 z-10 overflow-y-auto items-center justify-center">
      
      <div class="text-center w-full mb-10">
        <h1 class="text-3xl md:text-5xl font-bold tracking-[0.3em] mb-4 drop-shadow-[0_0_15px_rgba(255,100,0,0.4)] text-[#ff7300]">NUEVA CREDENCIAL</h1>
        <p class="text-xs md:text-sm text-gray-500 tracking-[0.4em] uppercase">Solicita acceso al sistema (Esperando AprobaciÃ³n)</p>
      </div>

      <div class="w-full max-w-xl mx-auto flex flex-col items-center">
        <div v-if="mensaje.texto" :class="['w-full p-4 rounded-lg text-sm text-center font-bold mb-6 tracking-wider backdrop-blur-md transition-all', mensaje.tipo === 'error' ? 'bg-[#ff3300]/10 text-[#ff3300] border border-[#ff3300]/30' : 'bg-green-500/10 text-green-400 border border-green-500/30']">
          {{ mensaje.texto }}
        </div>

        <form @submit.prevent="solicitarRol" class="w-full space-y-6">
          <div class="relative">
            <input v-model="form.nombre" type="text" placeholder="Nombre Completo" :class="['w-full bg-[#0d1424]/80 backdrop-blur-sm border-b-2 rounded-t-lg px-6 py-5 text-white placeholder-gray-600 outline-none transition-all duration-300 text-base', erroresZod.nombre ? 'border-[#ff5e00] shadow-[0_0_15px_rgba(255,94,0,0.5)] focus:border-[#ff5e00]' : 'border-gray-800 focus:border-gray-500']">
            <p v-if="erroresZod.nombre" class="mt-2 text-[#ff5e00] text-xs font-bold drop-shadow-[0_0_5px_rgba(255,94,0,0.8)] tracking-wide">{{ erroresZod.nombre }}</p>
          </div>

          <div class="relative">
            <input v-model="form.email" type="email" placeholder="Correo de contacto corporativo" :class="['w-full bg-[#0d1424]/80 backdrop-blur-sm border-b-2 rounded-t-lg px-6 py-5 text-white placeholder-gray-600 outline-none transition-all duration-300 text-base', erroresZod.email ? 'border-[#ff5e00] shadow-[0_0_15px_rgba(255,94,0,0.5)] focus:border-[#ff5e00]' : 'border-gray-800 focus:border-gray-500']">
            <p v-if="erroresZod.email" class="mt-2 text-[#ff5e00] text-xs font-bold drop-shadow-[0_0_5px_rgba(255,94,0,0.8)] tracking-wide">{{ erroresZod.email }}</p>
          </div>

          <div class="relative">
            <input v-model="form.password" type="password" placeholder="ContraseÃ±a de nueva cuenta" :class="['w-full bg-[#0d1424]/80 backdrop-blur-sm border-b-2 rounded-t-lg px-6 py-5 text-white placeholder-gray-600 outline-none transition-all duration-300 text-base', erroresZod.password ? 'border-[#ff5e00] shadow-[0_0_15px_rgba(255,94,0,0.5)] focus:border-[#ff5e00]' : 'border-gray-800 focus:border-gray-500']">
            <p v-if="erroresZod.password" class="mt-2 text-[#ff5e00] text-xs font-bold drop-shadow-[0_0_5px_rgba(255,94,0,0.8)] tracking-wide">{{ erroresZod.password }}</p>
          </div>
          
          <button type="submit" :disabled="cargando || botonBloqueado" :class="['w-full text-white font-bold py-5 rounded-lg mt-8 transition-all duration-500 text-sm tracking-[0.3em] uppercase shadow-[0_0_20px_rgba(255,94,0,0.4)] hover:-translate-y-1', (cargando || botonBloqueado) ? 'bg-gray-600 opacity-50 cursor-not-allowed shadow-none' : 'bg-[#ff5e00] hover:bg-[#d94f00]']">
            {{ cargando ? 'Validando Formato...' : 'Solicitar Rol' }}
          </button>
        </form>

        <div class="mt-8 text-xs text-gray-500 tracking-widest hover:text-white transition-colors cursor-pointer border-b border-gray-800 pb-1" @click="router.push('/')">
          &lt; REGRESAR AL LOGIN
        </div>
      </div>
    </div>
  </div>
</template>

