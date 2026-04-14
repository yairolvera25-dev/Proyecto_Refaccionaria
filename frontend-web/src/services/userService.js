import axios from 'axios';

const API_URL = 'http://localhost:4000/api/auth';

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
