<template>
  <router-link to="/" class="auth-back-btn" :aria-label="'Volver al inicio'">
    <span class="arrow">←</span>
    <span class="text">{{ label }}</span>
  </router-link>
</template>

<script setup>
defineProps({
  label: { type: String, default: 'Volver al inicio' },
})
</script>

<style scoped>
.auth-back-btn {
  position: absolute;
  top: 20px;
  left: 20px;
  z-index: 10;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: rgba(255, 255, 255, 0.1);
  border: 1px solid rgba(255, 255, 255, 0.25);
  color: #FFFFFF;
  border-radius: 100px;
  text-decoration: none;
  font-family: var(--font-body);
  font-size: 13px;
  font-weight: 600;
  backdrop-filter: blur(6px);
  -webkit-backdrop-filter: blur(6px);
  transition: background 0.2s, border-color 0.2s, transform 0.2s;
}

.auth-back-btn:hover {
  background: rgba(255, 255, 255, 0.18);
  border-color: rgba(255, 255, 255, 0.5);
  transform: translateX(-2px);
}

.arrow {
  font-size: 16px;
  line-height: 1;
}

@media (max-width: 768px) {
  /* En movil la columna azul es mas pequena; mantenemos el boton pegado arriba */
  .auth-back-btn { top: 14px; left: 14px; padding: 8px 14px; font-size: 12px; }
}
</style>
