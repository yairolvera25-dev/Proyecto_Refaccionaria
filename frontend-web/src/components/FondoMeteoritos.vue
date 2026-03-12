<script setup>
// Única Responsabilidad: Generar y renderizar la animación del fondo
const meteoritos = Array.from({ length: 25 }).map((_, i) => ({
  id: i,
  left: Math.random() * 150 + '%', 
  delay: Math.random() * 5 + 's',
  duration: Math.random() * 3 + 3 + 's',
  colorClass: Math.random() > 0.5 
    ? 'from-transparent to-blue-500/40' 
    : 'from-transparent to-red-500/40'
}));
</script>

<template>
  <div class="absolute inset-0 z-0 pointer-events-none overflow-hidden">
    <div class="absolute inset-0 opacity-20" style="background-image: linear-gradient(0deg, transparent 24%, rgba(255, 255, 255, .05) 25%, rgba(255, 255, 255, .05) 26%, transparent 27%, transparent 74%, rgba(255, 255, 255, .05) 75%, rgba(255, 255, 255, .05) 76%, transparent 77%, transparent), linear-gradient(90deg, transparent 24%, rgba(255, 255, 255, .05) 25%, rgba(255, 255, 255, .05) 26%, transparent 27%, transparent 74%, rgba(255, 255, 255, .05) 75%, rgba(255, 255, 255, .05) 76%, transparent 77%, transparent); background-size: 50px 50px;"></div>
    
    <div 
      v-for="m in meteoritos" 
      :key="m.id"
      class="meteorito absolute top-[-10%] w-[2px] h-[60px] bg-gradient-to-b rounded-full"
      :class="m.colorClass"
      :style="{ left: m.left, animationDelay: m.delay, animationDuration: m.duration }"
    ></div>
  </div>
</template>

<style scoped>
@keyframes caida-meteorito {
  0% { transform: translateY(-10vh) translateX(0) rotate(20deg); opacity: 0; }
  10% { opacity: 1; }
  80% { opacity: 0.8; }
  100% { transform: translateY(120vh) translateX(-40vw) rotate(20deg); opacity: 0; }
}
.meteorito {
  animation-name: caida-meteorito;
  animation-timing-function: linear;
  animation-iteration-count: infinite;
}
</style>