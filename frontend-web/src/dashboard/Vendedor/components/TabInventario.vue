<template>
  <div class="flex flex-col gap-8 animate-fade-in w-full pb-10">
    
    <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
      <div>
        <h2 class="text-sm font-black uppercase tracking-[0.3em] text-[#819da7]">Catálogo de Productos <span class="text-[#00ff88]/50 font-mono text-[10px]">// SQL_DATABASE</span></h2>
      </div>
      <button @click="abrirModalCrear" class="bg-transparent border border-[#00ff88]/30 hover:bg-[#00ff88]/10 text-[#00ff88] px-6 py-3 rounded-xl text-[11px] font-black uppercase tracking-widest transition-all hover:scale-105 flex items-center gap-2 shadow-[0_0_15px_rgba(0,255,136,0.1)]">
        Añadir Producto +
      </button>
    </div>

    <div class="bg-[#0c1215] p-6 rounded-[2rem] border border-[#ffffff]/5 shadow-xl flex flex-col xl:flex-row gap-6 justify-between items-center z-20 relative">
      
      <div class="relative w-full xl:w-1/2">
        <span class="absolute inset-y-0 left-0 flex items-center pl-4 text-[#819da7]">🔍</span>
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Escribe el nombre, descripción o SKU..." 
          class="w-full bg-[#05080a] border border-[#ffffff]/10 text-white text-sm rounded-xl pl-12 pr-4 py-3 focus:outline-none focus:border-[#00ff88]/50 focus:ring-1 focus:ring-[#00ff88]/50 transition-all font-mono placeholder-[#819da7]/50"
        >
        <button v-if="searchQuery" @click="searchQuery = ''" class="absolute inset-y-0 right-0 flex items-center pr-4 text-[#819da7] hover:text-red-500 font-black">
          ✕
        </button>
      </div>

      <div class="flex gap-2 w-full xl:w-auto overflow-x-auto custom-scrollbar pb-2 xl:pb-0">
        <button @click="filterStatus = 'TODOS'" :class="['px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-all', filterStatus === 'TODOS' ? 'bg-[#00ff88] text-black shadow-neon scale-105' : 'bg-[#05080a] text-[#819da7] border border-[#ffffff]/10 hover:text-[#00ff88]']">
          Todos ({{ productos.length }})
        </button>
        <button @click="filterStatus = 'DISPONIBLE'" :class="['px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-all', filterStatus === 'DISPONIBLE' ? 'bg-[#00ff88]/20 text-[#00ff88] border border-[#00ff88]/50 scale-105' : 'bg-[#05080a] text-[#819da7] border border-[#ffffff]/10 hover:text-[#00ff88]']">
          Disponibles
        </button>
        <button @click="filterStatus = 'CRITICO'" :class="['px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-all', filterStatus === 'CRITICO' ? 'bg-[#f97316]/20 text-[#f97316] border border-[#f97316]/50 scale-105' : 'bg-[#05080a] text-[#819da7] border border-[#ffffff]/10 hover:text-[#f97316]']">
          Críticos
        </button>
        <button @click="filterStatus = 'AGOTADO'" :class="['px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest whitespace-nowrap transition-all', filterStatus === 'AGOTADO' ? 'bg-red-500/20 text-red-500 border border-red-500/50 scale-105' : 'bg-[#05080a] text-[#819da7] border border-[#ffffff]/10 hover:text-red-500']">
          Agotados
        </button>
      </div>
    </div>

    <div class="bg-[#0c1215] rounded-[2rem] border border-[#ffffff]/5 overflow-hidden shadow-2xl">
      <div class="overflow-x-auto custom-scrollbar max-h-[500px]">
        <table class="w-full text-left border-collapse">
          <thead class="text-[9px] uppercase text-[#819da7] bg-[#05080a] font-black border-b border-[#ffffff]/5 sticky top-0 z-10">
            <tr>
              <th class="px-8 py-5 tracking-widest">Pieza / Descripción</th>
              <th class="px-8 py-5 tracking-widest">Identificador SKU</th>
              <th class="px-8 py-5 tracking-widest">Disponibilidad</th>
              <th class="px-8 py-5 tracking-widest">Precio Unitario</th>
              <th class="px-8 py-5 tracking-widest text-right">Acciones</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-[#ffffff]/5 relative">
            
            <tr v-if="cargando" class="absolute inset-0 flex justify-center items-center bg-[#0c1215]/80 backdrop-blur-sm z-20 h-32">
              <span class="text-[#00ff88] font-mono text-xs animate-pulse">// CARGANDO DATOS...</span>
            </tr>

            <tr v-for="prod in productosFiltrados" :key="prod.id" class="hover:bg-[#00ff88]/[0.03] transition-colors group">
              <td class="px-8 py-5">
                <p class="text-sm text-white font-bold">{{ prod.nombre || prod.nombre_producto }}</p>
                <p class="text-[10px] text-[#819da7] font-mono uppercase">{{ prod.marca || 'GENÉRICO' }}</p>
              </td>
              <td class="px-8 py-5 font-mono text-[#819da7] text-xs">
                {{ prod.sku }}
              </td>
              <td class="px-8 py-5">
                <span :class="[
                  'px-3 py-1.5 rounded-lg text-[9px] font-black uppercase border tracking-widest',
                  (prod.cantidad ?? prod.stock ?? 0) > 10 ? 'border-[#00ff88]/20 bg-[#00ff88]/5 text-[#00ff88]' : 
                  (prod.cantidad ?? prod.stock ?? 0) > 0 ? 'border-[#f97316]/20 bg-[#f97316]/5 text-[#f97316]' : 'border-red-500/20 bg-red-500/5 text-red-500'
                ]">
                  {{ prod.cantidad ?? prod.stock ?? 0 }} UNIDADES
                </span>
              </td>
              <td class="px-8 py-5 font-black text-[#00ff88] text-sm font-mono">
                ${{ Number(prod.precio_venta || prod.precio || 0).toFixed(2) }}
              </td>
              <td class="px-8 py-5 flex justify-end gap-2">
                <button @click="abrirModalEditar(prod)" class="p-2 bg-[#ffffff]/5 hover:bg-[#00ff88]/20 rounded-lg text-[#819da7] hover:text-[#00ff88] transition-all border border-[#ffffff]/5 hover:border-[#00ff88]/30" title="Editar">
                  ✏️
                </button>
                <button @click="abrirModalEliminar(prod)" class="p-2 bg-[#ffffff]/5 hover:bg-red-500/20 rounded-lg text-[#819da7] hover:text-red-500 transition-all border border-[#ffffff]/5 hover:border-red-500/30" title="Eliminar">
                  🗑️
                </button>
              </td>
            </tr>
            
            <tr v-if="!cargando && productosFiltrados.length === 0">
              <td colspan="5" class="px-8 py-16 text-center">
                <p class="text-3xl mb-4">👻</p>
                <p class="text-[#819da7] text-xs font-mono font-black uppercase tracking-widest">No se encontraron productos</p>
                <button @click="resetFiltros" class="mt-4 text-[#00ff88] text-[10px] font-bold border-b border-[#00ff88] pb-1 hover:text-white transition-colors">LIMPIAR BÚSQUEDA Y FILTROS</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <div v-if="isModalFormOpen" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div @click="cerrarModales" class="absolute inset-0 bg-black/90 backdrop-blur-sm"></div>
      <div class="relative bg-[#0c1215] border border-[#00ff88]/30 w-full max-w-md rounded-[2rem] shadow-2xl p-8 animate-fade-in">
        <h3 class="text-[#00ff88] font-black uppercase text-sm tracking-widest mb-6">
          {{ isEditing ? '// EDITAR PRODUCTO' : '// NUEVO PRODUCTO' }}
        </h3>
        
        <form @submit.prevent="guardarProducto" class="space-y-4">
          <div>
            <label class="block text-[10px] text-[#819da7] font-bold uppercase tracking-widest mb-2">Nombre / Descripción</label>
            <input v-model="form.nombre" type="text" required class="w-full bg-[#05080a] border border-[#ffffff]/10 text-white text-sm rounded-xl px-4 py-3 focus:outline-none focus:border-[#00ff88]/50 focus:ring-1 focus:ring-[#00ff88]/50 transition-all font-mono" placeholder="Ej. Balatas Delanteras Vento">
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <label class="block text-[10px] text-[#819da7] font-bold uppercase tracking-widest mb-2">SKU</label>
              <input v-model="form.sku" type="text" required class="w-full bg-[#05080a] border border-[#ffffff]/10 text-white text-sm rounded-xl px-4 py-3 focus:outline-none focus:border-[#00ff88]/50 font-mono" placeholder="REF-XXXX">
            </div>
            <div>
              <label class="block text-[10px] text-[#819da7] font-bold uppercase tracking-widest mb-2">Stock / Disp.</label>
              <input v-model.number="form.stock" type="number" required min="0" class="w-full bg-[#05080a] border border-[#ffffff]/10 text-white text-sm rounded-xl px-4 py-3 focus:outline-none focus:border-[#00ff88]/50 font-mono" placeholder="0">
            </div>
          </div>
          <div>
            <label class="block text-[10px] text-[#819da7] font-bold uppercase tracking-widest mb-2">Precio Unitario ($)</label>
            <input v-model.number="form.precio_venta" type="number" step="0.01" required min="0" class="w-full bg-[#05080a] border border-[#ffffff]/10 text-white text-sm rounded-xl px-4 py-3 focus:outline-none focus:border-[#00ff88]/50 font-mono" placeholder="0.00">
          </div>
          
          <div class="mt-8 flex gap-4 pt-4 border-t border-[#ffffff]/10">
            <button type="button" @click="cerrarModales" class="flex-1 border border-[#ffffff]/10 hover:bg-[#ffffff]/5 text-[#819da7] font-black text-[10px] uppercase tracking-widest py-3 rounded-xl transition-all">Cancelar</button>
            <button type="submit" class="flex-1 bg-[#00ff88] hover:bg-[#00e67a] text-black font-black text-[10px] uppercase tracking-widest py-3 rounded-xl shadow-[0_0_15px_rgba(0,255,136,0.3)] transition-all flex justify-center items-center gap-2">
              <span v-if="guardando" class="w-3 h-3 border-2 border-black border-t-transparent rounded-full animate-spin"></span>
              {{ guardando ? 'Guardando...' : 'Guardar Datos' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="isDeleteModalOpen" class="fixed inset-0 z-[100] flex items-center justify-center p-4">
      <div @click="cerrarModales" class="absolute inset-0 bg-black/90 backdrop-blur-sm"></div>
      <div class="relative bg-[#0c1215] border border-red-500/30 w-full max-w-sm rounded-[2rem] shadow-[0_0_40px_rgba(239,68,68,0.1)] p-8 animate-fade-in text-center">
        <div class="w-16 h-16 bg-red-500/10 rounded-full flex items-center justify-center mx-auto mb-6 border border-red-500/20">
          <span class="text-2xl animate-pulse">⚠️</span>
        </div>
        <h3 class="text-white font-black uppercase text-lg tracking-widest mb-2">¿Eliminar Producto?</h3>
        <p class="text-xs text-[#819da7] leading-relaxed mb-8">Esta acción borrará <span class="text-white font-bold font-mono">[{{ productoSeleccionado?.sku }}]</span> de la base de datos SQL. No se puede deshacer.</p>
        
        <div class="flex gap-4">
          <button @click="cerrarModales" class="flex-1 border border-[#ffffff]/10 hover:bg-[#ffffff]/5 text-[#819da7] font-black text-[10px] uppercase tracking-widest py-3 rounded-xl transition-all">Cancelar</button>
          <button @click="ejecutarEliminar" :disabled="eliminando" class="flex-1 bg-red-500 hover:bg-red-600 text-white font-black text-[10px] uppercase tracking-widest py-3 rounded-xl shadow-[0_0_15px_rgba(239,68,68,0.3)] transition-all">
            {{ eliminando ? 'Borrando...' : 'Sí, Eliminar' }}
          </button>
        </div>
      </div>
    </div>

  </div>
</template>

<script setup>
// 💡 IMPORTANTE: Importamos 'computed' para hacer la magia del buscador
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

const API_SQL = import.meta.env.VITE_API_URL_SQL || 'http://localhost:8000/api';

// Estados
const productos = ref([]);
const cargando = ref(false);
const guardando = ref(false);
const eliminando = ref(false);

// 🔍 ESTADOS DE BÚSQUEDA Y FILTRO
const searchQuery = ref('');
const filterStatus = ref('TODOS'); // 'TODOS', 'DISPONIBLE', 'CRITICO', 'AGOTADO'

// Control de Modales
const isModalFormOpen = ref(false);
const isDeleteModalOpen = ref(false);
const isEditing = ref(false);
const productoSeleccionado = ref(null);

// Formulario reactivo
const form = ref({
  id: null,
  nombre: '',
  sku: '',
  stock: 0,
  precio_venta: 0
});

// 🧠 MAGIA: Computed property que filtra la tabla instantáneamente
const productosFiltrados = computed(() => {
  return productos.value.filter(prod => {
    // 1. Filtrar por Texto (Buscador)
    const term = searchQuery.value.toLowerCase().trim();
    const nombre = (prod.nombre || prod.nombre_producto || '').toLowerCase();
    const sku = (prod.sku || '').toLowerCase();
    const marca = (prod.marca || '').toLowerCase();
    
    const cumpleBusqueda = nombre.includes(term) || sku.includes(term) || marca.includes(term);

    // 2. Filtrar por Estado (Botones)
    const stock = prod.cantidad ?? prod.stock ?? 0;
    let cumpleFiltro = true;
    
    if (filterStatus.value === 'DISPONIBLE') cumpleFiltro = stock > 10;
    if (filterStatus.value === 'CRITICO') cumpleFiltro = stock > 0 && stock <= 10;
    if (filterStatus.value === 'AGOTADO') cumpleFiltro = stock === 0;

    // Solo mostramos el producto si cumple ambas condiciones
    return cumpleBusqueda && cumpleFiltro;
  });
});

// Reseteo rápido
const resetFiltros = () => {
  searchQuery.value = '';
  filterStatus.value = 'TODOS';
};


const fetchProductos = async () => {
  cargando.value = true;
  try {
    const response = await axios.get(`${API_SQL}/productos`);
    productos.value = response.data.data ? response.data.data : response.data; 
  } catch (error) {
    console.error("Error cargando productos de SQL:", error);
  } finally {
    cargando.value = false;
  }
};

const abrirModalCrear = () => {
  isEditing.value = false;
  form.value = { id: null, nombre: '', sku: '', stock: 0, precio_venta: 0 };
  isModalFormOpen.value = true;
};

const abrirModalEditar = (prod) => {
  isEditing.value = true;
  form.value = { 
    id: prod.id, 
    nombre: prod.nombre || prod.nombre_producto, 
    sku: prod.sku, 
    stock: prod.cantidad ?? prod.stock ?? 0, 
    precio_venta: prod.precio_venta || prod.precio || 0 
  };
  isModalFormOpen.value = true;
};

const abrirModalEliminar = (prod) => {
  productoSeleccionado.value = prod;
  isDeleteModalOpen.value = true;
};

const cerrarModales = () => {
  isModalFormOpen.value = false;
  isDeleteModalOpen.value = false;
  productoSeleccionado.value = null;
};

const guardarProducto = async () => {
  guardando.value = true;
  try {
    const payload = {
      nombre: form.value.nombre,
      sku: form.value.sku,
      precio_venta: form.value.precio_venta,
      stock: form.value.stock
    };

    if (isEditing.value) {
      await axios.put(`${API_SQL}/productos/${form.value.id}`, payload);
    } else {
      await axios.post(`${API_SQL}/productos`, payload);
    }
    
    cerrarModales();
    fetchProductos(); 
  } catch (error) {
    console.error("Error guardando producto:", error);
    alert("Hubo un error al guardar. Verifica la consola.");
  } finally {
    guardando.value = false;
  }
};

const ejecutarEliminar = async () => {
  if (!productoSeleccionado.value) return;
  eliminando.value = true;
  try {
    await axios.delete(`${API_SQL}/productos/${productoSeleccionado.value.id}`);
    cerrarModales();
    fetchProductos(); 
  } catch (error) {
    console.error("Error eliminando producto:", error);
    alert("Hubo un error al eliminar. ¿Quizás tiene ventas asociadas?");
  } finally {
    eliminando.value = false;
  }
};

onMounted(() => {
  fetchProductos();
});
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s cubic-bezier(0.16, 1, 0.3, 1); }
@keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
.shadow-neon { box-shadow: 0 0 20px rgba(0, 255, 136, 0.3); }

::-webkit-scrollbar { height: 6px; width: 6px; }
::-webkit-scrollbar-track { background: #05080a; }
::-webkit-scrollbar-thumb { background: #0c1215; border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 10px; }
</style>