<template>
  <div v-if="isOpen" class="fixed inset-0 z-[100] flex items-center justify-center p-4 sm:p-6 modal-wrapper">
    <div @click="$emit('close')" class="absolute inset-0 bg-black/90 backdrop-blur-md"></div>

    <div class="relative bg-[#0c1215] border border-[#00ff88]/30 w-full max-w-2xl rounded-3xl sm:rounded-[3rem] shadow-[0_0_60px_rgba(0,0,0,1)] overflow-hidden animate-fade-in flex flex-col md:flex-row max-h-[90vh] sm:max-h-[85vh]">
      
      <div id="print-area" class="bg-white text-black p-6 sm:p-8 w-full md:w-2/3 font-mono ticket-print-visual overflow-y-auto custom-scrollbar">
        <div class="text-center border-b-2 border-dashed border-black pb-4 mb-4">
          <h3 class="text-lg sm:text-xl font-black uppercase tracking-tighter text-black leading-tight mb-2">Refaccionaria<br>Los Amigos</h3>
          <div class="flex justify-between text-[9px] mt-2 px-2 text-black font-bold">
            <span>Vend: {{ order?.id_vendedor?.slice(-5) || 'SISTEMA' }}</span>
            <span>Folio: #{{ order?._id?.slice(-6).toUpperCase() }}</span>
          </div>
          <p class="text-[10px] font-bold mt-1 text-black">{{ formatearFechaCompleta(order?.createdAt || order?.fecha_hora) }}</p>
        </div>

        <div class="overflow-x-auto w-full table-wrap">
          <table class="w-full text-[10px] sm:text-[11px] mb-6 border-collapse min-w-[200px]">
            <thead>
              <tr class="border-b-2 border-black text-black text-left">
                <th class="pb-1 w-10">Cant</th>
                <th class="pb-1">Descripción / Pieza</th>
                <th class="pb-1 text-right w-16">Total</th>
              </tr>
            </thead>
            <tbody class="text-black">
              <tr v-for="item in (order?.productos_vendidos || [])" :key="item.id_producto || item._id" class="border-b border-gray-200">
                <td class="py-2 align-top text-black font-bold">{{ item.cantidad || 1 }}</td>
                <td class="py-2 uppercase leading-tight text-black pr-2">
                  {{ item.nombre || 'PIEZA GENÉRICA' }}
                </td>
                <td class="py-2 text-right font-bold align-top text-black">
                  ${{ (Number(item.subtotal || (item.cantidad * item.precio_unitario))).toFixed(2) }}
                </td>
              </tr>
              <tr v-if="!order?.productos_vendidos?.length">
                <td colspan="3" class="py-10 text-center text-[10px] italic opacity-50 text-black">
                  Sin detalles de productos
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div class="border-t-2 border-dashed border-black pt-4 text-black space-y-1">
          <div class="flex justify-between text-[10px] font-bold">
            <span>SUBTOTAL:</span>
            <span>${{ (Number(order?.total_venta || 0) / 1.16).toFixed(2) }}</span>
          </div>
          <div class="flex justify-between text-[10px] font-bold">
            <span>IVA (16%):</span>
            <span>${{ (Number(order?.total_venta || 0) - (Number(order?.total_venta || 0) / 1.16)).toFixed(2) }}</span>
          </div>
          <div class="flex justify-between items-center text-sm sm:text-base font-black italic uppercase text-black pt-2 border-t border-black/10">
            <span>Total Neto</span>
            <span class="text-xl sm:text-2xl">${{ Number(order?.total_venta || order?.total || 0).toFixed(2) }}</span>
          </div>
          <div class="mt-8 text-center">
            <p class="text-[9px] sm:text-[10px] font-black uppercase border-2 border-black p-2 text-black">*** Gracias por su preferencia ***</p>
          </div>
        </div>
      </div>

      <div class="p-6 sm:p-8 flex-1 bg-[#05080a] md:bg-[#05080a]/50 flex flex-col justify-between border-t md:border-t-0 md:border-l border-[#ffffff]/10 z-10 shadow-[0_-10px_20px_rgba(0,0,0,0.5)] md:shadow-none">
        <div class="mb-6 md:mb-10 text-center md:text-left hidden sm:block">
          <div class="flex items-center gap-2 mb-3 md:mb-4 justify-center md:justify-start">
            <span class="w-2 h-2 bg-[#00ff88] rounded-full animate-pulse"></span>
            <h4 class="text-[#00ff88] font-black uppercase text-[10px] sm:text-xs tracking-widest">Ticketera Activa</h4>
          </div>
          <p class="text-[9px] sm:text-[10px] text-[#819da7] leading-relaxed">
            Formato optimizado para impresión térmica 80mm. 
          </p>
        </div>

        <div class="space-y-3 sm:space-y-4 mt-auto">
          <button @click="imprimirTicket" class="w-full bg-[#00ff88] text-black py-3 sm:py-4 rounded-xl sm:rounded-2xl font-black text-[10px] sm:text-[11px] uppercase tracking-widest shadow-neon hover:scale-[1.02] transition-all flex items-center justify-center gap-2">
            🖨️ <span class="hidden sm:inline">IMPRIMIR TICKET</span>
            <span class="sm:hidden">IMPRIMIR</span>
          </button>
          <button @click="$emit('close')" class="w-full bg-transparent border border-[#ffffff]/10 text-[#819da7] py-3 sm:py-4 rounded-xl sm:rounded-2xl font-black text-[10px] sm:text-[11px] uppercase tracking-widest hover:bg-[#ffffff]/5 hover:text-white transition-all">
            Cerrar
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
  const ticketHTML = document.getElementById('print-area').innerHTML;
  const iframe = document.createElement('iframe');
  iframe.style.position = 'absolute';
  iframe.style.top = '-10000px'; 
  document.body.appendChild(iframe);

  const doc = iframe.contentWindow.document;

  let stylesHtml = '';
  document.querySelectorAll('style, link[rel="stylesheet"]').forEach(s => {
    stylesHtml += s.outerHTML;
  });

  doc.open();
  doc.write(`
    <html>
      <head>
        <title>Ticket Refaccionaria</title>
        ${stylesHtml}
        <style>
          @page { size: 80mm auto; margin: 0; }
          body {
            width: 80mm;
            margin: 0;
            padding: 5mm;
            background-color: white !important;
            font-family: monospace;
          }
          * { color: black !important; }
          table { width: 100%; border-collapse: collapse; }
          .text-right { text-align: right; }
          .border-b { border-bottom: 1px solid #ccc; }
        </style>
      </head>
      <body>
        ${ticketHTML}
      </body>
    </html>
  `);
  doc.close();

  setTimeout(() => {
    iframe.contentWindow.focus();
    iframe.contentWindow.print();
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
  box-shadow: inset 0 0 50px rgba(0,0,0,0.05);
  background-color: white !important;
}

.custom-scrollbar::-webkit-scrollbar { width: 6px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(0,0,0,0.1); border-radius: 10px; }

.table-wrap, .custom-scrollbar {
  -webkit-overflow-scrolling: touch;
}
</style>