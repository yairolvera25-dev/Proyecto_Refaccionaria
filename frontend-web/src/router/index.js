import { createRouter, createWebHistory } from 'vue-router';
// Subimos un nivel para salir de router/ y entramos a views/
import Login from '../views/Login.vue';

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/admin',
        name: 'Admin',
        // 👇 Fíjate bien: 'administrador' todo en minúsculas
        component: () => import('../features/administrador/AdminDashboard.vue')
    },
    {
        path: '/vendedor',
        name: 'Vendedor',
        // 👇 'vendedor' todo en minúsculas
        component: () => import('../features/vendedor/VendedorDashboard.vue')
    },
    {
        path: '/consultor',
        name: 'Consultor',
        // 👇 'consultor' todo en minúsculas
        component: () => import('../features/consultor/ConsultorDashboard.vue')
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;