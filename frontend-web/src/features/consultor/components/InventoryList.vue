<template>
  <section class="inventory-section">
    <div class="search-bar">
      <span class="search-icon">🔍</span>
      <input type="text" v-model="search" placeholder="Rastrear SKU o pieza..." />
    </div>

    <div class="filter-container">
      <button v-for="tab in tabs" :key="tab.id" 
        :class="['tab', { active: activeTab === tab.id }]"
        @click="activeTab = tab.id">
        {{ tab.label }}
      </button>
    </div>

    <div class="items-container">
      <div v-for="item in filteredItems" :key="item._id || Math.random()" 
        class="product-card" @click="$emit('selectProduct', item)">
        
        <div class="product-icon" :class="getStatusClass(item)">
          <span v-if="getStatus(item) === 'OK'">✔</span>
          <span v-else-if="getStatus(item) === 'BAJO'">⏳</span>
          <span v-else>⚠️</span>
        </div>

        <div class="product-info">
          <h4>{{ (item.nombreOriginal || 'SIN NOMBRE').toUpperCase() }}</h4>
          <p class="sku">{{ item.sku || 'REF-XXXX' }}</p>
        </div>

        <div class="product-status">
          <span class="qty" :class="getStatusClass(item)">{{ item.cantidad || 0 }}</span>
          <span class="status-badge" :class="getStatusClass(item)">{{ getStatus(item) }}</span>
        </div>
      </div>
      
      <div v-if="filteredItems.length === 0" class="empty-state">
        No se encontraron piezas en esta sección.
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue';
const props = defineProps(['items']);
defineEmits(['selectProduct']);

const search = ref('');
const activeTab = ref('TODOS');

const tabs = [
  { id: 'TODOS', label: 'TODOS' },
  { id: 'OK', label: 'OK ✔' },
  { id: 'BAJO', label: 'BAJO ⚡' },
  { id: 'CRITICO', label: 'CRÍTICO ⚠' }
];

// NUEVAS REGLAS DE INVENTARIO
const getStatus = (item) => {
  const q = item.cantidad || 0;
  if (q >= 5) return 'OK';       // 5 o más es OK
  if (q >= 3) return 'BAJO';     // 3 o 4 es BAJO
  return 'CRITICO';              // Menos de 3 es CRÍTICO
};

const getStatusClass = (item) => getStatus(item).toLowerCase();

const filteredItems = computed(() => {
  let list = props.items || [];
  
  if (activeTab.value !== 'TODOS') {
    list = list.filter(i => getStatus(i) === activeTab.value);
  }
  
  if (search.value) {
    const s = search.value.toLowerCase();
    list = list.filter(i => {
      const nombre = (i.nombreOriginal || '').toLowerCase();
      const sku = (i.sku || '').toLowerCase();
      return nombre.includes(s) || sku.includes(s);
    });
  }
  return list;
});
</script>

<style scoped>
.inventory-section { padding: 10px; margin-bottom: 20px;}
.search-bar { position: relative; margin-bottom: 20px; }
.search-bar input { width: 100%; background: #13151A; border: 1px solid #2A2D35; padding: 14px 40px; border-radius: 12px; color: white; font-size: 0.9rem; outline: none;}
.search-bar input:focus { border-color: #39FF14; }
.search-icon { position: absolute; left: 15px; top: 14px; opacity: 0.7;}
.filter-container { display: flex; gap: 10px; margin-bottom: 20px; }
.tab { flex: 1; padding: 12px; border-radius: 10px; background: #1A1D24; border: 1px solid transparent; color: #888; cursor: pointer; font-weight: bold; font-size: 0.75rem; letter-spacing: 1px; transition: all 0.2s;}
.tab.active { border: 1px solid #FFFFFF; color: #39FF14; background: transparent;}
.product-card { display: flex; align-items: center; background: #13151A; padding: 15px 20px; border-radius: 12px; margin-bottom: 12px; cursor: pointer; border: 1px solid rgba(255,255,255,0.02); transition: transform 0.2s;}
.product-card:hover { transform: translateY(-2px); border-color: rgba(255,255,255,0.1); }
.product-icon { width: 45px; height: 45px; border-radius: 10px; display: flex; align-items: center; justify-content: center; margin-right: 15px; font-size: 1.2rem; background: #1A1D24; }
.product-icon.ok { border: 1px solid #2979FF; color: #2979FF; }
.product-icon.bajo { border: 1px solid #FFB300; color: #FFB300; }
.product-icon.critico { border: 1px solid #FF5252; color: #FF5252; }
.product-info { flex: 1; }
.product-info h4 { margin: 0; font-size: 0.85rem; letter-spacing: 0.5px; color: #fff; margin-bottom: 4px;}
.sku { margin: 0; color: #555; font-size: 0.7rem; font-family: monospace;}
.product-status { text-align: right; }
.qty { display: block; font-size: 1.2rem; font-weight: 900; margin-bottom: 2px;}
.qty.ok { color: #2979FF; }
.qty.bajo { color: #FFB300; }
.qty.critico { color: #FF5252; }
.status-badge { font-size: 0.55rem; padding: 3px 6px; border-radius: 4px; font-weight: 900; letter-spacing: 1px; background: rgba(255,255,255,0.05); }
.empty-state { text-align: center; color: #555; padding: 40px; font-size: 0.9rem;}
</style>