<template>
  <div class="app-shell" :class="{ 'sidebar-open': open }">
    <!-- Botón de despliegue (siempre visible) -->
    <button class="toggle" @click="toggle" :aria-label="open ? 'Ocultar menú' : 'Mostrar menú'">
      <span v-if="open">✕</span>
      <span v-else>☰</span>
    </button>

    <!-- Overlay (solo móvil) -->
    <div class="overlay" :class="{ show: open }" @click="open = false"></div>

    <!-- Sidebar -->
    <aside class="sidebar" :class="{ open }">
      <router-link to="/dashboard" class="brand" @click="closeOnMobile">
        <img src="@/assets/logo-trim.png" alt="ZenFit" class="brand-img" />
      </router-link>

      <nav class="nav">
        <router-link
          v-for="item in items"
          :key="item.to"
          :to="item.to"
          class="nav-item"
          active-class="active"
          @click="closeOnMobile"
        >
          {{ item.label }}
        </router-link>
      </nav>

      <router-link to="/settings" class="user-box" @click="closeOnMobile">
        <div class="user-row">
          <div class="avatar">{{ initial }}</div>
          <div class="user-meta">
            <span class="user-name">{{ user?.fullName || 'Usuario' }}</span>
            <span class="user-email">{{ user?.email }}</span>
          </div>
          <span class="user-gear" aria-hidden="true">⚙️</span>
        </div>
      </router-link>
    </aside>

    <!-- Contenido -->
    <main class="content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useAuth } from '../composables/useAuth'

const { user } = useAuth()

const STORAGE_KEY = 'zenfit.sidebarOpen'
// Por defecto abierta en escritorio; recuerda la última preferencia
const saved = localStorage.getItem(STORAGE_KEY)
const open = ref(saved === null ? window.innerWidth > 900 : saved === 'true')

const toggle = () => {
  open.value = !open.value
  localStorage.setItem(STORAGE_KEY, String(open.value))
}

const closeOnMobile = () => {
  if (window.innerWidth <= 900) open.value = false
}

const items = [
  { to: '/dashboard', label: 'Dashboard' },
  { to: '/workouts', label: 'Entrenar' },
  { to: '/diets', label: 'Dietas' },
  { to: '/habits', label: 'Hábitos' },
  { to: '/sleep', label: 'Sueño' },
  { to: '/profile', label: 'Perfil' },
  { to: '/settings', label: 'Ajustes' },
]

const initial = computed(() => (user.value?.fullName || 'U').trim().charAt(0).toUpperCase())
</script>

<style scoped>
.app-shell { min-height: 100vh; background: var(--off-white); }

/* ---- Botón de despliegue ---- */
.toggle {
  position: fixed; top: 18px; left: 18px; z-index: 60;
  width: 42px; height: 42px;
  background: #1E3A8A; border: none; border-radius: 10px;
  color: #FFFFFF; font-size: 18px; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  box-shadow: 0 4px 14px rgba(30,58,138,0.3);
  transition: left 0.25s ease, background 0.2s;
}
.toggle:hover { background: #16306b; }
/* Cuando la sidebar está abierta, el botón se coloca dentro de ella */
.sidebar-open .toggle { left: 198px; background: rgba(0,0,0,0.22); }
.sidebar-open .toggle:hover { background: rgba(0,0,0,0.4); }

/* ---- Sidebar ---- */
.sidebar {
  position: fixed;
  top: 0; left: 0; bottom: 0;
  width: 250px;
  /* Fondo fijo (no usa var --blue) para que la sidebar sea siempre oscura
     y los textos blancos se lean tanto en tema claro como oscuro */
  background: linear-gradient(180deg, #1E3A8A 0%, #16306b 100%);
  display: flex;
  flex-direction: column;
  padding: 28px 18px;
  gap: 28px;
  z-index: 50;
  transform: translateX(-100%);
  transition: transform 0.25s ease;
}
.sidebar.open { transform: translateX(0); }

.brand { display: flex; align-items: center; text-decoration: none; padding: 4px 8px 0; }
.brand-img {
  height: 64px; width: auto; display: block;
  /* Sidebar tiene fondo azul oscuro -> el logo se renderiza en blanco */
  filter: brightness(0) invert(1);
  transition: transform 0.2s ease;
}
.brand:hover .brand-img { transform: scale(1.04); }

.nav { display: flex; flex-direction: column; gap: 6px; flex: 1; margin-top: 8px; }
.nav-item {
  padding: 13px 18px; border-radius: 12px;
  color: rgba(255,255,255,0.72);
  font-size: 15px; font-weight: 500; text-decoration: none;
  transition: background 0.18s, color 0.18s;
}
.nav-item:hover { background: rgba(0,0,0,0.28); color: #FFFFFF; }
.nav-item.active {
  background: var(--yellow);
  color: #1E3A8A;
  font-weight: 700;
  box-shadow: 0 6px 18px rgba(242,230,56,0.35);
}

/* user-box es un link clickable a /settings */
.user-box {
  border-top: 1px solid rgba(255,255,255,0.12);
  padding-top: 14px;
  text-decoration: none;
  display: block;
  border-radius: 12px;
  transition: background 0.18s;
}
.user-box:hover { background: rgba(0,0,0,0.22); }
.user-row {
  display: flex; align-items: center; gap: 12px;
  padding: 10px 8px;
}
.avatar {
  width: 38px; height: 38px; border-radius: 50%;
  background: var(--yellow); color: #1E3A8A;
  display: flex; align-items: center; justify-content: center;
  font-weight: 800; font-size: 16px; flex-shrink: 0;
}
.user-meta { display: flex; flex-direction: column; overflow: hidden; flex: 1; min-width: 0; }
.user-name { font-size: 14px; font-weight: 600; color: #FFFFFF; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.user-email { font-size: 11px; color: rgba(255,255,255,0.55); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.user-gear { font-size: 16px; opacity: 0.55; flex-shrink: 0; transition: opacity 0.18s, transform 0.18s; }
.user-box:hover .user-gear { opacity: 1; transform: rotate(45deg); }

/* ---- Contenido ---- */
.content {
  margin-left: 0;
  min-height: 100vh;
  padding-top: 64px;
  transition: margin-left 0.25s ease;
}
/* En escritorio, al desplegar la sidebar el contenido se desplaza */
@media (min-width: 901px) {
  .sidebar-open .content { margin-left: 250px; padding-top: 0; }
  .app-shell:not(.sidebar-open) .content { padding-top: 64px; }
}

/* ---- Overlay (solo móvil) ---- */
.overlay { display: none; position: fixed; inset: 0; background: rgba(17,24,39,0.5); z-index: 40; }
@media (max-width: 900px) {
  .overlay.show { display: block; }
}
</style>
