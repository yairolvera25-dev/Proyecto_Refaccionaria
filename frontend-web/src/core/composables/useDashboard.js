import { ref, computed } from 'vue';
import axios from 'axios';

export function useDashboard(API_NOSQL, API_SQL) {
    const ordenes = ref([]);
    const productosBajoStock = ref([]);
    const rangoActivo = ref('Semana');
    const series = ref([{ name: 'Ventas $', data: [] }]);
    const categoriasGrafica = ref([]); // 💡 NUEVO: Guardará los días o meses

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
            categoriasGrafica.value = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']; // 💡 Etiquetas Semana

        } else if (rangoActivo.value === 'Mes') {
            const inicioMes = new Date(ahora.getFullYear(), ahora.getMonth(), 1);
            const ultimoDia = new Date(ahora.getFullYear(), ahora.getMonth() + 1, 0).getDate();
            let datos = new Array(ultimoDia).fill(0);

            ordenes.value.filter(v => new Date(v.createdAt) >= inicioMes).forEach(v => {
                datos[new Date(v.createdAt).getDate() - 1] += (v.total_venta || 0);
            });

            series.value = [{ name: 'Ventas del Mes', data: datos }];
            // 💡 Etiquetas Mes (1, 2, 3... hasta 30 o 31)
            categoriasGrafica.value = Array.from({ length: ultimoDia }, (_, i) => (i + 1).toString());

        } else if (rangoActivo.value === 'Año') {
            const inicioAnio = new Date(ahora.getFullYear(), 0, 1);
            let datos = new Array(12).fill(0);

            ordenes.value.filter(v => new Date(v.createdAt) >= inicioAnio).forEach(v => {
                datos[new Date(v.createdAt).getMonth()] += (v.total_venta || 0);
            });

            series.value = [{ name: 'Ventas del Año', data: datos }];
            categoriasGrafica.value = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic']; // 💡 Etiquetas Año
        }
    };

    const cargarDatos = async (userId) => {
        if (!userId) return;
        try {
            const [resVentas, resStock] = await Promise.all([
                axios.get(`${API_NOSQL}/ventas/vendedor/${userId}`),
                axios.get(`${API_SQL}/productos/bajo-stock`)
            ]);
            if (resVentas.data.exito) ordenes.value = resVentas.data.ventas;
            productosBajoStock.value = resStock.data;
            procesarDatosGrafica();
        } catch (e) { console.error("Error al cargar datos:", e); }
    };

    return {
        ordenes, productosBajoStock, rangoActivo, series, kpis, categoriasGrafica, // 💡 Lo exportamos
        formatearDinero, formatearFecha, formatearHora,
        cargarDatos, procesarDatosGrafica
    };
}