import axios from 'axios';

// Usamos la variable de entorno que definiste en el .env
const API_URL = import.meta.env.VITE_API_URL_NOSQL;

export const authService = {
    async login(email, password) {
        try {
            // Ahora la URL se construye automáticamente (ej: http://localhost:4000/api/auth/login)
            const response = await axios.post(`${API_URL}/auth/login`, { email, password });

            // Si el login es exitoso, devolvemos los datos (que ya traen el ROL que configuramos en Mongo)
            return response.data;
        } catch (error) {
            // Formateamos el error para que la vista lo entienda fácilmente
            throw new Error(error.response?.data?.msg || 'Error de conexión con el servidor');
        }
    }
};