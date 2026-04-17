<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  form: Object,
  modoEdicion: Boolean
});
const emit = defineEmits(['guardar', 'cerrar']);
</script>

<template>
  <div class="modal-overlay">
    <div class="modal-card border-neon">
      <h3>{{ modoEdicion ? 'EDITAR' : 'REGISTRAR' }} PRODUCTO</h3>
      
      <div class="form-grid">
        <input v-model="form.sku" placeholder="SKU Automático" disabled class="disabled-input">
        <input v-model="form.nombre" placeholder="Nombre de refacción">
        <input v-model="form.marca" placeholder="Marca">
        
        <div class="input-group">
          <label class="input-label">Precio de Venta ($)</label>
          <input v-model="form.precio_venta" type="number" placeholder="0.00" min="0">
        </div>
        
        <div class="input-group">
          <label class="input-label">Stock Mínimo en Inventario</label>
          <input v-model="form.stock_minimo" type="number" placeholder="5" min="1">
        </div>
      </div>

      <div class="modal-footer">
        <button @click="emit('cerrar')" class="btn-cancel">CANCELAR</button>
        <button @click="emit('guardar')" class="btn-save">GUARDAR CAMBIOS</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.modal-overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.85); backdrop-filter: blur(5px); display: flex; align-items: center; justify-content: center; z-index: 100; }
.modal-card { background: #0f172a; width: 450px; padding: 30px; border-radius: 20px; border: 1px solid #00d2ff; box-shadow: 0 0 20px rgba(0, 210, 255, 0.2); }
h3 { color: #fff; margin-top: 0; }
.form-grid { display: flex; flex-direction: column; gap: 15px; margin: 20px 0; }
.input-group { display: flex; flex-direction: column; gap: 6px; }
.input-label { font-size: 0.8rem; color: #8ba3cb; align-self: flex-start; margin-left: 4px; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase; }
.form-grid input, .form-grid select { background: #05080f; border: 1px solid #1e293b; padding: 12px; border-radius: 10px; color: white; transition: border-color 0.3s; width: 100%; box-sizing: border-box; }
.form-grid input:focus, .form-grid select:focus { border-color: #00d2ff; outline: none; box-shadow: 0 0 8px rgba(0,210,255,0.2); }
.modal-footer { display: flex; gap: 10px; }
.btn-save { flex: 1; background: #00d2ff; color: #000; border: none; padding: 12px; border-radius: 10px; font-weight: bold; cursor: pointer; box-shadow: 0 0 10px rgba(0, 210, 255, 0.4); transition: transform 0.2s; }
.btn-save:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(0, 210, 255, 0.6); }
.btn-cancel { flex: 1; background: #334155; border: none; padding: 12px; border-radius: 10px; color: white; cursor: pointer; transition: background 0.2s; }
.btn-cancel:hover { background: #475569; }
.disabled-input { opacity: 0.6; background-color: rgba(15, 23, 42, 0.8) !important; cursor: not-allowed; border-color: rgba(0, 210, 255, 0.1) !important; }
</style>
