<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";

defineProps({
  seccionActiva: String
});

const emit = defineEmits(["cambiarSeccion"]);
const router = useRouter();
const user = ref(null);

onMounted(() => {
  const raw = localStorage.getItem("user");
  user.value = raw ? JSON.parse(raw) : null;
});

const cerrarSesion = () => {
  localStorage.clear();
  router.push("/");
};
</script>

<template>
  <aside class="sidebar">
    <div class="brand-box">
      <div class="user-box">
        <p class="user-name">{{ user?.nombre || 'Administrador' }}</p>
        <small class="user-role">{{ user?.rol || 'Sin rol' }}</small>
      </div>

      <h2>REFACCIONARIA <span>LOS AMIGOS</span></h2>
    </div>

    <nav class="menu">
      <div class="nav-item" :class="{ active: seccionActiva === 'dashboard' }" @click="emit('cambiarSeccion', 'dashboard')">
        📊 Overview
      </div>

      <div class="nav-item" :class="{ active: seccionActiva === 'usuarios' }" @click="emit('cambiarSeccion', 'usuarios')">
        👥 Personal
      </div>

      <div class="nav-item" :class="{ active: seccionActiva === 'productos' }" @click="emit('cambiarSeccion', 'productos')">
        📦 Almacén
      </div>

      <div class="nav-item" :class="{ active: seccionActiva === 'ventas' }" @click="emit('cambiarSeccion', 'ventas')">
        💳 Ventas
      </div>

      <div class="nav-item" :class="{ active: seccionActiva === 'reportes' }" @click="emit('cambiarSeccion', 'reportes')">
        📈 Reportes
      </div>
    </nav>

    <div class="logout-container">
      <button class="logout-btn" @click="cerrarSesion">
        <span class="icon">⏻</span> CERRAR SESIÓN
      </button>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 100%; /* 👈 Se adapta al ancho que le dé su contenedor padre */
  height: 100%; /* 👈 Ocupa todo el alto disponible */
  box-sizing: border-box; /* 👈 Evita que el padding lo haga más gordo */
  background: transparent; /* El color de fondo lo maneja el padre en móviles */
  padding: 20px; /* Reduje un poquito el padding general */
  border-right: none; /* Quitamos el borde aquí para que lo maneje el padre */
  display: flex;
  flex-direction: column;
  overflow-y: auto; /* Por si el menú crece mucho hacia abajo */
}

/* En escritorio, le regresamos sus estilos originales */
@media (min-width: 768px) {
  .sidebar {
    width: 260px;
    background: rgba(5, 10, 20, 0.8);
    backdrop-filter: blur(15px);
    padding: 30px;
    border-right: 1px solid rgba(0, 210, 255, 0.2);
  }
}

.brand-box {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 30px;
}
.user-box {
  background: rgba(0, 210, 255, 0.05);
  border: 1px solid rgba(0, 210, 255, 0.15);
  border-radius: 12px;
  padding: 12px 14px;
}
.user-name {
  margin: 0;
  color: white;
  font-weight: 700;
}
.user-role {
  color: #00d2ff;
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
  flex: 1;
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
.logout-container {
  margin-top: auto;
  padding-top: 20px;
  border-top: 1px solid rgba(0, 210, 255, 0.1);
}
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