// src/core/composables/useDashboardVendedor.js
import { ref, computed } from 'vue';
import { ventasService } from '../services/ventaServices';

export function useDashboardVendedor(idVendedor) {
    const ventas = ref([]);
    const cargando = ref(false);
    const error = ref(null);

    // Lógica de negocio (GRASP: Controlador)
    const cargarVentas = async () => {
        cargando.value = true;
        try {
            const data = await ventasService.obtenerVentasVendedor(idVendedor);
            ventas.value = data.ventas;
        } catch (err) {
            error.value = "No se pudieron cargar las estadísticas.";
        } finally {
            cargando.value = false;
        }
    };

    // Cálculos reactivos puros
    const ingresosTotales = computed(() => {
        return ventas.value.reduce((total, venta) => total + venta.total_venta, 0);
    });

    const ordenesCerradas = computed(() => ventas.value.length);

    const comisionVendedor = computed(() => ingresosTotales.value * 0.05);

    return {
        ventas,
        cargando,
        error,
        ingresosTotales,
        ordenesCerradas,
        comisionVendedor,
        cargarVentas
    };
}