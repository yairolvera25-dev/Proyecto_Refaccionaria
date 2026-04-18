import axios from 'axios';

// Supongamos que VITE_API_URL_NOSQL = "http://localhost:4000/api"
const apiNoSQL = import.meta.env.VITE_API_URL_NOSQL;
const apiSQL = import.meta.env.VITE_API_URL_SQL;

export const apiService = {
    // 💡 La URL final será: http://localhost:4000/api/ventas/vendedor/ID
    getVentasVendedor: (id) => axios.get(`${apiNoSQL}/ventas/vendedor/${id}`),

    // Consulta a Laravel (SQL)
    getProductosStock: () => axios.get(`${apiSQL}/productos/bajo-stock`)
};