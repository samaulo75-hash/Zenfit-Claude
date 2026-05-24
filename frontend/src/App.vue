<script setup>
import { onMounted } from 'vue'
import { useServerStatus, warmUpBackend } from './composables/useServerStatus'
import { baseApiURL } from './lib/http'

const { isWaking } = useServerStatus()

// Warm-up: en cuanto carga la SPA, hacemos un ping a /actuator/health en
// segundo plano para que Render despierte el contenedor mientras el usuario
// navega la landing. Asi cuando intente login, el backend ya esta vivo.
onMounted(() => {
  warmUpBackend(baseApiURL)
})
</script>

<template>
  <router-view />

  <!-- Banner global: aparece cuando una peticion HTTP lleva > 4s sin responder.
       Tipico cold start del free tier de Render (servidor durmiendo). -->
  <transition name="banner">
    <div v-if="isWaking" class="waking-banner" role="status" aria-live="polite">
      <span class="spinner" aria-hidden="true"></span>
      <div class="msg">
        <strong>Conectando con el servidor…</strong>
        <span>El servidor está despertando, puede tardar unos segundos.</span>
      </div>
    </div>
  </transition>
</template>

<style scoped>
.waking-banner {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  z-index: 9999;
  display: flex;
  align-items: center;
  gap: 14px;
  padding: 14px 22px 14px 18px;
  background: rgba(30, 58, 138, 0.97);
  color: #FFFFFF;
  border-radius: 100px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(8px);
  -webkit-backdrop-filter: blur(8px);
  font-family: var(--font-body);
  font-size: 13px;
  max-width: calc(100vw - 32px);
}

.spinner {
  width: 18px;
  height: 18px;
  border: 2px solid rgba(255, 255, 255, 0.2);
  border-top-color: #F2E638;
  border-radius: 50%;
  animation: spin 0.9s linear infinite;
  flex-shrink: 0;
}

.msg { display: flex; flex-direction: column; gap: 2px; }
.msg strong { font-weight: 700; font-size: 13px; }
.msg span { color: rgba(255, 255, 255, 0.75); font-size: 12px; }

@keyframes spin { to { transform: rotate(360deg); } }

.banner-enter-active, .banner-leave-active {
  transition: opacity 0.25s ease, transform 0.25s ease;
}
.banner-enter-from { opacity: 0; transform: translate(-50%, 12px); }
.banner-leave-to   { opacity: 0; transform: translate(-50%, 12px); }
</style>
