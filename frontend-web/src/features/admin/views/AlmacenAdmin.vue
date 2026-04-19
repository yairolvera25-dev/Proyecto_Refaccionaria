<script setup>
import { ref, computed, onMounted } from "vue";
import axios from "axios";

const busqueda = ref("");
const productos = ref([]);
const cargando = ref(false);

const mostrarModalNuevo = ref(false);
const mostrarModalEditar = ref(false);

const productoNuevo = ref({
  sku: "",
  nombre: "",
  precio_compra: "",
  precio_venta: "",
  stock: "",
  categoria_id: "",
  marca_id: "",
  proveedor_id: ""
});

const productoEditar = ref({
  id: null,
  sku: "",
  nombre: "",
  precio_compra: "",
  precio_venta: "",
  stock: "",
  categoria_id: "",
  marca_id: "",
  proveedor_id: ""
});

const API_PROD = `${import.meta.env.VITE_API_URL_SQL}/productos`;

const cargarProductos = async () => {
  try {
    cargando.value = true;
    console.log("API_PROD:", API_PROD);
    const res = await axios.get(API_PROD);
    productos.value = Array.isArray(res.data) ? res.data : (res.data.data || []);
  } catch (error) {
    console.error("Error al cargar productos:", error);
    productos.value = [];
  } finally {
    cargando.value = false;
  }
};

const datosFiltrados = computed(() => {
  return productos.value.filter((item) =>
    `${item.nombre || ""} ${item.sku || ""}`.toLowerCase().includes(busqueda.value.toLowerCase())
  );
});

const abrirModalNuevo = () => {
  productoNuevo.value = {
    sku: "",
    nombre: "",
    precio_compra: "",
    precio_venta: "",
    stock: "",
    categoria_id: "",
    marca_id: "",
    proveedor_id: ""
  };
  mostrarModalNuevo.value = true;
};

const cerrarModalNuevo = () => {
  mostrarModalNuevo.value = false;
};

const abrirEditar = (item) => {
  productoEditar.value = {
    id: item.id,
    sku: item.sku || "",
    nombre: item.nombre || "",
    precio_compra: item.precio_compra || "",
    precio_venta: item.precio_venta || "",
    stock: item.stock || "",
    categoria_id: item.id_categoria || "",
    marca_id: item.id_marca || "",
    proveedor_id: item.id_proveedor || ""
  };
  mostrarModalEditar.value = true;
};

const cerrarModalEditar = () => {
  mostrarModalEditar.value = false;
};

const guardarProducto = async () => {
  try {
    await axios.post(API_PROD, {
      sku: productoNuevo.value.sku,
      nombre: productoNuevo.value.nombre,
      precio_compra: Number(productoNuevo.value.precio_compra),
      precio_venta: Number(productoNuevo.value.precio_venta),
      stock: Number(productoNuevo.value.stock),
      categoria_id: Number(productoNuevo.value.categoria_id),
      marca_id: Number(productoNuevo.value.marca_id),
      proveedor_id: Number(productoNuevo.value.proveedor_id)
    });

    cerrarModalNuevo();
    await cargarProductos();
  } catch (error) {
    console.error("Error al guardar producto:", error);
    alert(error?.response?.data?.message || "Error al guardar producto");
  }
};

const guardarEdicion = async () => {
  try {
    await axios.put(`${API_PROD}/${productoEditar.value.id}`, {
      sku: productoEditar.value.sku,
      nombre: productoEditar.value.nombre,
      precio_compra: Number(productoEditar.value.precio_compra),
      precio_venta: Number(productoEditar.value.precio_venta),
      stock: Number(productoEditar.value.stock),
      categoria_id: Number(productoEditar.value.categoria_id),
      marca_id: Number(productoEditar.value.marca_id),
      proveedor_id: Number(productoEditar.value.proveedor_id)
    });

    cerrarModalEditar();
    await cargarProductos();
  } catch (error) {
    console.error("Error al editar producto:", error);
    alert(error?.response?.data?.message || "Error al editar producto");
  }
};

const eliminarProducto = async (id) => {
  if (!confirm("¿Eliminar producto?")) return;

  try {
    await axios.delete(`${API_PROD}/${id}`);
    await cargarProductos();
  } catch (error) {
    console.error("Error al eliminar producto:", error);
    alert(error?.response?.data?.message || "Error al eliminar producto");
  }
};

onMounted(cargarProductos);
</script>

<template>
  <div class="view-container">
    <header class="top-bar">
      <div class="left-tools">
        <input
          v-model="busqueda"
          type="text"
          placeholder="Buscar refacciones..."
          class="glass-input"
        >
      </div>

      <div class="right-tools">
        <button class="btn-action btn-new" @click="abrirModalNuevo">
          Nuevo producto
        </button>
        <button class="btn-action btn-reload" @click="cargarProductos">
          Recargar
        </button>
      </div>
    </header>

    <div class="table-container shadow-neon">
      <div class="overflow-x-auto w-full">
        <table class="main-table">
          <thead>
            <tr>
              <th>SKU</th>
              <th>PRODUCTO</th>
              <th>COMPRA</th>
              <th>VENTA</th>
              <th>STOCK</th>
              <th>ID MARCA</th>
              <th>ID CATEGORÍA</th>
              <th>ID PROVEEDOR</th>
              <th>ACCIONES</th>
            </tr>
          </thead>
          <tbody>
            <tr v-if="!datosFiltrados.length">
              <td colspan="9" class="empty-cell">
                {{ cargando ? 'Cargando productos...' : 'No hay productos para mostrar' }}
              </td>
            </tr>

            <tr v-for="item in datosFiltrados" :key="item.id">
              <td class="sku-text">{{ item.sku }}</td>
              <td class="bold">{{ item.nombre }}</td>
              <td class="price">$ {{ item.precio_compra }}</td>
              <td class="price">$ {{ item.precio_venta }}</td>
              <td>{{ item.stock }}</td>
              <td>{{ item.id_marca }}</td>
              <td>{{ item.id_categoria }}</td>
              <td>{{ item.id_proveedor }}</td>
              <td>
                <div class="acciones">
                  <button class="btn-mini btn-edit" @click="abrirEditar(item)">
                    Editar
                  </button>
                  <button class="btn-mini btn-delete" @click="eliminarProducto(item.id)">
                    Eliminar
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-if="mostrarModalNuevo" class="modal-overlay" @click.self="cerrarModalNuevo">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Nuevo producto</h3>
          <button class="btn-close" @click="cerrarModalNuevo">×</button>
        </div>

        <div class="modal-body">
          <input v-model="productoNuevo.sku" placeholder="SKU" class="input-modal" />
          <input v-model="productoNuevo.nombre" placeholder="Nombre" class="input-modal" />
          <input v-model="productoNuevo.precio_compra" type="number" placeholder="Precio compra" class="input-modal" />
          <input v-model="productoNuevo.precio_venta" type="number" placeholder="Precio venta" class="input-modal" />
          <input v-model="productoNuevo.stock" type="number" placeholder="Stock" class="input-modal" />
          <input v-model="productoNuevo.categoria_id" type="number" placeholder="ID Categoría" class="input-modal" />
          <input v-model="productoNuevo.marca_id" type="number" placeholder="ID Marca" class="input-modal" />
          <input v-model="productoNuevo.proveedor_id" type="number" placeholder="ID Proveedor" class="input-modal" />
        </div>

        <div class="modal-footer">
          <button class="btn-action btn-cancel" @click="cerrarModalNuevo">Cancelar</button>
          <button class="btn-action btn-new" @click="guardarProducto">Guardar</button>
        </div>
      </div>
    </div>

    <div v-if="mostrarModalEditar" class="modal-overlay" @click.self="cerrarModalEditar">
      <div class="modal-box">
        <div class="modal-header">
          <h3>Editar producto</h3>
          <button class="btn-close" @click="cerrarModalEditar">×</button>
        </div>

        <div class="modal-body">
          <input v-model="productoEditar.sku" placeholder="SKU" class="input-modal" />
          <input v-model="productoEditar.nombre" placeholder="Nombre" class="input-modal" />
          <input v-model="productoEditar.precio_compra" type="number" placeholder="Precio compra" class="input-modal" />
          <input v-model="productoEditar.precio_venta" type="number" placeholder="Precio venta" class="input-modal" />
          <input v-model="productoEditar.stock" type="number" placeholder="Stock" class="input-modal" />
          <input v-model="productoEditar.categoria_id" type="number" placeholder="ID Categoría" class="input-modal" />
          <input v-model="productoEditar.marca_id" type="number" placeholder="ID Marca" class="input-modal" />
          <input v-model="productoEditar.proveedor_id" type="number" placeholder="ID Proveedor" class="input-modal" />
        </div>

        <div class="modal-footer">
          <button class="btn-action btn-cancel" @click="cerrarModalEditar">Cancelar</button>
          <button class="btn-action btn-edit" @click="guardarEdicion">Guardar cambios</button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.view-container {
  display: flex;
  flex-direction: column;
  gap: 30px;
  animation: fadeIn 0.4s ease-out;
  width: 100%;
  max-width: 100%; /* Asegura que no se desborde del padre */
  box-sizing: border-box;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.top-bar {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  flex-wrap: wrap;
  align-items: center;
}

.left-tools,
.right-tools {
  display: flex;
  gap: 10px;
  align-items: center;
  flex-wrap: wrap;
}

.glass-input {
  background: rgba(15, 23, 42, 0.6);
  border: 1px solid rgba(0, 210, 255, 0.3);
  padding: 12px 20px;
  border-radius: 25px;
  color: white;
  width: 350px;
  transition: all 0.3s;
}

.glass-input:focus,
.input-modal:focus {
  border-color: #00d2ff;
  outline: none;
  box-shadow: 0 0 10px rgba(0, 210, 255, 0.2);
}

.btn-action {
  border: none;
  border-radius: 10px;
  padding: 10px 14px;
  font-weight: 700;
  cursor: pointer;
}

.btn-new {
  background: #00ff88;
  color: #03131d;
}

.btn-edit {
  background: #00d2ff;
  color: #03131d;
}

.btn-delete {
  background: #ff4c4c;
  color: white;
}

.btn-reload,
.btn-cancel {
  background: rgba(15, 23, 42, 0.95);
  color: white;
  border: 1px solid rgba(0, 210, 255, 0.22);
}

.table-container {
  width: 100%;
  box-sizing: border-box;
  background: rgba(15, 23, 42, 0.6);
  backdrop-filter: blur(10px);
  border-radius: 20px;
  border: 1px solid rgba(0, 210, 255, 0.2);
  padding: 10px;
}

/* --- CLASES NUEVAS PARA EL SCROLL HORIZONTAL DE LA TABLA --- */
.w-full {
  width: 100%;
}

.overflow-x-auto {
  overflow-x: auto;
  -webkit-overflow-scrolling: touch; /* Deslizamiento suave en celulares */
}

.main-table {
  width: 100%;
  border-collapse: collapse;
  min-width: 800px; /* Obliga a la tabla a mantener un ancho mínimo, habilitando el scroll en móvil */
}
/* ----------------------------------------------------------- */

.main-table th {
  padding: 15px;
  text-align: left;
  color: #8ba3cb;
  font-size: 0.8rem;
  border-bottom: 1px solid rgba(0, 210, 255, 0.1);
  letter-spacing: 1px;
  white-space: nowrap; /* Evita que los títulos se rompan en dos líneas */
}

.main-table td {
  padding: 15px;
  border-bottom: 1px solid rgba(0, 210, 255, 0.05);
  color: #e2e8f0;
}

.main-table tr:hover {
  background: rgba(0, 210, 255, 0.05);
}

.bold {
  color: #00d2ff;
  font-weight: bold;
}

.sku-text {
  color: #94a3b8;
  font-family: monospace;
}

.price {
  color: #10b981;
  font-weight: bold;
}

.acciones {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.btn-mini {
  border: none;
  border-radius: 8px;
  padding: 8px 10px;
  font-weight: 700;
  cursor: pointer;
  white-space: nowrap;
}

.empty-cell {
  text-align: center;
  color: #94a3b8;
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
  color: white;
}

.modal-body {
  padding: 20px;
}

.input-modal {
  width: 100%;
  padding: 12px 14px;
  margin-bottom: 12px;
  border-radius: 12px;
  background: #0f172a;
  color: white;
  border: 1px solid rgba(0, 210, 255, 0.2);
  box-sizing: border-box; /* Para que el padding no rompa el ancho del input */
}

.btn-close {
  border: none;
  background: transparent;
  color: #cbd5e1;
  font-size: 28px;
  cursor: pointer;
}

@media (max-width: 768px) {
  .glass-input {
    width: 100%; /* La barra de búsqueda ocupa todo el ancho */
  }

  .left-tools, .right-tools {
    width: 100%;
    justify-content: space-between; /* Alinea los botones bonito */
  }

  .modal-box {
    max-width: 100%;
  }

  .modal-footer {
    flex-direction: column;
  }

  .modal-footer .btn-action {
    width: 100%; /* Botones de guardar del modal a tamaño completo */
  }
}
</style>