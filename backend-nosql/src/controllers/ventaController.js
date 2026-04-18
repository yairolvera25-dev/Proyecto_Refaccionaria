import axios from 'axios';

const apiNoSQL = import.meta.env.VITE_API_URL_NOSQL;
const apiSQL = import.meta.env.VITE_API_URL_SQL;

export const apiService = {
    // 💡 URL limpia: http://localhost:4000/api/ventas/vendedor/...
    getVentasVendedor: (id) => axios.get(`${apiNoSQL}/ventas/vendedor/${id}`),
    getProductosStock: () => axios.get(`${apiSQL}/productos/bajo-stock`)
};