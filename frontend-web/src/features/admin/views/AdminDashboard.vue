<script setup>
import { ref } from "vue";
import AdminSidebar from '@/features/admin/components/AdminSidebar.vue'
import PersonalAdmin from '@/features/admin/views/PersonalAdmin.vue';
import AlmacenAdmin from '@/features/admin/views/AlmacenAdmin.vue';
import ReportesVentasAdmin from '@/features/admin/views/ReportesVentasAdmin.vue';
import VentasAdmin from '@/features/admin/views/VentasAdmin.vue';

const seccionActiva = ref("dashboard");
const menuMovilAbierto = ref(false); // Estado para controlar el menú en móviles
</script>

<template>
  <div class="app-shell">
    
    <button class="mobile-menu-btn" @click="menuMovilAbierto = !menuMovilAbierto">
      <span v-if="!menuMovilAbierto">☰ MENÚ</span>
      <span v-else>✕ CERRAR</span>
    </button>

    <div class="sidebar-container" :class="{ 'open': menuMovilAbierto }">
      <AdminSidebar
        :seccionActiva="seccionActiva"
        @cambiarSeccion="s => { 
          seccionActiva = s; 
          menuMovilAbierto = false; /* Cierra el menú al elegir una opción */
        }"
      />
    </div>

    <div 
      v-if="menuMovilAbierto" 
      class="mobile-overlay" 
      @click="menuMovilAbierto = false"
    ></div>

    <main class="viewport">
      <div v-if="seccionActiva === 'usuarios'">
        <PersonalAdmin />
      </div>

      <div v-else-if="seccionActiva === 'productos'">
        <AlmacenAdmin />
      </div>

      <div v-else-if="seccionActiva === 'ventas'">
        <VentasAdmin />
      </div>

      <div v-else-if="seccionActiva === 'reportes'">
        <ReportesVentasAdmin />
      </div>

      <div v-else class="welcome-screen">
        <div class="glass-hero shadow-neon">
          <div class="hero-content">
            <h1 class="gradient-text text-glow">BIENVENIDO, ADMINISTRADOR</h1>
            <p class="subtitle">CENTRO DE MANDO INTEGRAL</p>

            <div class="identity-grid">
              <div class="badge-card">
                <span class="badge-icon">👤</span>
                <div class="badge-info">
                  <span class="badge-label">USUARIO ACTIVO</span>
                  <span class="badge-value">Administrador</span>
                </div>
              </div>

              <div class="badge-card">
                <span class="badge-icon">🏢</span>
                <div class="badge-info">
                  <span class="badge-label">SUCURSAL</span>
                  <span class="badge-value">Matriz</span>
                </div>
              </div>

              <div class="badge-card">
                <span class="badge-icon">🟢</span>
                <div class="badge-info">
                  <span class="badge-label">ESTADO DE RED</span>
                  <span class="badge-value neon-status">
                    <span class="status-dot"></span> Conexión Segura
                  </span>
                </div>
              </div>
            </div>

            <p class="connection-info">
              <span class="db-tag">Laravel API</span> |
              <span class="db-tag">MySQL Laragon</span> |
              <span class="db-tag">MongoDB Atlas</span>
            </p>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>
/* --- ESTILOS DEL LAYOUT Y MENÚ RESPONSIVO --- */

.app-shell {
  display: flex;
  flex-direction: column;
  height: 100vh;
  width: 100vw;
  box-sizing: border-box;
  background: radial-gradient(circle at top right, #0a192f, #02040a);
  color: #fff;
  font-family: 'Inter', sans-serif;
  overflow: hidden;
  position: relative; /* Necesario para el overlay */
}

/* Botón Hamburguesa */
.mobile-menu-btn {
  display: block;
  background: rgba(10, 25, 47, 0.95);
  color: #00d2ff;
  border: none;
  border-bottom: 1px solid rgba(0, 210, 255, 0.2);
  padding: 15px 20px;
  font-size: 1rem;
  font-weight: bold;
  text-align: left;
  cursor: pointer;
  z-index: 50; /* Por encima de todo */
  letter-spacing: 2px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
}

/* Contenedor del menú lateral */
.sidebar-container {
  position: absolute;
  top: 50px; /* Altura aproximada del botón hamburguesa */
  left: -100%; /* Oculto fuera de la pantalla por defecto */
  width: 260px;
  height: calc(100vh - 50px);
  background: #02040a;
  z-index: 40;
  transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 5px 0 20px rgba(0, 0, 0, 0.8);
  border-right: 1px solid rgba(0, 210, 255, 0.2);
}

/* Clase que se activa cuando menuMovilAbierto es true */
.sidebar-container.open {
  left: 0;
}

/* Fondo oscuro al abrir el menú en móvil */
.mobile-overlay {
  position: fixed;
  top: 50px;
  left: 0;
  width: 100vw;
  height: calc(100vh - 50px);
  background: rgba(2, 6, 23, 0.7);
  backdrop-filter: blur(2px);
  z-index: 30;
}

/* Contenido Principal */
.viewport {
  flex: 1;
  min-width: 0;
  box-sizing: border-box;
  padding: 20px; /* Reducido para móviles */
  overflow-y: auto;
  overflow-x: hidden;
  background: transparent;
}

/* --- CUANDO LA PANTALLA ES GRANDE (ESCRITORIO) --- */
@media (min-width: 768px) {
  .app-shell {
    flex-direction: row; /* Vuelve a estar uno al lado del otro */
  }
  
  .mobile-menu-btn,
  .mobile-overlay {
    display: none; /* Oculta el botón y el overlay */
  }

  .sidebar-container {
    position: static; /* Vuelve a su flujo normal */
    left: 0;
    width: auto;
    height: 100vh;
    box-shadow: none;
    border-right: none;
  }

  .viewport {
    padding: 40px; /* Padding original para escritorio */
  }
}

/* --- ESTILOS DE LAS TARJETAS Y CONTENIDO --- */

.identity-grid {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  gap: 20px;
  margin-bottom: 40px;
}
@media (min-width: 768px) {
  .identity-grid {
    flex-direction: row;
    justify-content: center;
  }
}
.badge-card {
  background: rgba(0, 210, 255, 0.05);
  border: 1px solid rgba(0, 210, 255, 0.2);
  padding: 15px 25px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  gap: 15px;
  transition: transform 0.3s ease, border-color 0.3s ease;
}
.badge-card:hover {
  transform: translateY(-5px);
  border-color: rgba(0, 210, 255, 0.6);
  background: rgba(0, 210, 255, 0.1);
  box-shadow: 0 5px 15px rgba(0, 210, 255, 0.2);
}
.badge-icon {
  font-size: 1.8rem;
}
.badge-info {
  display: flex;
  flex-direction: column;
  text-align: left;
}
.badge-label {
  font-size: 0.7rem;
  color: #8ba3cb;
  letter-spacing: 1px;
}
.badge-value {
  font-size: 1.1rem;
  font-weight: bold;
  color: #fff;
}
.neon-status {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #00ff88;
  text-shadow: 0 0 10px rgba(0, 255, 136, 0.4);
}
.status-dot {
  width: 8px;
  height: 8px;
  background-color: #00ff88;
  border-radius: 50%;
  box-shadow: 0 0 8px #00ff88;
  animation: blink 1.5s infinite;
}
@keyframes blink {
  0% { opacity: 0.4; }
  50% { opacity: 1; box-shadow: 0 0 15px #00ff88; }
  100% { opacity: 0.4; }
}
.db-tag {
  color: #00d2ff;
  font-weight: bold;
}

.welcome-screen {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.glass-hero {
  background: rgba(15, 23, 42, 0.4);
  backdrop-filter: blur(20px);
  padding: 30px; /* Reducido para mejor visualización en móvil */
  border-radius: 20px; /* Reducido un poco para móvil */
  border: 1px solid rgba(0, 210, 255, 0.1);
  text-align: center;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}
@media (min-width: 768px) {
    .glass-hero {
        padding: 60px;
        border-radius: 40px;
    }
}
.gradient-text {
  font-size: 2rem; /* Más pequeño para móvil */
  font-weight: 800;
  background: linear-gradient(to right, #00d2ff, #3a7bd5);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 10px;
  letter-spacing: -1px;
}
@media (min-width: 768px) {
    .gradient-text {
        font-size: 3.5rem; /* Tamaño original en PC */
    }
}
.subtitle {
  color: #8ba3cb;
  font-size: 1rem;
  letter-spacing: 2px;
  text-transform: uppercase;
  margin-bottom: 30px;
}
@media (min-width: 768px) {
    .subtitle {
        font-size: 1.2rem;
        letter-spacing: 4px;
        margin-bottom: 40px;
    }
}
.connection-info {
  color: #94a3b8;
  font-size: 0.8rem;
  font-style: italic;
  display: flex;
  flex-direction: column; /* Apilado en móvil */
  gap: 5px;
}
@media (min-width: 768px) {
    .connection-info {
        font-size: 0.9rem;
        flex-direction: row; /* En línea en PC */
        justify-content: center;
    }
    .connection-info span:not(:last-child):after {
        content: " | ";
        margin: 0 5px;
    }
}
</style>