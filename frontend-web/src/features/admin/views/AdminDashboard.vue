<script setup>
import { ref } from "vue";
import AdminSidebar from '../components/AdminSidebar.vue'
import PersonalAdmin from './PersonalAdmin.vue';
import AlmacenAdmin from './AlmacenAdmin.vue';

const seccionActiva = ref("dashboard");
</script>

<template>
  <div class="app-shell">
    <AdminSidebar 
      :seccionActiva="seccionActiva" 
      @cambiarSeccion="s => seccionActiva = s" 
    />

    <main class="viewport">
      <div v-if="seccionActiva === 'usuarios'">
        <PersonalAdmin />
      </div>
      
      <div v-else-if="seccionActiva === 'productos'">
        <AlmacenAdmin />
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
                  <span class="badge-value">Yair Olvera (Admin)</span>
                </div>
              </div>

              <div class="badge-card">
                <span class="badge-icon">🏢</span>
                <div class="badge-info">
                  <span class="badge-label">SUCURSAL</span>
                  <span class="badge-value">Matriz Pachuca</span>
                </div>
              </div>

              <div class="badge-card">
                <span class="badge-icon pulse-soft">🔒</span>
                <div class="badge-info">
                  <span class="badge-label">ESTADO DE RED</span>
                  <span class="badge-value neon-status">
                    <span class="status-dot"></span> Conexión Segura
                  </span>
                </div>
              </div>
            </div>

            <p class="connection-info">
              <span class="db-tag">MongoDB Atlas</span> Cloud Sync &nbsp; | &nbsp; 
              <span class="db-tag">MariaDB Virtual</span> Local Core
            </p>
          </div>
        </div>
      </div>
    </main>
  </div>
</template>

<style scoped>

.identity-grid {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 40px;
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
.app-shell { 
  display: flex; 
  height: 100vh; 
  width: 100%;
  box-sizing: border-box;
  background: radial-gradient(circle at top right, #0a192f, #02040a);
  color: #fff; 
  font-family: 'Inter', sans-serif; 
  overflow: hidden;
}

.viewport { 
  flex: 1; 
  width: 100%;
  box-sizing: border-box;
  padding: 40px; 
  overflow-y: auto; 
  overflow-x: hidden;
  background: transparent;
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
  padding: 60px;
  border-radius: 40px;
  border: 1px solid rgba(0, 210, 255, 0.1);
  text-align: center;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
}

.gradient-text {
  font-size: 3.5rem;
  font-weight: 800;
  background: linear-gradient(to right, #00d2ff, #3a7bd5);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 10px;
  letter-spacing: -1px;
}

.subtitle {
  color: #8ba3cb;
  font-size: 1.2rem;
  letter-spacing: 4px;
  text-transform: uppercase;
  margin-bottom: 40px;
}

.stats-overview {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-bottom: 40px;
}

.stat-card {
  background: rgba(0, 210, 255, 0.05);
  padding: 15px 30px;
  border-radius: 15px;
  border: 1px solid rgba(0, 210, 255, 0.1);
  display: flex;
  flex-direction: column;
}

.stat-label {
  font-size: 0.7rem;
  color: #8ba3cb;
  letter-spacing: 2px;
}

.stat-value {
  font-weight: bold;
  color: #00d2ff;
}

.pulse {
  animation: pulse-glow 2s infinite;
}

@keyframes pulse-glow {
  0% { text-shadow: 0 0 5px rgba(0, 210, 255, 0.5); }
  50% { text-shadow: 0 0 20px rgba(0, 210, 255, 0.8); }
  100% { text-shadow: 0 0 5px rgba(0, 210, 255, 0.5); }
}

.connection-info {
  color: #475569;
  font-size: 0.9rem;
  font-style: italic;
}
</style>

