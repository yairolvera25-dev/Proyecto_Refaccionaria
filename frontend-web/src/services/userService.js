import axios from 'axios';

const API_URL = `${import.meta.env.VITE_API_URL_NOSQL}/auth/`;
// O si el endpoint de usuarios es general:
// const API_URL = `${import.meta.env.VITE_API_URL_NOSQL}/users/`;

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
