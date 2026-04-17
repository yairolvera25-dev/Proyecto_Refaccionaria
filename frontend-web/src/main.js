import { createApp } from 'vue';
import App from '@/App.vue';
// 1. IMPORTA EL ROUTER QUE ACABAS DE CREAR
import router from '@/router';
// Tus estilos...
import './style.css';

const app = createApp(App);

// 2. DILE A VUE QUE USE EL ROUTER (Antes de montar)
app.use(router);

app.mount('#app');