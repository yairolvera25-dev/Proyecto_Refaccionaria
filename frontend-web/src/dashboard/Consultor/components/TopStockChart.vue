<template>
  <section class="chart-section">
    <div class="chart-header">
      <h3>TOP STOCK <span class="badge">{{ topItems.length }} productos</span></h3>
      <i class="icon-bar">📊</i>
    </div>
    
    <div class="chart-container">
      <div v-if="topItems.length === 0" class="empty-chart">
        Sin datos suficientes para graficar
      </div>

      <div 
        v-for="(item, index) in topItems" 
        :key="item._id || index"
        class="bar-wrapper"
        @click="$emit('selectProduct', item)"
      >
        <span class="bar-value">{{ item.cantidad || item.stock || 0 }}</span>
        
        <div class="bar-body" :style="{ height: getBarHeight(item) + '%', backgroundColor: colors[index % colors.length] }">
          <div class="bar-glare"></div>
          <div class="bar-stripes"></div>
        </div>
        
        <div class="bar-dot" :style="{ backgroundColor: colors[index % colors.length] }"></div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  items: { type: Array, default: () => [] }
});

// Evento que se dispara al tocar una barra
defineEmits(['selectProduct']);

// Colores idénticos a tu diseño de Flutter
const colors = ['#39FF14', '#2979FF', '#FFB300', '#D500F9', '#00E5FF', '#F50057', '#1DE9B6'];

// Filtramos y ordenamos los 7 con más stock
const topItems = computed(() => {
  const sorted = [...props.items].sort((a, b) => {
    const qtyA = a.cantidad || a.stock || 0;
    const qtyB = b.cantidad || b.stock || 0;
    return qtyB - qtyA;
  });
  return sorted.slice(0, 7);
});

// Calculamos la altura de la barra más alta para que las demás sean proporcionales
const maxStock = computed(() => {
  if (topItems.value.length === 0) return 1;
  const highest = topItems.value[0].cantidad || topItems.value[0].stock || 0;
  return highest > 0 ? highest : 1;
});

const getBarHeight = (item) => {
  const qty = item.cantidad || item.stock || 0;
  const pct = (qty / maxStock.value) * 100;
  return Math.max(pct, 15); // Altura mínima del 15% para que no desaparezcan
};
</script>

<style scoped>
.chart-section {
  background: #1A1D24; padding: 20px; border-radius: 16px; 
  border: 1px solid rgba(255,255,255,0.05); margin-bottom: 24px;
}
.chart-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;}
.chart-header h3 { margin: 0; font-size: 0.8rem; color: #888; letter-spacing: 2px;}
.badge { background: rgba(57,255,20,0.1); color: #39FF14; padding: 2px 8px; border-radius: 10px; font-size: 0.6rem; margin-left: 10px;}
.icon-bar { color: #39FF14; }

.chart-container {
  height: 150px; display: flex; align-items: flex-end; justify-content: space-around;
  gap: 10px; padding-bottom: 10px; border-bottom: 1px solid rgba(255,255,255,0.1);
}

.empty-chart { width: 100%; text-align: center; color: #555; font-size: 0.9rem; margin-bottom: 50px;}

.bar-wrapper {
  flex: 1; display: flex; flex-direction: column; align-items: center; height: 100%; justify-content: flex-end;
  cursor: pointer; transition: transform 0.2s; position: relative;
}
.bar-wrapper:hover { transform: translateY(-5px); }

.bar-value { color: #00E5FF; font-size: 0.8rem; font-weight: bold; margin-bottom: 5px; opacity: 0; transition: opacity 0.2s;}
.bar-wrapper:hover .bar-value { opacity: 1; }

.bar-body {
  width: 100%; border-radius: 4px 4px 0 0; position: relative; overflow: hidden;
  box-shadow: 0 -5px 15px rgba(0,0,0,0.3); transition: height 0.5s ease-out;
}

/* El brillo superior (Efecto 3D) */
.bar-glare {
  position: absolute; top: 0; left: 0; right: 0; height: 4px; background: rgba(255,255,255,0.3);
}

/* La cinta de precaución abajo */
.bar-stripes {
  position: absolute; bottom: 0; left: 0; right: 0; height: 12px;
  background: repeating-linear-gradient(45deg, #000, #000 5px, #FFEA00 5px, #FFEA00 10px);
  opacity: 0.8;
}

.bar-dot { width: 4px; height: 4px; border-radius: 50%; margin-top: 10px; }
</style>