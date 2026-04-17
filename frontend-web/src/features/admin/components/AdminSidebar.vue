<script setup>
import { defineProps, defineEmits } from 'vue';
import { useRouter } from 'vue-router';

const props = defineProps({
  seccionActiva: String
});
const emit = defineEmits(['cambiarSeccion']);

const router = useRouter();

const cerrarSesion = () => {
  // Aquí puedes limpiar tus datos de sesión si los guardas en LocalStorage
  // localStorage.removeItem('token');
  // localStorage.removeItem('userRol');
  
  // Te redirige a la pantalla de Login (ajusta la ruta '/' si tu login se llama diferente)
  router.push('/'); 
};


</script>


<template>
  <aside class="sidebar">
    <div class="brand-box">
      <h2>REFACCIONARIA<span> LOS AMIGOS</span></h2>
    </div>
    <nav class="menu">
      <div class="nav-item" :class="{active: seccionActiva==='dashboard'}" @click="emit('cambiarSeccion', 'dashboard')">📊 Overview</div>
      <div class="nav-item" :class="{active: seccionActiva==='usuarios'}" @click="emit('cambiarSeccion', 'usuarios')">👥 Personal</div>
      <div class="nav-item" :class="{active: seccionActiva==='productos'}" @click="emit('cambiarSeccion', 'productos')">📦 Almacén</div>
    </nav>

    <div class="logout-container">
      <button class="logout-btn" @click="cerrarSesion">
        <span class="icon">🚪</span> CERRAR SESIÓN
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar { 
  width: 260px; 
  background: rgba(5, 10, 20, 0.8);
  backdrop-filter: blur(15px);
  padding: 30px; 
  border-right: 1px solid rgba(0, 210, 255, 0.2); 
  display: flex;
  flex-direction: column;
}
.brand-box {
  display: flex;
  align-items: center;
  gap: 15px;
  margin-bottom: 50px;
}
.logo-neon { 
  background: linear-gradient(135deg, #00d2ff, #3a7bd5); 
  color: #fff; 
  width: 45px; 
  height: 45px; 
  border-radius: 12px; 
  display: flex; 
  align-items: center; 
  justify-content: center; 
  font-weight: 900; 
  font-size: 1.5rem;
  box-shadow: 0 0 20px rgba(0, 210, 255, 0.6); 
}
h2 {
  font-size: 1.2rem;
  color: #fff;
  letter-spacing: 2px;
  margin: 0;
}
h2 span {
  color: #00d2ff;
  text-shadow: 0 0 5px rgba(0, 210, 255, 0.5);
}
.menu {
  display: flex;
  flex-direction: column;
  gap: 10px;
}
.nav-item { 
  padding: 15px 20px; 
  border-radius: 12px; 
  cursor: pointer; 
  color: #8ba3cb; 
  transition: all 0.3s ease;
  font-weight: 500;
  display: flex;
  align-items: center;
  gap: 12px;
  border: 1px solid transparent;
}
.nav-item:hover {
  background: rgba(0, 210, 255, 0.05);
  color: #00d2ff;
  border: 1px solid rgba(0, 210, 255, 0.3);
  box-shadow: 0 0 15px rgba(0, 210, 255, 0.1);
}
.nav-item.active { 
  background: linear-gradient(90deg, rgba(0, 210, 255, 0.15) 0%, transparent 100%); 
  color: #00d2ff; 
  font-weight: bold; 
  border-left: 4px solid #00d2ff;
  box-shadow: -5px 0 15px rgba(0, 210, 255, 0.2);
}

/* Asegúrate de que .sidebar sea flex column (probablemente ya lo tengas así) */
.sidebar {
  /* ... tus otros estilos ... */
  display: flex;
  flex-direction: column;
}

/* El nav tomará todo el espacio sobrante, empujando el botón hacia abajo */
.menu {
  flex: 1;
}

/* Estilos del contenedor de salida */
.logout-container {
  margin-top: auto; /* Esto es la magia que lo empuja hasta el fondo */
  padding-top: 20px;
  border-top: 1px solid rgba(0, 210, 255, 0.1);
}

/* Diseño del botón estilo Alerta / Neón Rojo */
.logout-btn {
  width: 100%;
  background: transparent;
  border: 1px solid rgba(255, 76, 76, 0.3);
  color: #ff4c4c;
  padding: 12px;
  border-radius: 8px;
  cursor: pointer;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
  transition: all 0.3s ease;
  font-family: inherit;
  letter-spacing: 1px;
}

.logout-btn:hover {
  background: rgba(255, 76, 76, 0.1);
  border-color: #ff4c4c;
  box-shadow: 0 0 15px rgba(255, 76, 76, 0.2);
  color: #fff;
}
</style>
