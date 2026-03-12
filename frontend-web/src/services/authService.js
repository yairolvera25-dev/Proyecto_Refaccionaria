import axios from 'axios';

// Única Responsabilidad: Comunicarse con el backend de autenticación
const API_URL = 'http://localhost:3000/api/auth';

export const authService = {
    async login(email, password) {
        try {
            const response = await axios.post(`${API_URL}/login`, { email, password });
            return response.data;
        } catch (error) {
            // Formateamos el error para que la vista lo entienda fácilmente
            throw new Error(error.response?.data?.msg || 'Error de conexión con el servidor');
        }
    }
};