<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';

const productos = ref([]);

onMounted(async () => {
  try {
    // Le pedimos los datos a la URL de Laravel que probaste en Postman
    const response = await axios.get('http://127.0.0.1:8000/api/productos');
    productos.value = response.data;
    console.log("¡Éxito! Datos recibidos:", productos.value);
  } catch (error) {
    console.error("Error conectando al backend:", error);
  }
});
</script>

<template>
  <div style="padding: 20px; font-family: sans-serif;">
    <h1>Refaccionaria AWOS</h1>
    <h2>Nuestros Productos:</h2>
    
    <ul>
      <li v-for="producto in productos" :key="producto.id">
        <strong>{{ producto.nombre }}</strong> - Marca: {{ producto.marca }} 
        <br> 
        Precio: ${{ producto.precio_venta }}
      </li>
    </ul>
  </div>
</template>