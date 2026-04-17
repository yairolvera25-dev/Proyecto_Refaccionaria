import { createRouter, createWebHistory } from 'vue-router';

import Login from '../features/auth/views/Login.vue';

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login
    },
    {
        path: '/admin',
        name: 'Admin',
        component: () => import('../features/admin/views/AdminDashboard.vue')
    },
    {
        path: '/vendedor',
        name: 'Vendedor',
        component: () => import('../features/vendedor/views/VendedorDashboard.vue')
    },
    {
        path: '/consultor',
        name: 'Consultor',
        component: () => import('../features/consultor/views/ConsultorDashboard.vue')
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;