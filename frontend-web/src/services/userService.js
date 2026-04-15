import axios from 'axios';

// ✅ AHORA
const API_URL = `${import.meta.env.VITE_API_URL_NOSQL}/auth`; // Quitamos la / del final
// ...
return axios.post(`${API_URL}/login`, { email, password }); // La / se queda solo aquí

export const userService = {
    getAll: async () => {
        try {
            const response = await axios.get(API_URL);
            return response.data;
        } catch (error) {
            console.error("Error al traer usuarios:", error);
            throw error;
        }
    }
};
