import axios from 'axios';

const apiNoSQL = import.meta.env.VITE_API_URL_NOSQL;
const apiSQL = import.meta.env.VITE_API_URL_SQL;

export const apiService = {
    getVentasVendedor: (id) => axios.get(`${apiNoSQL}/ventas/vendedor/${id}`),
    // Asegúrate de que esta ruta exista en tu backend de Laravel (api.php)
    getProductosStock: () => axios.get(`${apiSQL}/productos/bajo-stock`)
};