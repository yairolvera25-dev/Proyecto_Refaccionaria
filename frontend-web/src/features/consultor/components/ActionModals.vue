<template>
  <div class="modal-overlay" v-if="selectedItem || showNotifs || showExport" @click.self="$emit('closeAll')">
    
    <div v-if="selectedItem" class="modal-card">
      <div class="modal-header">
        <h3 class="product-title">{{ selectedItem.nombreOriginal || selectedItem.producto }}</h3>
        <p class="product-sku">{{ selectedItem.sku }}</p>
      </div>
      <div class="modal-body">
        <div class="detail-row">
          <span>Stock actual</span>
          <span class="detail-value text-green">{{ selectedItem.cantidad }} unidades</span>
        </div>
        <div class="detail-row">
          <span>Precio unitario</span>
          <span class="detail-value text-blue">${{ selectedItem.precio.toFixed(2) }}</span>
        </div>
      </div>
      <button class="modal-btn" @click="$emit('closeAll')">CERRAR</button>
    </div>

    <div v-if="showNotifs" class="modal-card wide">
      <div class="modal-header">
        <h3 class="product-title">🔔 ALERTAS DE INVENTARIO</h3>
      </div>
      <div class="modal-body notif-list">
        <div class="alert-box" v-for="item in stockCritico" :key="item._id || Math.random()">
          <div class="alert-icon">⚠️</div>
          <div class="alert-info">
            <h4>{{ item.nombreOriginal || 'Sin nombre' }}</h4>
            <p>Stock crítico: {{ item.cantidad }} unidades</p>
          </div>
        </div>
        <p v-if="stockCritico.length === 0" style="color: #888; text-align: center;">Todo en orden. No hay stock crítico.</p>
      </div>
      <button class="modal-btn" @click="$emit('closeAll')">CERRAR</button>
    </div>

    <div v-if="showExport" class="modal-card text-center export-modal">
      <div class="export-icon-box">📊</div>
      <h3 class="export-title">GENERAR REPORTE</h3>
      <p class="export-subtitle">Elige el formato de exportación</p>
      
      <div class="modal-body export-actions">
        <button class="export-btn btn-pdf" @click="$emit('doExport', 'pdf')">📄 Exportar PDF</button>
        <button class="export-btn btn-excel" @click="$emit('doExport', 'excel')">📗 Exportar Excel</button>
      </div>
      <button class="modal-btn-text" @click="$emit('closeAll')">CANCELAR</button>
    </div>

  </div>
</template>

<script setup>
import { computed } from 'vue';

const props = defineProps({
  showNotifs: Boolean,
  showExport: Boolean,
  selectedItem: Object,
  items: { type: Array, default: () => [] }
});

const emit = defineEmits(['closeAll', 'doExport']);

// NUEVA REGLA: Crítico es menos de 3
const stockCritico = computed(() => {
  return props.items.filter(i => (i.cantidad || 0) < 3);
});
</script>

<style scoped>
.modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.85); backdrop-filter: blur(4px); display: flex; align-items: center; justify-content: center; z-index: 1000; }
.modal-card { background: #1A1D24; width: 400px; border-radius: 16px; padding: 24px; border: 1px solid rgba(255,255,255,0.05); box-shadow: 0 10px 40px rgba(0,0,0,0.6); animation: slideUp 0.3s ease-out; }
.modal-card.wide { width: 500px; }
.text-center { text-align: center; }
@keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
.export-modal { padding: 35px 25px; }
.export-icon-box { width: 50px; height: 50px; margin: 0 auto 20px auto; background: #102A14; border: 1px solid #1A4D1A; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
.export-title { margin: 0; color: #fff; font-size: 1.1rem; letter-spacing: 1px; }
.export-subtitle { margin: 10px 0 25px 0; color: #39FF14; font-size: 0.8rem; font-family: monospace; }
.export-actions { display: flex; flex-direction: column; gap: 15px; }
.export-btn { width: 100%; padding: 14px; border-radius: 8px; cursor: pointer; font-weight: bold; font-size: 0.9rem; transition: all 0.2s; display: flex; align-items: center; justify-content: center; gap: 10px; }
.btn-pdf { background: #1f1515; border: 1px solid #4a2525; color: #FF5252; }
.btn-pdf:hover { background: #331a1a; border-color: #FF5252; }
.btn-excel { background: #112211; border: 1px solid #1a441a; color: #39FF14; }
.btn-excel:hover { background: #183318; border-color: #39FF14; }
.modal-btn-text { background: transparent; border: none; color: #666; width: 100%; padding: 15px; margin-top: 10px; cursor: pointer; font-size: 0.75rem; letter-spacing: 2px; font-weight: bold; }
.modal-btn-text:hover { color: #fff; }
.product-title { margin: 0; color: #fff; font-size: 1.1rem; }
.product-sku { margin: 5px 0 15px 0; color: #888; font-size: 0.8rem; font-family: monospace; }
.detail-row { display: flex; justify-content: space-between; padding: 12px 0; border-bottom: 1px dashed rgba(255,255,255,0.05); color: #ccc;}
.detail-value { font-weight: bold; }
.text-green { color: #39FF14; }
.text-blue { color: #2979FF; }
.alert-box { display: flex; align-items: center; background: rgba(255,82,82,0.05); padding: 12px; border-radius: 8px; margin-bottom: 10px; border: 1px solid rgba(255,82,82,0.2);}
.alert-icon { margin-right: 15px; font-size: 1.2rem;}
.alert-info h4 { margin: 0; color: #fff; font-size: 0.9rem;}
.alert-info p { margin: 0; color: #FF5252; font-size: 0.7rem;}
.modal-btn { width: 100%; background: #232730; color: #fff; border: 1px solid rgba(255,255,255,0.1); padding: 15px; border-radius: 8px; margin-top: 20px; cursor: pointer; font-weight: bold; letter-spacing: 1px; }
.modal-btn:hover { background: #39FF14; color: #000; }
</style>