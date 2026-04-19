<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  form: Object,
  modoEdicion: Boolean
});
const emit = defineEmits(['guardar', 'cerrar']);
</script>

<template>
  <div class="modal-overlay" @click.self="emit('cerrar')">
    <div class="modal-card border-neon">
      <h3>{{ modoEdicion ? 'EDITAR' : 'REGISTRAR' }} USUARIO</h3>
      
      <div class="form-grid">
        <input v-model="form.nombre" placeholder="Nombre completo">
        <input v-model="form.email" placeholder="Correo electrónico">
        <input v-if="!modoEdicion" v-model="form.password" type="password" placeholder="Contraseña">
        <select v-model="form.nombre_rol">
          <option value="Administrador">Administrador</option>
          <option value="Vendedor">Vendedor</option>
          <option value="Consultor">Consultor</option>
        </select>
      </div>

      <div class="modal-footer">
        <button @click="emit('cerrar')" class="btn-cancel">CANCELAR</button>
        <button @click="emit('guardar')" class="btn-save">GUARDAR CAMBIOS</button>
      </div>
    </div>
  </div>
</template>

<style scoped>
/* Fondo oscuro con desenfoque */
.modal-overlay { 
  position: fixed; 
  inset: 0; 
  background: rgba(0,0,0,0.85); 
  backdrop-filter: blur(5px); 
  display: flex; 
  align-items: center; 
  justify-content: center; 
  z-index: 9999; /* Asegura que el modal siempre esté al frente */
  padding: 20px; /* Margen para que no pegue en las orillas del celular */
  box-sizing: border-box;
}

/* Tarjeta del modal */
.modal-card { 
  background: #0f172a; 
  width: 100%; /* Cambiado a 100% para responsividad */
  max-width: 450px; /* Límite máximo en PC */
  padding: 30px; 
  border-radius: 20px; 
  border: 1px solid #00d2ff; 
  box-shadow: 0 0 20px rgba(0, 210, 255, 0.2); 
  box-sizing: border-box;
}

h3 { 
  color: #fff; 
  margin-top: 0; 
  text-align: center;
  letter-spacing: 1px;
}

/* Formulario */
.form-grid { 
  display: flex; 
  flex-direction: column; 
  gap: 15px; 
  margin: 20px 0; 
}

.form-grid input, 
.form-grid select { 
  width: 100%;
  box-sizing: border-box;
  background: #05080f; 
  border: 1px solid #1e293b; 
  padding: 12px; 
  border-radius: 10px; 
  color: white; 
  transition: border-color 0.3s; 
}

.form-grid input:focus, 
.form-grid select:focus { 
  border-color: #00d2ff; 
  outline: none; 
  box-shadow: 0 0 8px rgba(0,210,255,0.2); 
}

/* Botones */
.modal-footer { 
  display: flex; 
  gap: 10px; 
}

.btn-save { 
  flex: 1; 
  background: #00d2ff; 
  color: #000; 
  border: none; 
  padding: 12px; 
  border-radius: 10px; 
  font-weight: bold; 
  cursor: pointer; 
  box-shadow: 0 0 10px rgba(0, 210, 255, 0.4); 
  transition: transform 0.2s; 
}

.btn-save:hover { 
  transform: translateY(-2px); 
  box-shadow: 0 5px 15px rgba(0, 210, 255, 0.6); 
}

.btn-cancel { 
  flex: 1; 
  background: #334155; 
  border: none; 
  padding: 12px; 
  border-radius: 10px; 
  color: white; 
  cursor: pointer; 
  transition: background 0.2s; 
}

.btn-cancel:hover { 
  background: #475569; 
}

/* --- AJUSTES PARA CELULAR --- */
@media (max-width: 480px) {
  .modal-card {
    padding: 20px; /* Un poco menos de padding interior para dar espacio */
  }
  
  .modal-footer {
    flex-direction: column; /* Apila los botones de Guardar y Cancelar */
    gap: 12px;
  }
  
  .btn-save, .btn-cancel {
    width: 100%;
  }
}
</style>