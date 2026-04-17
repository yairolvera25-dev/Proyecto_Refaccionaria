import { createRouter, createWebHistory } from 'vue-router';

import Login from '@/features/auth/views/Login.vue';
import Register from '@/features/auth/views/Register.vue';

const routes = [
    {
        path: '/',
        name: 'Login',
        component: Login,
        meta: { requiresAuth: false }
    },
    {
        path: '/registro',
        name: 'Register',
        component: Register,
        meta: { requiresAuth: false }
    },
    {
        path: '/admin',
        name: 'Admin',
        component: () => import('@/features/admin/views/AdminDashboard.vue'),
        meta: { requiresAuth: true, role: 'administrador' }
    },
    {
        path: '/vendedor',
        name: 'Vendedor',
        component: () => import('@/features/vendedor/views/VendedorDashboard.vue'),
        meta: { requiresAuth: true, role: 'vendedor' }
    },
    {
        path: '/consultor',
        name: 'Consultor',
        component: () => import('@/features/consultor/views/ConsultorDashboard.vue'),
        meta: { requiresAuth: true, role: 'consultor' }
    }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

// Navigation Guard Inteligente y RBAC Universal
router.beforeEach((to, from, next) => {
    const userJson = localStorage.getItem('user');
    let user = null;
    let userRole = null;

    if (userJson) {
        try {
            user = JSON.parse(userJson);
            // Empatar el naming convention exacto del backend a minúsculas
            userRole = user.rol?.toLowerCase() || user.role?.toLowerCase();
        } catch(e) {
            localStorage.removeItem('user');
        }
    }

    // 1. Si la ruta requiere autenticación (rutas privadas)
    if (to.meta.requiresAuth) {
        if (!user || !userRole) {
            // Sin token -> expulsión en seco al login
            return next('/');
        }

        // Token presente, pero intenta entrar a ruta de OTRO rol
        if (to.meta.role && userRole !== to.meta.role) {
            // Redirección inteligente al dashboard que le corresponde
            if (userRole === 'administrador') return next('/admin');
            if (userRole === 'vendedor') return next('/vendedor');
            if (userRole === 'consultor') return next('/consultor');
            return next('/'); // Fallback
        }

        // Acceso permitido
        return next();
    } else {
        // 2. Si la ruta NO requiere autenticación (Rutas públicas: Login, Register)
        if (user && userRole) {
            // Si ya está logueado, evitar que vea el login. Mandarlo a su dashboard.
            if (userRole === 'administrador') return next('/admin');
            if (userRole === 'vendedor') return next('/vendedor');
            if (userRole === 'consultor') return next('/consultor');
            return next('/');
        }
        
        // Acceso permitido a rutas públicas
        return next();
    }
});

export default router;