<template>
  <section class="top-stats">
    <div class="stat-card">
      <div class="icon-box neon-blue">📦</div>
      <div class="stat-info">
        <h3>{{ totalItems }}</h3>
        <p>TOTAL PIEZAS</p>
      </div>
    </div>
    <div class="stat-card">
      <div class="icon-box neon-green">💵</div>
      <div class="stat-info">
        <h3>${{ totalValue.toFixed(2) }}</h3>
        <p>VALOR INVENTARIO</p>
      </div>
    </div>
    <div class="stat-card alert">
      <div class="icon-box neon-red">⚠️</div>
      <div class="stat-info">
        <h3 class="text-red">{{ stockCritico }}</h3>
        <p>STOCK CRÍTICO</p>
      </div>
    </div>
  </section>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  items: { type: Array, default: () => [] }
});

const totalItems = computed(() => props.items.length);

const totalValue = computed(() => {
  return props.items.reduce((acc, item) => {
    const price = item.precio || item.precio_unitario || 0;
    const qty = item.cantidad || item.stock || 0;
    return acc + (price * qty);
  }, 0);
});

const stockCritico = computed(() => {
  return props.items.filter(item => (item.cantidad || item.stock || 0) < 5).length;
});
</script>

<style scoped>
.top-stats { display: flex; gap: 20px; margin-bottom: 24px; flex-wrap: wrap; }
.stat-card {
  flex: 1; min-width: 200px; background: #1A1D24; padding: 20px;
  border-radius: 16px; display: flex; align-items: center; gap: 16px;
  border: 1px solid rgba(255,255,255,0.05); transition: transform 0.2s, border-color 0.2s;
}
.stat-card:hover { transform: translateY(-5px); border-color: rgba(57,255,20,0.3); cursor: pointer; }
.stat-card.alert:hover { border-color: rgba(255,82,82,0.5); }
.icon-box {
  width: 48px; height: 48px; border-radius: 12px;
  display: flex; align-items: center; justify-content: center; font-size: 1.5rem;
  background: rgba(255,255,255,0.05);
}
.neon-green { color: #39FF14; box-shadow: 0 0 15px rgba(57,255,20,0.2); }
.neon-red { color: #FF5252; box-shadow: 0 0 15px rgba(255,82,82,0.2); }
.neon-blue { color: #00E5FF; box-shadow: 0 0 15px rgba(0,229,255,0.2); }
.stat-info h3 { margin: 0; font-size: 1.8rem; color: #fff; }
.stat-info p { margin: 0; font-size: 0.7rem; color: #888; letter-spacing: 1px; }
.text-red { color: #FF5252 !important; }
</style>