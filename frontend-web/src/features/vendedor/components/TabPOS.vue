<template>
  <div class="flex flex-col xl:flex-row gap-6 sm:gap-10 animate-fade-in h-full">
    
    <div class="flex-grow flex flex-col gap-6 w-full">
      
      <div class="bg-[#0c1215] p-5 sm:p-8 rounded-[1.5rem] sm:rounded-[2rem] border border-[#00ff88]/10 shadow-[0_10px_30px_rgba(0,0,0,0.5)] relative overflow-hidden">
        <div class="absolute top-0 left-0 w-full h-1 bg-gradient-to-r from-[#00ff88]/10 via-[#00ff88]/50 to-[#00ff88]"></div>
        <h2 class="text-xs sm:text-sm font-black uppercase tracking-[0.3em] text-[#819da7] mb-4 sm:mb-6 flex items-center gap-2">
          <span class="text-[#00ff88] drop-shadow-[0_0_5px_rgba(0,255,136,0.8)]">🔍</span> Búsqueda de Componentes
        </h2>
        
        <input 
          v-model="searchQuery" 
          type="text" 
          placeholder="Ej. Bujía, CAS-5W30..." 
          class="w-full bg-[#05080a] border border-[#ffffff]/10 p-4 sm:p-5 rounded-xl sm:rounded-2xl outline-none focus:border-[#00ff88] focus:shadow-[0_0_15px_rgba(0,255,136,0.2)] text-white text-base sm:text-lg transition-all placeholder-[#819da7]/50 mb-4 sm:mb-6 font-mono"
        >

        <div class="flex gap-2 sm:gap-3 overflow-x-auto pb-2 scrollbar-hide">
          <button 
            v-for="cat in categorias" 
            :key="cat"
            @click="categoriaActiva = cat"
            :class="['px-4 sm:px-5 py-2 rounded-full text-[10px] sm:text-xs font-black uppercase tracking-wider whitespace-nowrap transition-all border', 
                     categoriaActiva === cat ? 'bg-[#00ff88] text-[#05080a] border-[#00ff88] shadow-[0_0_15px_rgba(0,255,136,0.4)]' : 'bg-[#05080a] text-[#819da7] border-[#ffffff]/5 hover:border-[#00ff88]/50 hover:text-[#00ff88]']"
          >
            {{ cat }}
          </button>
        </div>
      </div>

      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 2xl:grid-cols-4 gap-4 overflow-y-auto max-h-[500px] sm:max-h-[550px] pr-2 pb-6 sm:pb-10 custom-scrollbar">
        
        <div v-for="p in productosFiltrados" :key="p.id" class="bg-[#0c1215] border border-[#ffffff]/5 p-4 sm:p-5 rounded-[1.25rem] sm:rounded-2xl hover:border-[#00ff88] hover:shadow-[0_0_15px_rgba(0,255,136,0.15)] transition-all flex flex-col justify-between group">
          
          <div class="mb-3">
            <h3 class="font-black text-white text-sm sm:text-base leading-tight group-hover:text-[#00ff88] transition-colors line-clamp-2" :title="p.nombre || p.nombre_producto">
              {{ p.nombre || p.nombre_producto }}
            </h3>
            <div class="flex flex-wrap gap-2 mt-2">
              <span class="text-[8px] sm:text-[9px] font-mono text-[#819da7] bg-[#05080a] px-2 py-1 rounded border border-[#ffffff]/5">SKU: {{ p.sku }}</span>
              <span class="text-[8px] sm:text-[9px] font-bold text-[#00ff88]/80 bg-[#00ff88]/10 px-2 py-1 rounded border border-[#00ff88]/20 uppercase">
                {{ typeof p.categoria === 'object' ? p.categoria?.nombre : (p.categoria || 'GENÉRICO') }}
              </span>
            </div>
          </div>

          <div class="flex justify-between items-end mt-2 gap-2">
            <div>
              <p class="text-lg sm:text-xl text-[#00ff88] font-mono font-black">${{ p.precio_venta || p.precio || 0 }}</p>
              <p :class="['text-[9px] sm:text-[10px] font-black uppercase mt-1 tracking-widest', (p.stock ?? p.cantidad ?? 0) < 10 ? 'text-[#ef4444]' : 'text-[#819da7]']">
                Stock: {{ p.stock ?? p.cantidad ?? 0 }}
              </p>
            </div>
            
            <button 
              @click="addToCart(p)" 
              :disabled="(p.stock ?? p.cantidad ?? 0) <= 0"
              :class="[
                'flex items-center justify-center gap-1 sm:gap-2 px-3 sm:px-4 py-2 rounded-xl text-[9px] sm:text-[10px] font-black uppercase tracking-widest transition-all w-24 sm:w-auto',
                (p.stock ?? p.cantidad ?? 0) <= 0 
                  ? 'bg-red-500/10 text-red-500 border border-red-500/20 cursor-not-allowed opacity-50' 
                  : 'bg-transparent border border-[#00ff88]/30 hover:bg-[#00ff88]/10 text-[#00ff88]'
              ]"
            >
              🛒 <span class="hidden sm:inline">{{ (p.stock ?? p.cantidad ?? 0) <= 0 ? 'AGOTADO' : 'AÑADIR' }}</span>
              <span class="sm:hidden">{{ (p.stock ?? p.cantidad ?? 0) <= 0 ? '---' : 'AÑADIR' }}</span>
            </button> 
          </div>
        </div>

        <div v-if="productosFiltrados.length === 0" class="col-span-full text-center py-10 opacity-50">
          <span class="text-4xl mb-4 block drop-shadow-[0_0_10px_rgba(0,255,136,0.5)]">👻</span>
          <p class="text-lg sm:text-xl font-bold text-[#819da7]">Datos no encontrados</p>
          <p class="text-[10px] sm:text-sm text-[#819da7]/70 font-mono mt-2">Intenta ajustar los parámetros de búsqueda</p>
        </div>

      </div>
    </div>

    <aside class="w-full xl:w-[450px] bg-[#0c1215] rounded-[2rem] sm:rounded-[3rem] border border-[#00ff88]/10 p-5 sm:p-10 flex flex-col shadow-[0_10px_40px_rgba(0,0,0,0.8)] relative overflow-hidden flex-shrink-0 min-h-[400px]">
      <div class="absolute top-0 right-0 w-24 sm:w-32 h-24 sm:h-32 bg-[#00ff88]/5 rounded-bl-full pointer-events-none"></div>
      
      <h2 class="text-xs sm:text-sm font-black uppercase tracking-[0.3em] text-[#819da7] mb-6 sm:mb-8 border-b border-[#ffffff]/5 pb-4">Ticket de Operación</h2>
      
      <div class="flex-1 space-y-3 sm:space-y-4 overflow-y-auto pr-1 sm:pr-2 custom-scrollbar">
        
        <div v-for="item in cart" :key="item.id" class="flex flex-col gap-2 sm:gap-3 bg-[#05080a] p-3 sm:p-4 rounded-xl sm:rounded-2xl border border-[#ffffff]/5 group hover:border-[#00ff88]/30 transition-colors">
          
          <div class="flex justify-between items-start gap-2">
            <p class="text-xs sm:text-sm font-bold text-white group-hover:text-[#00ff88] transition-colors leading-tight line-clamp-2" :title="item.nombre">{{ item.nombre }}</p>
            <button 
              @click="removeFromCart(item.id)" 
              class="text-[#ef4444]/50 hover:text-[#ef4444] transition-colors font-black text-[10px] sm:text-xs px-2 py-1 rounded-md hover:bg-red-500/10 flex-shrink-0"
            >
              ✕
            </button>           
          </div>

          <div class="flex justify-between items-end mt-1">
            <div class="flex items-center gap-2 sm:gap-4 bg-[#0c1215] rounded-lg sm:rounded-xl border border-[#ffffff]/10 px-2 sm:px-3 py-1 sm:py-1.5 shadow-inner">
              <button @click="decrementarCantidad(item.id)" class="text-[#819da7] hover:text-white font-black text-sm sm:text-lg transition-transform hover:scale-110 px-1">-</button>
              <span class="text-[#00ff88] font-mono text-xs sm:text-sm font-black w-4 text-center">{{ item.cantidad }}</span>
              <button @click="incrementarCantidad(item)" class="text-[#819da7] hover:text-white font-black text-sm sm:text-lg transition-transform hover:scale-110 px-1">+</button>
            </div>

            <div class="text-right">
              <p class="text-[9px] sm:text-[10px] text-[#819da7] font-mono mb-0.5">${{ item.precio }} c/u</p>
              <p class="font-bold font-mono text-[#00ff88] text-base sm:text-lg leading-none">${{ (item.cantidad * item.precio).toFixed(2) }}</p>
            </div>
          </div>
        </div>
        
        <div v-if="cart.length === 0" class="text-center py-10 sm:py-20 opacity-30">
          <span class="text-5xl sm:text-6xl mb-4 block">🧾</span>
          <p class="italic text-[10px] sm:text-xs text-[#819da7] mt-2 font-mono">Esperando datos de entrada...</p>
        </div>
      </div>

      <div class="mt-4 sm:mt-6 pt-4 sm:pt-6 border-t border-[#ffffff]/10">
        <div class="flex justify-between items-end mb-6 sm:mb-8 bg-[#05080a] p-3 sm:p-4 rounded-xl sm:rounded-2xl border border-[#ffffff]/5">
          <span class="text-[10px] sm:text-xs font-black uppercase tracking-widest text-[#819da7]">Total a transferir</span>
          <span class="text-2xl sm:text-4xl font-mono font-black text-[#00ff88] drop-shadow-[0_0_10px_rgba(0,255,136,0.3)]">${{ cartTotal.toFixed(2) }}</span>
        </div>
        
        <button 
          @click="finalizarVenta" 
          :disabled="cart.length === 0" 
          class="w-full bg-transparent border-2 border-[#00ff88] text-[#00ff88] hover:bg-[#00ff88] hover:text-[#05080a] py-3 sm:py-5 rounded-xl sm:rounded-2xl font-black uppercase tracking-[0.15em] sm:tracking-[0.2em] transition-all shadow-[0_0_10px_rgba(0,255,136,0.2)] hover:shadow-[0_0_30px_rgba(0,255,136,0.6)] disabled:opacity-20 disabled:cursor-not-allowed text-xs sm:text-sm"
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
const searchResults = ref([]); 

const categorias = ['Todos', 'Motor', 'Frenos', 'Suspensión', 'Eléctrico', 'Filtros', 'Accesorios'];
const categoriaActiva = ref('Todos');

// 1. Carga inicial desde MySQL
const cargarInventarioInicial = async () => {
  try {
    const res = await axios.get(`${API_SQL}/productos`);
    searchResults.value = res.data.data ? res.data.data : res.data;
  } catch(e) {
    console.error("Error cargando inventario inicial:", e);
    searchResults.value = [];
  }
};

onMounted(() => {
  cargarInventarioInicial();
});

// 2. Filtro de búsqueda frontend
const productosFiltrados = computed(() => {
  return searchResults.value.filter(p => {
    const term = searchQuery.value.toLowerCase().trim();
    const nombre = (p.nombre || p.nombre_producto || '').toLowerCase();
    const sku = (p.sku || '').toLowerCase();
    const cumpleBusqueda = nombre.includes(term) || sku.includes(term);

    let cumpleCategoria = true;
    if (categoriaActiva.value !== 'Todos') {
       const nombreCat = (typeof p.categoria === 'object' ? p.categoria?.nombre : p.categoria) || '';
       const catNormalizada = nombreCat.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
       const buscadaNormalizada = categoriaActiva.value.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
       cumpleCategoria = catNormalizada === buscadaNormalizada;
    }

    return cumpleBusqueda && cumpleCategoria;
  });
});

// 3. Gestión de Carrito
const addToCart = (p) => {
  const stockDisponible = p.stock ?? p.cantidad ?? 0;
  if (stockDisponible <= 0) return;

  const item = cart.value.find(i => i.id === p.id);
  if (item) {
    if (item.cantidad < stockDisponible) {
      item.cantidad++;
    } else {
      alert("⚠️ Has alcanzado el límite de stock en bodega.");
    }
  } else {
    cart.value.push({ 
      ...p, 
      cantidad: 1, 
      stock_maximo: stockDisponible, 
      nombre: p.nombre || p.nombre_producto,
      precio: p.precio_venta || p.precio || 0
    });
  }
};

const incrementarCantidad = (item) => {
  if (item.cantidad < item.stock_maximo) item.cantidad++;
  else alert("⚠️ Sin stock suficiente.");
};

const decrementarCantidad = (id) => {
  const item = cart.value.find(i => i.id === id);
  if (item) item.cantidad > 1 ? item.cantidad-- : removeFromCart(id);
};

const removeFromCart = (id) => {
  cart.value = cart.value.filter(i => i.id !== id);
};

const cartTotal = computed(() => cart.value.reduce((acc, i) => acc + (i.precio * i.cantidad), 0));

// 4. EL PUENTE (Finalizar Venta)
// 4. EL PUENTE (Finalizar Venta) - CORREGIDO ✅
const finalizarVenta = async () => {
  if (!cart.value.length) return;
  
  try {
    const payloadVenta = {
      // 1. Debe ser el ID de Mongo del vendedor
      id_vendedor: props.userId, 
      
      // 2. Cambiamos 'items' por 'productos_vendidos' para que coincida con tu Schema de Mongo
      productos_vendidos: cart.value.map(item => ({
        id_producto: String(item.id), // Lo convertimos a String por si acaso
        cantidad: item.cantidad,
        precio_unitario: item.precio,
        subtotal: item.cantidad * item.precio
      })),
      
      // 3. Cambiamos 'total' por 'total_venta' (Esto quita el error de validación)
      total_venta: cartTotal.value, 
      
      estatus: 'Completada',
      fecha_hora: new Date()
    };
    
    // Petición al Backend NoSQL (Node)
    await axios.post(`${API_NOSQL}/ventas`, payloadVenta);
    
    // Petición al Backend SQL (Laravel) para bajar el stock
    // Petición al Backend SQL (Laravel) para bajar el stock
// 1. Preparamos el arreglo simple
    const itemsParaDescontar = cart.value.map(item => ({
      id: item.id,
      cantidad: item.cantidad
    }));

    // 2. Enviamos el arreglo directo sin "envolverlo" en otra llave
    // Muchas veces Laravel espera recibir el array directamente en el body
    await axios.post(`${API_SQL}/productos/descontar-stock`, itemsParaDescontar);

    alert("✅ ¡Venta registrada y stock actualizado!");
    
    // Limpiar todo tras el éxito
    cart.value = []; 
    searchQuery.value = '';
    categoriaActiva.value = 'Todos'; 
    cargarInventarioInicial(); 
    
  } catch (e) {
    const errorReal = e.response?.data?.error || e.response?.data?.message || e.message;
    alert("❌ Error en la operación: " + errorReal);
    console.error("Detalle del error:", e.response?.data);
  }
};
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.3s ease-out; }
@keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }

::-webkit-scrollbar { width: 6px; height: 6px; }
::-webkit-scrollbar-track { background: #05080a; border-radius: 10px; }
::-webkit-scrollbar-thumb { background: #0c1215; border: 1px solid rgba(0, 255, 136, 0.2); border-radius: 10px; }

.scrollbar-hide::-webkit-scrollbar { display: none; }
.scrollbar-hide { -ms-overflow-style: none; scrollbar-width: none; }

/* 👈 Ajuste clave para dispositivos táctiles */
.overflow-x-auto, .overflow-y-auto {
  -webkit-overflow-scrolling: touch;
}
</style>