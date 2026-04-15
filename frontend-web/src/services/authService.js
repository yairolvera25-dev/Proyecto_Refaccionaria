import axios from 'axios';

// Usamos la variable de entorno de Node/NoSQL
const API_URL = `${import.meta.env.VITE_API_URL_NOSQL}/auth/`;

export const authService = {
    login: async (email, password) => {
        try {
            const response = await axios.post(`${API_URL}/login`, { email, password });
            // Retornamos data.exito y data.user para que coincida con tu Login.vue
            return {
                exito: true,
                user: response.data.user || response.data
            };
        } catch (error) {
            const message = error.response?.data?.message || "Error en el servidor";
            throw new Error(message);
        }
    },
    register: async (userData) => {
        try {
            const response = await axios.post(`${API_URL}/register`, userData);
            return response.data;
        } catch (error) {
            throw error;
        }
    }
};
