<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";

const usuarios = ref([]);
const cargando = ref(false);

const mostrarModalRol = ref(false);
const usuarioSeleccionado = ref(null);
const rolSeleccionado = ref("Vendedor");

const mostrarModalNuevo = ref(false);
const nuevoUsuario = ref({
  nombre: "",
  email: "",
  password: "",
  nombre_rol: "Vendedor"
});

const mostrarModalEditar = ref(false);
const usuarioEditar = ref({
  _id: null,
  nombre: "",
  email: ""
});

const API = `${import.meta.env.VITE_API_URL_NOSQL}/auth`;
const rolesDisponibles = ["Administrador", "Vendedor", "Consultor"];

const cargar = async () => {
  try {
    cargando.value = true;
    const res = await axios.get(API);
    usuarios.value = res.data;
  } catch (error) {
    console.error("Error cargando usuarios:", error);
  } finally {
    cargando.value = false;
  }
};

const pendientes = computed(() => usuarios.value.filter(u => !u.activo));
const activos = computed(() => usuarios.value.filter(u => u.activo));

const abrirModalRol = (usuario) => {
  usuarioSeleccionado.value = usuario;
  rolSeleccionado.value = "Vendedor";
  mostrarModalRol.value = true;
};

const cerrarModalRol = () => {
  mostrarModalRol.value = false;
  usuarioSeleccionado.value = null;
  rolSeleccionado.value = "Vendedor";
};

const confirmarAprobacion = async () => {
  if (!usuarioSeleccionado.value) return;

  try {
    await axios.put(`${API}/${usuarioSeleccionado.value._id}`, {
      nombre: usuarioSeleccionado.value.nombre,
      email: usuarioSeleccionado.value.email,
      nombre_rol: rolSeleccionado.value,
      activo: true
    });

    await cargar();
    cerrarModalRol();
  } catch (error) {
    console.error("Error aprobando usuario:", error);
    alert("No se pudo aprobar el usuario");
  }
};

const abrirModalNuevo = () => {
  nuevoUsuario.value = {
    nombre: "",
    email: "",
    password: "",
    nombre_rol: "Vendedor"
  };
  mostrarModalNuevo.value = true;
};

const cerrarModalNuevo = () => {
  mostrarModalNuevo.value = false;
};

const crearNuevoUsuario = async () => {
  try {
    if (!nuevoUsuario.value.nombre || !nuevoUsuario.value.email || !nuevoUsuario.value.password) {
      alert("Completa todos los campos");
      return;
    }

    await axios.post(`${API}/register`, {
      nombre: nuevoUsuario.value.nombre,
      email: nuevoUsuario.value.email,
      password: nuevoUsuario.value.password
    });

    const res = await axios.get(API);
    const creado = res.data.find(u => u.email === nuevoUsuario.value.email);

    if (creado) {
      await axios.put(`${API}/${creado._id}`, {
        nombre: creado.nombre,
        email: creado.email,
        nombre_rol: nuevoUsuario.value.nombre_rol,
        activo: true
      });
    }

    await cargar();
    cerrarModalNuevo();
  } catch (error) {
    console.error("Error creando usuario:", error);
    alert(error?.response?.data?.msg || "No se pudo crear el usuario");
  }
};

const abrirModalEditar = (usuario) => {
  usuarioEditar.value = {
    _id: usuario._id,
    nombre: usuario.nombre,
    email: usuario.email
  };
  mostrarModalEditar.value = true;
};

const cerrarModalEditar = () => {
  mostrarModalEditar.value = false;
  usuarioEditar.value = {
    _id: null,
    nombre: "",
    email: ""
  };
};

const guardarEdicion = async () => {
  try {
    const original = usuarios.value.find(u => u._id === usuarioEditar.value._id);
    if (!original) return;

    await axios.put(`${API}/${usuarioEditar.value._id}`, {
      nombre: usuarioEditar.value.nombre,
      email: usuarioEditar.value.email,
      nombre_rol: original.id_rol?.nombre_rol,
      activo: original.activo
    });

    await cargar();
    cerrarModalEditar();
  } catch (error) {
    console.error("Error editando usuario:", error);
    alert("No se pudo guardar la edición");
  }
};

const cambiarRol = async (usuario, nuevoRol) => {
  try {
    await axios.put(`${API}/${usuario._id}`, {
      nombre: usuario.nombre,
      email: usuario.email,
      nombre_rol: nuevoRol,
      activo: usuario.activo
    });

    await cargar();
  } catch (error) {
    console.error("Error cambiando rol:", error);
    alert("No se pudo cambiar el rol");
  }
};

const cambiarEstado = async (usuario, nuevoEstado) => {
  try {
    const esActivo = nuevoEstado === "Activo";

    await axios.put(`${API}/${usuario._id}`, {
      nombre: usuario.nombre,
      email: usuario.email,
      nombre_rol: usuario.id_rol?.nombre_rol || "Vendedor",
      activo: esActivo
    });

    await cargar();
  } catch (error) {
    console.error("Error cambiando estado:", error);
    alert("No se pudo cambiar el estado");
  }
};

const eliminar = async (id) => {
  if (!confirm("¿Eliminar usuario?")) return;

  try {
    await axios.delete(`${API}/${id}`);
    await cargar();
  } catch (error) {
    console.error("Error eliminando usuario:", error);
    alert("No se pudo eliminar el usuario");
  }
};

onMounted(cargar);
</script>

<template>
  <div class="personal-admin">
    <div class="header">
      <div>
        <h2>Gestión de personal</h2>
        <p>Solicitudes pendientes y usuarios activos</p>
      </div>

      <div class="header-actions">
        <button class="btn-recargar" @click="abrirModalNuevo">Nuevo usuario</button>
        <button class="btn-recargar" @click="cargar">Recargar</button>
      </div>
    </div>

    <div class="bloque">
      <div class="bloque-titulo">
        <h3>Usuarios Pendientes</h3>
        <span class="badge badge-pendiente">{{ pendientes.length }}</span>
      </div>

      <div v-if="!pendientes.length" class="empty-state">
        No hay usuarios pendientes
      </div>

      <div v-else class="tabla-wrap">
        <table class="tabla">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Email</th>
              <th>Rol</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="u in pendientes" :key="u._id">
              <td>{{ u.nombre }}</td>
              <td>{{ u.email }}</td>
              <td><span class="tag rol-sin">Sin asignar</span></td>
              <td><span class="tag pendiente">Pendiente</span></td>
              <td>
                <div class="acciones">
                  <button class="btn btn-aprobar" @click="abrirModalRol(u)">Aceptar</button>
                  <button class="btn btn-editar" @click="abrirModalEditar(u)">Editar</button>
                  <button class="btn btn-eliminar" @click="eliminar(u._id)">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div class="bloque">
      <div class="bloque-titulo">
        <h3>Usuarios Activos</h3>
        <span class="badge badge-activo">{{ activos.length }}</span>
      </div>

      <div v-if="!activos.length" class="empty-state">
        No hay usuarios activos
      </div>

      <div v-else class="tabla-wrap">
        <table class="tabla">
          <thead>
            <tr>
              <th>Nombre</th>
              <th>Email</th>
              <th>Rol</th>
              <th>Estado</th>
              <th>Acciones</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="u in activos" :key="u._id">
              <td>{{ u.nombre }}</td>
              <td>{{ u.email }}</td>
              <td>
                <select
                  class="select-inline"
                  :value="u.id_rol?.nombre_rol || 'Vendedor'"
                  @change="cambiarRol(u, $event.target.value)"
                >
                  <option v-for="rol in rolesDisponibles" :key="rol" :value="rol">
                    {{ rol }}
                  </option>
                </select>
              </td>
              <td>
                <select
                  class="select-inline estado-select"
                  :value="u.activo ? 'Activo' : 'Pendiente'"
                  @change="cambiarEstado(u, $event.target.value)"
                >
                  <option value="Activo">Activo</option>
                  <option value="Pendiente">Pendiente</option>
                </select>
              </td>
              <td>
                <div class="acciones">
                  <button class="btn btn-editar" @click="abrirModalEditar(u)">Editar</button>
                  <button class="btn btn-eliminar" @click="eliminar(u._id)">Eliminar</button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-if="mostrarModalRol" class="modal-overlay" @click.self="cerrarModalRol">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Asignar rol</h3>
          <button class="btn-cerrar" @click="cerrarModalRol">×</button>
        </div>

        <div class="modal-body">
          <div class="usuario-info">
            <p><strong>Usuario:</strong> {{ usuarioSeleccionado?.nombre }}</p>
            <p><strong>Email:</strong> {{ usuarioSeleccionado?.email }}</p>
          </div>

          <label class="label">Rol a asignar</label>
          <select v-model="rolSeleccionado" class="select-rol">
            <option value="Administrador">Administrador</option>
            <option value="Vendedor">Vendedor</option>
            <option value="Consultor">Consultor</option>
          </select>
        </div>

        <div class="modal-footer">
          <button class="btn btn-secundario" @click="cerrarModalRol">Cancelar</button>
          <button class="btn btn-aprobar" @click="confirmarAprobacion">Guardar y aprobar</button>
        </div>
      </div>
    </div>

    <div v-if="mostrarModalNuevo" class="modal-overlay" @click.self="cerrarModalNuevo">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Nuevo usuario</h3>
          <button class="btn-cerrar" @click="cerrarModalNuevo">×</button>
        </div>

        <div class="modal-body">
          <label class="label">Nombre</label>
          <input v-model="nuevoUsuario.nombre" class="input-modal" type="text" placeholder="Nombre completo" />

          <label class="label">Email</label>
          <input v-model="nuevoUsuario.email" class="input-modal" type="email" placeholder="correo@ejemplo.com" />

          <label class="label">Contraseña</label>
          <input v-model="nuevoUsuario.password" class="input-modal" type="password" placeholder="Contraseña" />

          <label class="label">Rol asignado</label>
          <select v-model="nuevoUsuario.nombre_rol" class="select-rol">
            <option value="Administrador">Administrador</option>
            <option value="Vendedor">Vendedor</option>
            <option value="Consultor">Consultor</option>
          </select>
        </div>

        <div class="modal-footer">
          <button class="btn btn-secundario" @click="cerrarModalNuevo">Cancelar</button>
          <button class="btn btn-aprobar" @click="crearNuevoUsuario">Crear usuario</button>
        </div>
      </div>
    </div>

    <div v-if="mostrarModalEditar" class="modal-overlay" @click.self="cerrarModalEditar">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Editar usuario</h3>
          <button class="btn-cerrar" @click="cerrarModalEditar">×</button>
        </div>

        <div class="modal-body">
          <label class="label">Nombre</label>
          <input v-model="usuarioEditar.nombre" class="input-modal" type="text" placeholder="Nombre completo" />

          <label class="label">Email</label>
          <input v-model="usuarioEditar.email" class="input-modal" type="email" placeholder="correo@ejemplo.com" />
        </div>

        <div class="modal-footer">
          <button class="btn btn-secundario" @click="cerrarModalEditar">Cancelar</button>
          <button class="btn btn-aprobar" @click="guardarEdicion">Guardar cambios</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* --- NUEVAS CLASES PARA CONTENER EL DESBORDAMIENTO --- */
.personal-admin {
  color: #fff;
  padding: 24px;
  min-height: 100%;
  background: transparent;
  width: 100%;
  max-width: 100%;
  box-sizing: border-box; /* Evita que el padding sume al ancho */
}

.bloque {
  background: rgba(10, 18, 35, 0.85);
  border: 1px solid rgba(0, 210, 255, 0.15);
  border-radius: 18px;
  padding: 18px;
  margin-bottom: 22px;
  box-shadow: 0 0 20px rgba(0, 210, 255, 0.06);
  width: 100%;
  box-sizing: border-box; /* Evita desbordamiento de bloque */
  overflow: hidden;
}

.tabla-wrap {
  width: 100%;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch; /* Deslizamiento suave en iOS/Android */
}
/* ----------------------------------------------------- */

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  margin-bottom: 24px;
  flex-wrap: wrap;
}
.header h2 {
  margin: 0;
  font-size: 28px;
}
.header p {
  margin: 6px 0 0;
  color: #94a3b8;
}
.header-actions {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.bloque-titulo {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 16px;
  gap: 12px;
}
.bloque-titulo h3 {
  margin: 0;
  font-size: 20px;
}
.badge {
  min-width: 34px;
  height: 34px;
  padding: 0 10px;
  border-radius: 999px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
}
.badge-pendiente {
  background: rgba(251, 191, 36, 0.15);
  color: #fbbf24;
}
.badge-activo {
  background: rgba(34, 197, 94, 0.15);
  color: #22c55e;
}

.tabla {
  width: 100%;
  border-collapse: collapse;
  min-width: 820px; /* Obliga el scroll si no cabe en pantalla */
}
.tabla th,
.tabla td {
  text-align: left;
  padding: 14px 12px;
  border-bottom: 1px solid rgba(148, 163, 184, 0.12);
  vertical-align: middle;
}
.tabla th {
  color: #7dd3fc;
  font-size: 13px;
  letter-spacing: 1px;
  text-transform: uppercase;
}
.tabla td {
  color: #e5e7eb;
}

.tag {
  display: inline-flex;
  align-items: center;
  padding: 6px 12px;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 700;
  white-space: nowrap;
}
.tag.pendiente {
  background: rgba(251, 191, 36, 0.12);
  color: #fbbf24;
}
.tag.activo {
  background: rgba(34, 197, 94, 0.12);
  color: #22c55e;
}
.tag.rol-sin {
  background: rgba(148, 163, 184, 0.12);
  color: #cbd5e1;
}

.select-inline,
.select-rol,
.input-modal {
  width: 100%;
  padding: 10px 12px;
  border-radius: 12px;
  background: #0f172a;
  color: #fff;
  border: 1px solid rgba(0, 210, 255, 0.2);
  outline: none;
  font-size: 14px;
  margin-bottom: 14px;
  box-sizing: border-box; /* Fundamental para inputs full-width */
}
.select-inline option,
.select-rol option {
  background: #0f172a;
  color: #fff;
}
.estado-select {
  min-width: 130px;
}

.acciones {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.btn {
  border: none;
  border-radius: 10px;
  padding: 10px 14px;
  font-weight: 700;
  cursor: pointer;
  transition: 0.2s ease;
  white-space: nowrap;
}
.btn:hover {
  transform: translateY(-1px);
}
.btn-aprobar {
  background: #00d084;
  color: #03131d;
}
.btn-editar {
  background: #3b82f6;
  color: #fff;
}
.btn-eliminar {
  background: #ef4444;
  color: #fff;
}
.btn-secundario,
.btn-recargar {
  background: rgba(15, 23, 42, 0.95);
  color: #fff;
  border: 1px solid rgba(0, 210, 255, 0.22);
}

.empty-state {
  padding: 20px;
  text-align: center;
  color: #94a3b8;
  border: 1px dashed rgba(148, 163, 184, 0.2);
  border-radius: 14px;
}

.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(2, 6, 23, 0.72);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 20px;
  z-index: 9999;
}
.modal-box {
  width: 100%;
  max-width: 520px;
  background: #08111f;
  border: 1px solid rgba(0, 210, 255, 0.2);
  border-radius: 18px;
  box-shadow: 0 0 30px rgba(0, 0, 0, 0.35);
  overflow: hidden;
  box-sizing: border-box;
}

.modal-header,
.modal-footer {
  padding: 18px 20px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
}
.modal-header {
  border-bottom: 1px solid rgba(148, 163, 184, 0.14);
}
.modal-header h3 {
  margin: 0;
  color: #fff;
}
.modal-body {
  padding: 20px;
}
.usuario-info {
  background: rgba(15, 23, 42, 0.95);
  border: 1px solid rgba(148, 163, 184, 0.14);
  border-radius: 12px;
  padding: 14px;
  margin-bottom: 16px;
}
.usuario-info p {
  margin: 0 0 8px;
  color: #e5e7eb;
}
.usuario-info p:last-child {
  margin-bottom: 0;
}
.label {
  display: block;
  margin-bottom: 8px;
  color: #cbd5e1;
  font-weight: 700;
}
.btn-cerrar {
  border: none;
  background: transparent;
  color: #cbd5e1;
  font-size: 28px;
  cursor: pointer;
}

@media (max-width: 768px) {
  .personal-admin {
    padding: 14px;
  }
  .header h2 {
    font-size: 22px;
  }
  .header-actions {
    width: 100%;
    justify-content: space-between;
  }
  .header-actions .btn-recargar {
    flex: 1; /* Los botones crecen parejo en móvil */
  }
  .bloque {
    padding: 14px;
    border-radius: 14px;
  }
  .tabla {
    min-width: 700px; /* Asegura que se active el scroll en móvil */
  }
  .modal-box {
    max-width: 100%;
  }
  .modal-header,
  .modal-footer,
  .modal-body {
    padding: 14px;
  }
  .modal-footer {
    flex-direction: column;
  }
  .modal-footer .btn {
    width: 100%;
  }
}
</style>