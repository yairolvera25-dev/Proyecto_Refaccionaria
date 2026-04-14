<template>
  <div class="flex flex-col lg:flex-row gap-10 animate-fade-in h-full">
    
    <div class="flex-grow flex flex-col gap-6">
      
      <div class="bg-[#0c1215] p-8 rounded-[2rem] border border-[#00ff88]/10 shadow-[0_10px_30px_rgba(0,0,0,0.5)] relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-[#00ff88]/10 via-[#00ff88]/50 to-[#00ff88]"></div>
        <h2 class="text-sm font-black uppercase tracking-[0.3em] text-[#819da7] mb-6 flex items-center gap-2">
          <span class="text-[#00ff88] drop-shadow-[0_0_5px_rgba(0,255,136,0.8)]">🔍</span> Búsqueda de Componentes
        </h2>
        
        <input 
          v-model="searchQuery" 
          @input="buscarProductosSQL" 
          type="text" 
          placeholder="Escribe el nombre o SKU (Ej. Bujía, CAS-5W30)..." 
          class="w-full bg-[#05080a] border border-[#ffffff]/10 p-5 rounded-2xl outline-none focus:border-[#00ff88] focus:shadow-[0_0_15px_rgba(0,255,136,0.2)] text-white text-lg transition-all placeholder-[#819da7]/50 mb-6 font-mono"
        >

        <div class="flex gap-3 overflow-x-auto pb-2 scrollbar-hide">
          <button 
            v-for="cat in categorias" 
            :key="cat"
            @click="categoriaActiva = cat"
            :class="['px-5 py-2 rounded-full text-xs font-black uppercase tracking-wider whitespace-nowrap transition-all border', 
                     categoriaActiva === cat ? 'bg-[#00ff88] text-[#05080a] border-[#00ff88] shadow-[0_0_15px_rgba(0,255,136,0.4)]' : 'bg-[#05080a] text-[#819da7] border-[#ffffff]/5 hover:border-[#00ff88]/50 hover:text-[#00ff88]']"
          >
            {{ cat }}
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4 overflow-y-auto max-h-[550px] pr-2 pb-10">
        
        <div v-for="p in productosFiltrados" :key="p.id" class="bg-[#0c1215] border border-[#ffffff]/5 p-5 rounded-2xl hover:border-[#00ff88] hover:shadow-[0_0_15px_rgba(0,255,136,0.15)] transition-all flex flex-col justify-between group">
          
          <div class="mb-3">
            <h3 class="font-black text-white text-base leading-tight group-hover:text-[#00ff88] transition-colors">
              {{ p.nombre || p.nombre_producto }}
            </h3>
            <div class="flex gap-2 mt-2">
              <span class="text-[9px] font-mono text-[#819da7] bg-[#05080a] px-2 py-1 rounded border border-[#ffffff]/5">SKU: {{ p.sku }}</span>
              <span class="text-[9px] font-bold text-[#00ff88]/80 bg-[#00ff88]/10 px-2 py-1 rounded border border-[#00ff88]/20 uppercase">
                {{ typeof p.categoria === 'object' ? p.categoria?.nombre : (p.categoria || 'GENÉRICO') }}
              </span>
            </div>
          </div>

          <div class="flex justify-between items-end mt-2">
            <div>
              <p class="text-xl text-[#00ff88] font-mono font-black">${{ p.precio_venta || p.precio || 0 }}</p>
              <p :class="['text-[10px] font-black uppercase mt-1 tracking-widest', (p.stock ?? p.cantidad ?? 0) < 10 ? 'text-[#ef4444]' : 'text-[#819da7]']">
                Stock: {{ p.stock ?? p.cantidad ?? 0 }}
              </p>
            </div>
            
            <button 
              @click="addToCart(p)" 
              :disabled="(p.stock ?? p.cantidad ?? 0) <= 0"
              :class="[
                'flex items-center gap-2 px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all',
                (p.stock ?? p.cantidad ?? 0) <= 0 
                  ? 'bg-red-500/10 text-red-500 border border-red-500/20 cursor-not-allowed opacity-50' 
                  : 'bg-transparent border border-[#00ff88]/30 hover:bg-[#00ff88]/10 text-[#00ff88]'
              ]"
            >
              🛒 {{ (p.stock ?? p.cantidad ?? 0) <= 0 ? 'AGOTADO' : 'AÑADIR' }}
            </button> 
          </div>
        </div>

        <div v-if="productosFiltrados.length === 0" class="col-span-full text-center py-10 opacity-50">
          <span class="text-4xl mb-4 block drop-shadow-[0_0_10px_rgba(0,255,136,0.5)]">👻</span>
          <p class="text-xl font-bold text-[#819da7]">Datos no encontrados</p>
          <p class="text-sm text-[#819da7]/70 font-mono mt-2">Intenta ajustar los parámetros de búsqueda</p>
        </div>

      </div>
    </div>

    <aside class="lg:w-[450px] bg-[#0c1215] rounded-[3rem] border border-[#00ff88]/10 p-10 flex flex-col shadow-[0_10px_40px_rgba(0,0,0,0.8)] relative overflow-hidden">
      <div class="absolute top-0 right-0 w-32 h-32 bg-[#00ff88]/5 rounded-bl-full pointer-events-none"></div>
      
      <h2 class="text-sm font-black uppercase tracking-[0.3em] text-[#819da7] mb-8 border-b border-[#ffffff]/5 pb-4">Ticket de Operación</h2>
      
      <div class="flex-1 space-y-3 overflow-y-auto pr-2">
        <div v-for="item in cart" :key="item.id" class="flex justify-between items-center bg-[#05080a] p-4 rounded-2xl border border-[#ffffff]/5 group hover:border-[#00ff88]/30 transition-colors">
          <div class="flex gap-4 items-center">
            <button 
              @click="removeFromCart(item.id)" 
              class="bg-transparent border border-[#ef4444]/50 text-[#ef4444] hover:bg-[#ef4444] hover:text-white flex items-center justify-center w-8 h-8 rounded-lg hover:scale-110 transition-all font-black shadow-[0_0_5px_rgba(239,68,68,0.1)] hover:shadow-[0_0_15px_rgba(239,68,68,0.5)]"
            >
              ✕
            </button>           
            <div>
              <p class="text-sm font-bold text-white group-hover:text-[#00ff88] transition-colors">{{ item.nombre }}</p>
              <p class="text-xs text-[#00ff88] font-mono mt-1">{{ item.cantidad }}x <span class="text-[#819da7]">${{ item.precio }}</span></p>
            </div>
          </div>
          <p class="font-bold font-mono text-[#00ff88] text-lg">${{ (item.cantidad * item.precio).toFixed(2) }}</p>
        </div>
        
        <div v-if="cart.length === 0" class="text-center py-20 opacity-30">
          <span class="text-6xl mb-4 block">🧾</span>
          <p class="italic text-[#819da7] mt-2 font-mono">Esperando datos de entrada...</p>
        </div>
      </div>

      <div class="mt-6 pt-6 border-t border-[#ffffff]/10">
        <div class="flex justify-between items-end mb-8 bg-[#05080a] p-4 rounded-2xl border border-[#ffffff]/5">
          <span class="text-xs font-black uppercase tracking-widest text-[#819da7]">Total a transferir</span>
          <span class="text-5xl font-mono font-black text-[#00ff88] drop-shadow-[0_0_10px_rgba(0,255,136,0.3)]">${{ cartTotal.toFixed(2) }}</span>
        </div>
        
        <button 
          @click="finalizarVenta" 
          :disabled="cart.length === 0" 
          class="w-full bg-transparent border-2 border-[#00ff88] text-[#00ff88] hover:bg-[#00ff88] hover:text-[#05080a] py-5 rounded-2xl font-black uppercase tracking-[0.2em] transition-all shadow-[0_0_10px_rgba(0,255,136,0.2)] hover:shadow-[0_0_30px_rgba(0,255,136,0.6)] disabled:opacity-20 disabled:hover:bg-transparent disabled:hover:text-[#00ff88] disabled:hover:shadow-none disabled:cursor-not-allowed text-sm"
        >
          CERRAR VENTA 🏁
        </button>
      </div>
    </aside>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import axios from 'axios';

const props = defineProps(['userId']);
const API_NOSQL = import.meta.env.VITE_API_URL_NOSQL;
const API_SQL = import.meta.env.VITE_API_URL_SQL;

const searchQuery = ref('');
const cart = ref([]);

// Categorías
const categorias = ['Todos', 'Motor', 'Frenos', 'Suspensión', 'Eléctrico', 'Filtros', 'Accesorios'];
const categoriaActiva = ref('Todos');

const mockProducts = [
  { id: 1, nombre: 'Filtro Aceite Sentra', sku: 'FAS-12', stock: 15, precio: 120, categoria: 'Filtros' }
  // Mantengo uno de prueba por si la API falla, pero intentaremos cargar los reales.
];

const searchResults = ref([]);

// 💡 CORRECCIÓN: Cargar datos reales al iniciar la pantalla
const cargarInventarioInicial = async () => {
  try {
    const res = await axios.get(`${API_SQL}/productos`);
    searchResults.value = res.data.data ? res.data.data : res.data;
  } catch(e) {
    console.error("No se pudo cargar el inventario real:", e);
    searchResults.value = [...mockProducts];
  }
};

onMounted(() => {
  cargarInventarioInicial();
});

const buscarProductosSQL = async () => {
  const query = searchQuery.value.trim().toLowerCase();
  if (query === '') {
    cargarInventarioInicial();
    return;
  }
  try {
    const res = await axios.get(`${API_SQL}/productos/buscar?q=${query}`);
    if(res.data && res.data.length > 0) {
        searchResults.value = res.data; 
    } else {
        searchResults.value = [];
    }
  } catch (e) {
    console.error("Error en la búsqueda:", e);
    searchResults.value = [];
  }
};

// 💡 CORRECCIÓN: Filtro robusto que soporta strings y objetos anidados
const productosFiltrados = computed(() => {
  let lista = searchResults.value;
  if (categoriaActiva.value !== 'Todos') {
    lista = lista.filter(p => {
      const nombreCategoria = typeof p.categoria === 'object' ? p.categoria?.nombre : p.categoria;
      const categoriaLimpia = (nombreCategoria || '').trim().toLowerCase();
      const filtroLimpio = categoriaActiva.value.trim().toLowerCase();
      
      return categoriaLimpia === filtroLimpio;
    });
  }
  return lista;
});

// 💡 CORRECCIÓN: Validación doble de stock al añadir
const addToCart = (p) => {
  const stockDisponible = p.stock ?? p.cantidad ?? 0;
  if (stockDisponible <= 0) return; // Bloqueo de seguridad

  const item = cart.value.find(i => i.id === p.id);
  if (item) {
    if (item.cantidad < stockDisponible) {
      item.cantidad++;
    } else {
      alert("⚠️ Has alcanzado el límite de stock en bodega para este producto.");
    }
  } else {
    cart.value.push({ 
      ...p, 
      cantidad: 1,
      // Aseguramos nombres estandarizados para el ticket
      nombre: p.nombre || p.nombre_producto,
      precio: p.precio_venta || p.precio || 0
    });
  }
};

const removeFromCart = (id) => {
  cart.value = cart.value.filter(i => i.id !== id);
};

const cartTotal = computed(() => cart.value.reduce((acc, i) => acc + (i.precio * i.cantidad), 0));

const finalizarVenta = async () => {
  try {
    const usuarioLogueado = JSON.parse(localStorage.getItem('user')) || {};
    const idSucursal = usuarioLogueado.id_sucursal || 1; 

    const payload = {
      id_vendedor: props.userId,
      id_sucursal_orig: idSucursal,
      items: cart.value,
      total_venta: cartTotal.value,
      estatus: 'Completada'
    };
    
    await axios.post(`${API_NOSQL}/ventas`, payload);
    
    alert("✅ ¡Venta registrada con éxito en MongoDB Atlas!");
    
    cart.value = []; 
    searchQuery.value = '';
    categoriaActiva.value = 'Todos'; 
    cargarInventarioInicial(); // Recargamos para ver el stock descontado
    
  } catch (e) {
    const errorReal = e.response?.data?.error || e.response?.data?.msg || e.message;
    alert("❌ Falló Node.js: " + errorReal);
    console.error("Detalle completo del error:", e.response?.data);
  }
};
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-out; }
@keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }

/* Scrollbars Cyberpunk */
::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: #05080a; border-radius: 10px; }
::-webkit-scrollbar-thumb { background: #0c1215; border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 10px; }
::-webkit-scrollbar-thumb:hover { background: rgba(0, 255, 136, 0.1); border: 1px solid rgba(0, 255, 136, 0.5); }

/* Oculta la barra de scroll en los botones de categoría */
.scrollbar-hide::-webkit-scrollbar { display: none; }
.scrollbar-hide { -ms-overflow-style: none; scrollbar-width: none; }
</style>