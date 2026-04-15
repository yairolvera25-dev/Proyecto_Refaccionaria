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
        // Subimos un nivel y entramos a dashboard/
        component: () => import('../dashboard/Administrador/AdminDashboard.vue')
    },
    {
        path: '/vendedor',
        name: 'Vendedor',
        component: () => import('../dashboard/Vendedor/VendedorDashboard.vue')
    },
    {
        path: '/consultor',
        name: 'Consultor',
        component: () => import('../dashboard/Consultor/ConsultorDashboard.vue')
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;