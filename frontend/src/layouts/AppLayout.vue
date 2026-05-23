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

      <div class="user-box">
        <div class="user-row">
          <div class="avatar">{{ initial }}</div>
          <div class="user-meta">
            <span class="user-name">{{ user?.fullName || 'Usuario' }}</span>
            <span class="user-email">{{ user?.email }}</span>
          </div>
        </div>
        <button class="theme-toggle" @click="toggleTheme">
          {{ theme === 'dark' ? '☀️ Tema claro' : '🌙 Tema oscuro' }}
        </button>
        <button class="logout" @click="logout">Cerrar sesión</button>
      </div>
    </aside>

    <!-- Contenido -->
    <main class="content">
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../composables/useAuth'
import { useTheme } from '../composables/useTheme'

const router = useRouter()
const { user, logout: doLogout } = useAuth()
const { theme, toggle: toggleTheme } = useTheme()

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
]

const initial = computed(() => (user.value?.fullName || 'U').trim().charAt(0).toUpperCase())

const logout = async () => {
  await doLogout()
  router.push('/')
}
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
  height: 52px; width: auto; display: block;
  background: #fff; border-radius: 12px; padding: 10px;
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
  color: var(--dark);
  font-weight: 700;
  box-shadow: 0 6px 18px rgba(242,230,56,0.35);
}

.user-box {
  border-top: 1px solid rgba(255,255,255,0.12);
  padding-top: 18px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}
.user-row { display: flex; align-items: center; gap: 12px; padding: 0 6px; }
.avatar {
  width: 38px; height: 38px; border-radius: 50%;
  background: var(--yellow); color: var(--dark);
  display: flex; align-items: center; justify-content: center;
  font-weight: 800; font-size: 16px; flex-shrink: 0;
}
.user-meta { display: flex; flex-direction: column; overflow: hidden; }
.user-name { font-size: 14px; font-weight: 600; color: #FFFFFF; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.user-email { font-size: 11px; color: rgba(255,255,255,0.55); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.theme-toggle, .logout {
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0.18);
  color: rgba(255,255,255,0.85);
  padding: 11px; border-radius: 10px;
  font-size: 13px; font-weight: 600; font-family: var(--font-body);
  cursor: pointer; transition: background 0.18s, border-color 0.18s;
}
.theme-toggle:hover { background: rgba(242,230,56,0.18); border-color: rgba(242,230,56,0.5); color: var(--yellow); }
.logout:hover { background: rgba(239,68,68,0.18); border-color: rgba(239,68,68,0.5); color: #FCA5A5; }

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
