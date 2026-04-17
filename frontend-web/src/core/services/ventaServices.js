// src/core/services/ventasService.js
import axios from 'axios';

const API_URL = import.meta.env.VITE_API_URL_NOSQL;

export const ventasService = {
    // Solo hace la petición y devuelve los datos puros
    obtenerVentasVendedor: async (idVendedor) => {
        try {
            const response = await axios.get(`${API_URL}/api/ventas/vendedor/${idVendedor}`);
            return response.data;
        } catch (error) {
            console.error("Error en ventasService:", error);
            throw error;
        }
    }
};