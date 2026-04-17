import { ref, computed } from 'vue';
import { apiService } from '../services/apiService'; // 💡 Usamos tu servicio limpio

export function useDashboard() { // 💡 Ya no pide parámetros
    const ordenes = ref([]);
    const productosBajoStock = ref([]);
    const rangoActivo = ref('Semana');
    const series = ref([{ name: 'Ventas $', data: [] }]);
    const categoriasGrafica = ref([]);

    const formatearDinero = (n) => new Intl.NumberFormat('es-MX', { style: 'currency', currency: 'MXN' }).format(n);
    const formatearFecha = (f) => new Date(f).toLocaleDateString('es-MX', { day: '2-digit', month: 'short' });
    const formatearHora = (f) => new Date(f).toLocaleTimeString('es-MX', { hour: '2-digit', minute: '2-digit', hour12: true });

    const kpis = computed(() => {
        const total = ordenes.value.reduce((acc, v) => acc + (v.total_venta || 0), 0);
        return [
            { label: 'Ingresos Totales', value: formatearDinero(total), color: 'text-[#00ff88]', sub: 'Historial NoSQL' },
            { label: 'Órdenes Cerradas', value: ordenes.value.length.toString(), color: 'text-white', sub: 'Historial total' },
            { label: 'Comisión (5%)', value: formatearDinero(total * 0.05), color: 'text-[#00ff88]/80', sub: 'Para el Vendedor' },
            { label: 'Stock Crítico', value: productosBajoStock.value.length.toString(), color: 'text-[#f97316]', sub: 'Alerta SQL' }
        ];
    });

    // 🔥 TU MAGIA MATEMÁTICA INTACTA
    const procesarDatosGrafica = () => {
        const ahora = new Date();
        if (rangoActivo.value === 'Semana') {
            const diaActual = ahora.getDay();
            const diff = ahora.getDate() - (diaActual === 0 ? 6 : diaActual - 1);
            const inicioSemana = new Date(ahora.setDate(diff));
            inicioSemana.setHours(0, 0, 0, 0);

            const datos = [0, 0, 0, 0, 0, 0, 0];
            ordenes.value.filter(v => new Date(v.createdAt) >= inicioSemana).forEach(v => {
                const d = new Date(v.createdAt).getDay();
                datos[d === 0 ? 6 : d - 1] += (v.total_venta || 0);
            });

            series.value = [{ name: 'Ventas Semanales', data: datos }];
            categoriasGrafica.value = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];

        } else if (rangoActivo.value === 'Mes') {
            const inicioMes = new Date(ahora.getFullYear(), ahora.getMonth(), 1);
            const ultimoDia = new Date(ahora.getFullYear(), ahora.getMonth() + 1, 0).getDate();
            let datos = new Array(ultimoDia).fill(0);

            ordenes.value.filter(v => new Date(v.createdAt) >= inicioMes).forEach(v => {
                datos[new Date(v.createdAt).getDate() - 1] += (v.total_venta || 0);
            });

            series.value = [{ name: 'Ventas del Mes', data: datos }];
            categoriasGrafica.value = Array.from({ length: ultimoDia }, (_, i) => (i + 1).toString());

        } else if (rangoActivo.value === 'Año') {
            const inicioAnio = new Date(ahora.getFullYear(), 0, 1);
            let datos = new Array(12).fill(0);

            ordenes.value.filter(v => new Date(v.createdAt) >= inicioAnio).forEach(v => {
                datos[new Date(v.createdAt).getMonth()] += (v.total_venta || 0);
            });

            series.value = [{ name: 'Ventas del Año', data: datos }];
            categoriasGrafica.value = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
        }
    };

    // 🛡️ EL BLINDAJE ANTI-ERRORES MEJORADO
    const cargarDatos = async (userId) => {
        if (!userId) return;

        // 1. Cargar Ventas (MongoDB)
        try {
            const resVentas = await apiService.getVentasVendedor(userId);
            if (resVentas.data && resVentas.data.exito) {
                ordenes.value = resVentas.data.ventas;
            } else if (Array.isArray(resVentas.data)) {
                ordenes.value = resVentas.data;
            }
            procesarDatosGrafica();
        } catch (e) {
            console.error("Error al cargar ventas de Mongo:", e);
        }

        // 2. Cargar Alerta de Inventario (Laravel SQL)
        try {
            const resStock = await apiService.getProductosStock();
            // Dependiendo de cómo armaste tu controlador en Laravel, leemos los datos:
            productosBajoStock.value = resStock.data.data ? resStock.data.data : resStock.data;
        } catch (e) {
            console.error("Error al cargar stock de Laravel:", e);
            productosBajoStock.value = []; // Si Laravel falla, no crashea la pantalla
        }
    };

    return {
        ordenes, productosBajoStock, rangoActivo, series, kpis, categoriasGrafica,
        formatearDinero, formatearFecha, formatearHora,
        cargarDatos, procesarDatosGrafica
    };
}