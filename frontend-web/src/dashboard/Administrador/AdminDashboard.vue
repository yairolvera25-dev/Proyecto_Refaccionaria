<script setup>
import { ref, computed } from "vue";

const seccionActiva = ref("productos");
const busqueda = ref("");
const mostrarModal = ref(false);
const modoEdicion = ref(false);
const idEditando = ref(null);

const formulario = ref({
  nombre: "",
  detalle: "",
  precio: "",
  usuario: "",
  rol: ""
});

const productos = ref([
  { id: 1, nombre: "Filtro de Aceite G2", detalle: "Motor", precio: "180.00" },
  { id: 2, nombre: "Bujía NGK", detalle: "Motor", precio: "120.00" }
]);

const usuarios = ref([
  { id: 1, nombre: "Juan Pérez", detalle: "Administrador", precio: "Activo" },
  { id: 2, nombre: "Carlos Ruiz", detalle: "Vendedor", precio: "Activo" }
]);

const roles = ref([
  { id: 1, usuario: "Juan Pérez", rol: "Administrador" },
  { id: 2, usuario: "Carlos Ruiz", rol: "Vendedor" }
]);

const datosFiltrados = computed(() => {
  let lista = [];

  if (seccionActiva.value === "productos") lista = productos.value;
  if (seccionActiva.value === "usuarios") lista = usuarios.value;
  if (seccionActiva.value === "roles") lista = roles.value;

  return lista.filter(item =>
    JSON.stringify(item).toLowerCase().includes(busqueda.value.toLowerCase())
  );
});

const abrirModalNuevo = () => {
  modoEdicion.value = false;
  formulario.value = {
    nombre: "",
    detalle: "",
    precio: "",
    usuario: "",
    rol: ""
  };
  mostrarModal.value = true;
};

const guardarRegistro = () => {
  let lista;

  if (seccionActiva.value === "productos") {
    lista = productos;
  } else if (seccionActiva.value === "usuarios") {
    lista = usuarios;
  } else {
    lista = roles;
  }

  if (modoEdicion.value) {
    const index = lista.value.findIndex(
      item => item.id === idEditando.value
    );

    lista.value[index] = {
      ...lista.value[index],
      ...formulario.value
    };
  } else {
    lista.value.push({
      id: Date.now(),
      ...formulario.value
    });
  }

  mostrarModal.value = false;
};

const editarRegistro = (item) => {
  modoEdicion.value = true;
  idEditando.value = item.id;
  formulario.value = { ...item };
  mostrarModal.value = true;
};

const eliminarRegistro = (id) => {
  let lista;

  if (seccionActiva.value === "productos") lista = productos;
  if (seccionActiva.value === "usuarios") lista = usuarios;
  if (seccionActiva.value === "roles") lista = roles;

  lista.value = lista.value.filter(item => item.id !== id);
};

const textoBoton = computed(() => {
  if (seccionActiva.value === "productos") return "+ Nuevo Producto";
  if (seccionActiva.value === "usuarios") return "+ Nuevo Usuario";
  if (seccionActiva.value === "roles") return "+ Asignar Rol";
  return "+ Nuevo";
});
</script>

<template>
  <div class="main-layout">

    <aside class="sidebar">
      <h2>🚀 REFA AMIGOS</h2>

      <div class="nav-item" :class="{active: seccionActiva==='productos'}" @click="seccionActiva='productos'">
        📦 Productos
      </div>

      <div class="nav-item" :class="{active: seccionActiva==='usuarios'}" @click="seccionActiva='usuarios'">
        👥 Usuarios
      </div>

      <div class="nav-item" :class="{active: seccionActiva==='roles'}" @click="seccionActiva='roles'">
        🛡️ Roles
      </div>

      <div class="nav-item" :class="{active: seccionActiva==='reportes'}" @click="seccionActiva='reportes'">
        📊 Reportes
      </div>
    </aside>

    <main class="content-area">
      <div class="top-bar">
        <h1>{{ seccionActiva.toUpperCase() }}</h1>

        <div>
          <input v-model="busqueda" class="search-box" placeholder="Buscar...">
          <button v-if="seccionActiva !== 'reportes'" class="btn-add" @click="abrirModalNuevo">
            {{ textoBoton }}
          </button>
        </div>
      </div>

      <div class="dashboard-box">

        <table v-if="seccionActiva !== 'reportes'" class="styled-table">
          <thead>
            <tr>
              <th>ID</th>
              <th>NOMBRE / USUARIO</th>
              <th>DETALLE / ROL</th>
              <th>VALOR / ESTADO</th>
              <th>ACCIONES</th>
            </tr>
          </thead>

          <tbody>
            <tr v-for="item in datosFiltrados" :key="item.id">
              <td>{{ item.id }}</td>
              <td>{{ item.nombre || item.usuario }}</td>
              <td>{{ item.detalle || item.rol }}</td>
              <td>{{ item.precio || '-' }}</td>
              <td>
                <button class="btn-edit" @click="editarRegistro(item)">✏️</button>
                <button class="btn-delete" @click="eliminarRegistro(item.id)">🗑️</button>
              </td>
            </tr>
          </tbody>
        </table>

        <div v-else class="cards">
          <div class="card">
            <h3>Productos</h3>
            <p>{{ productos.length }}</p>
          </div>
          <div class="card">
            <h3>Usuarios</h3>
            <p>{{ usuarios.length }}</p>
          </div>
          <div class="card">
            <h3>Roles</h3>
            <p>{{ roles.length }}</p>
          </div>
        </div>

      </div>
    </main>

    <div v-if="mostrarModal" class="modal-overlay">
      <div class="modal-card">
        <h3>{{ textoBoton }}</h3>

        <template v-if="seccionActiva === 'productos'">
          <input v-model="formulario.nombre" class="modal-input" placeholder="Nombre del producto">
          <input v-model="formulario.detalle" class="modal-input" placeholder="Detalle">
          <input v-model="formulario.precio" class="modal-input" placeholder="Precio">
        </template>

        <template v-else-if="seccionActiva === 'usuarios'">
          <input v-model="formulario.nombre" class="modal-input" placeholder="Nombre del usuario">
          <input v-model="formulario.detalle" class="modal-input" placeholder="Puesto">
          <input v-model="formulario.precio" class="modal-input" placeholder="Estado">
        </template>

        <template v-else-if="seccionActiva === 'roles'">
          <input v-model="formulario.usuario" class="modal-input" placeholder="Usuario">
          <input v-model="formulario.rol" class="modal-input" placeholder="Rol">
        </template>

        <button class="btn-save" @click="guardarRegistro">
          Guardar
        </button>
      </div>
    </div>

  </div>
</template>

<style scoped>
*{box-sizing:border-box;margin:0;padding:0}
.main-layout{display:flex;width:100vw;height:100vh;background:#0b1120;color:white;font-family:Arial}
.sidebar{width:260px;background:#0f172a;padding:30px}
.nav-item{padding:15px;margin:10px 0;border-radius:10px;background:#1e293b;cursor:pointer}
.active{background:#22d3ee;color:black;font-weight:bold}
.content-area{flex:1;padding:40px}
.top-bar{display:flex;justify-content:space-between;margin-bottom:30px}
.search-box{padding:10px;border:none;border-radius:10px;background:#1e293b;color:white}
.btn-add,.btn-save{padding:10px 20px;border:none;border-radius:10px;background:#22d3ee;font-weight:bold;cursor:pointer;margin-left:10px}
.dashboard-box{background:#111827;padding:30px;border-radius:20px;height:calc(100vh - 140px)}
.styled-table{width:100%;border-collapse:collapse}
th,td{padding:15px;text-align:left}
.btn-edit,.btn-delete{padding:8px;border:none;border-radius:8px;margin-right:8px;cursor:pointer}
.cards{display:grid;grid-template-columns:repeat(3,1fr);gap:20px}
.card{background:#1e293b;padding:30px;border-radius:20px}
.modal-overlay{position:fixed;inset:0;background:rgba(0,0,0,.7);display:flex;justify-content:center;align-items:center}
.modal-card{width:450px;background:#0f172a;padding:30px;border-radius:20px}
.modal-input{width:100%;padding:14px;margin-bottom:15px;border:none;border-radius:10px;background:#1e293b;color:white}
</style>