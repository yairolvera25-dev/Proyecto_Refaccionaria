import axios from "axios";

const apiNoSQL = import.meta.env.VITE_API_URL_NOSQL;
const apiSQL = import.meta.env.VITE_API_URL_SQL;

export const apiService = {
  getVentasVendedor: (id) => axios.get(`${apiNoSQL}/ventas/vendedor/${id}`),
  getProductosStock: () => axios.get(`${apiSQL}/productos/bajo-stock`),
  getProductos: () => axios.get(`${apiSQL}/productos`),
  crearProducto: (data) => axios.post(`${apiSQL}/productos`, data),
  editarProducto: (id, data) => axios.put(`${apiSQL}/productos/${id}`, data),
  eliminarProducto: (id) => axios.delete(`${apiSQL}/productos/${id}`)
};
