<template>
  <div v-if="isOpen" class="fixed inset-0 z-[100] flex items-center justify-center p-4 modal-wrapper">
    <div @click="$emit('close')" class="absolute inset-0 bg-black/90 backdrop-blur-md"></div>

    <div class="relative bg-[#0c1215] border border-[#00ff88]/30 w-full max-w-2xl rounded-[3rem] shadow-[0_0_60px_rgba(0,0,0,1)] overflow-hidden animate-fade-in flex flex-col md:flex-row">
      
      <div id="print-area" class="bg-white text-black p-8 w-full md:w-2/3 font-mono ticket-print-visual">
        <div class="text-center border-b-2 border-dashed border-black pb-4 mb-4">
          <h3 class="text-xl font-black uppercase tracking-tighter text-black">Refaccionaria Los Amigos</h3>
          <div class="flex justify-between text-[9px] mt-2 px-2 text-black font-bold">
            <span>Vend: {{ order?.id_vendedor?.slice(-5) || 'SISTEMA' }}</span>
            <span>Folio: #{{ order?._id?.slice(-6).toUpperCase() }}</span>
          </div>
          <p class="text-[10px] font-bold mt-1 text-black">{{ formatearFechaCompleta(order?.createdAt) }}</p>
        </div>

        <div class="overflow-x-auto w-full"><table class="w-full text-[11px] mb-6 border-collapse">
          <thead>
            <tr class="border-b-2 border-black text-black text-left">
              <th class="pb-1 w-10">Cant</th>
              <th class="pb-1">Descripción / Pieza</th>
              <th class="pb-1 text-right w-16">Total</th>
            </tr>
          </thead>
          <tbody class="text-black">
            <tr v-for="item in (order?.productos_vendidos || [])" :key="item.id_producto || item._id" class="border-b border-gray-200">
              <td class="py-2 align-top text-black">{{ item.cantidad || 1 }}</td>
              <td class="py-2 uppercase leading-tight text-black">
                {{ item.nombre_pieza || item.nombre || 'PIEZA' }}
              </td>
              <td class="py-2 text-right font-bold align-top text-black">
                ${{ ((item.cantidad || 1) * (item.precio_unitario || item.precio || 0)).toFixed(2) }}
              </td>
            </tr>
            <tr v-if="!order?.productos_vendidos?.length">
              <td colspan="3" class="py-10 text-center text-[10px] italic opacity-50 text-black">
                Sin detalles de productos
              </td>
            </tr>
          </tbody>
        </table></div>

        <div class="border-t-2 border-dashed border-black pt-4 text-black">
          <div class="flex justify-between items-center text-sm font-black italic uppercase text-black">
            <span>Total a Pagar</span>
            <span class="text-2xl">${{ order?.total_venta }}</span>
          </div>
          <div class="mt-8 text-center">
            <p class="text-[10px] font-black uppercase border-2 border-black p-2 text-black">*** Gracias por su preferencia ***</p>
          </div>
        </div>
      </div>

      <div class="p-8 flex-1 bg-[#05080a]/50 flex flex-col justify-between border-l border-[#ffffff]/5">
        <div class="mb-10 text-center md:text-left">
          <div class="flex items-center gap-2 mb-4 justify-center md:justify-start">
            <span class="w-2 h-2 bg-[#00ff88] rounded-full animate-pulse"></span>
            <h4 class="text-[#00ff88] font-black uppercase text-xs tracking-widest">Módulo de Salida</h4>
          </div>
          <p class="text-[10px] text-[#819da7] leading-relaxed">
            Formato optimizado para ticketera térmica de 80mm. 
          </p>
        </div>

        <div class="space-y-4">
          <button @click="imprimirTicket" class="w-full bg-[#00ff88] text-black py-4 rounded-2xl font-black text-[11px] uppercase tracking-widest shadow-neon hover:scale-[1.02] transition-all flex items-center justify-center gap-2">
            <span>🖨️</span> Ejecutar Impresión
          </button>
          <button @click="$emit('close')" class="w-full bg-transparent border border-[#ffffff]/10 text-[#819da7] py-4 rounded-2xl font-black text-[11px] uppercase tracking-widest hover:bg-[#ffffff]/5 transition-all">
            Volver
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
defineProps(['isOpen', 'order']);
defineEmits(['close']);

const formatearFechaCompleta = (f) => {
  if (!f) return '';
  return new Date(f).toLocaleString('es-MX', {
    day: '2-digit', month: '2-digit', year: 'numeric',
    hour: '2-digit', minute: '2-digit', hour12: true
  });
};

const imprimirTicket = () => {
  // 1. Capturamos el HTML de tu ticket
  const ticketHTML = document.getElementById('print-area').innerHTML;

  // 2. Creamos un Iframe "Fantasma" fuera de la vista de la pantalla
  const iframe = document.createElement('iframe');
  iframe.style.position = 'absolute';
  iframe.style.top = '-10000px'; 
  document.body.appendChild(iframe);

  const doc = iframe.contentWindow.document;

  // 3. Recolectamos todos tus estilos de Tailwind para que no pierda el formato
  let stylesHtml = '';
  document.querySelectorAll('style, link[rel="stylesheet"]').forEach(s => {
    stylesHtml += s.outerHTML;
  });

  // 4. Inyectamos el ticket en el Iframe con los márgenes de 80mm forzados
  doc.open();
  doc.write(`
    <html>
      <head>
        <title>Ticket de Compra</title>
        ${stylesHtml}
        <style>
          @page { size: 80mm auto; margin: 0; }
          body {
            width: 80mm;
            margin: 0;
            padding: 5mm;
            background-color: white !important;
          }
          * { color: black !important; }
        </style>
      </head>
      <body class="font-mono">
        ${ticketHTML}
      </body>
    </html>
  `);
  doc.close();

  // 5. Le damos medio segundo para que renderice los estilos y ¡Boom!, a imprimir.
  setTimeout(() => {
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
    // Destruimos el iframe después de imprimir para no dejar basura en la memoria
    setTimeout(() => {
      document.body.removeChild(iframe);
    }, 1000);
  }, 500);
};
</script>

<style scoped>
.animate-fade-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1); }
@keyframes fadeIn { from { opacity: 0; transform: scale(0.98); } to { opacity: 1; transform: scale(1); } }
.shadow-neon { box-shadow: 0 0 20px rgba(0, 255, 136, 0.3); }

.ticket-print-visual {
  min-height: 500px;
  box-shadow: inset 0 0 50px rgba(0,0,0,0.05);
  background-color: white !important;
}
</style>