import axios from 'axios';

const API_URL = 'http://localhost:8000/api';

export const productoService = {
    getAll: async () => {
        try {
            const response = await axios.get(`${API_URL}/productos`);
            return response.data;
        } catch (error) {
            console.error("Error al traer productos:", error);
            throw error;
        }
    }
};
