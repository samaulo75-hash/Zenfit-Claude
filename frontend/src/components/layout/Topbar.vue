<template>
  <nav class="topbar" :class="{ scrolled: isScrolled }">
    <!-- Logo -->
    <router-link to="/" class="logo">
      <img src="@/assets/logo-trim.png" alt="ZenFit" class="logo-img" />
    </router-link>

    <!-- Nav links desktop -->
    <div class="nav-links">
      <router-link to="/" class="nav-link" exact-active-class="router-link-active">Inicio</router-link>
      <router-link to="/blog" class="nav-link">Blog</router-link>
    </div>

    <!-- CTA buttons -->
    <div class="nav-actions">
      <button class="theme-btn" @click="toggleTheme" :title="theme === 'dark' ? 'Tema claro' : 'Tema oscuro'">
        {{ theme === 'dark' ? '☀️' : '🌙' }}
      </button>
      <template v-if="!isAuth">
        <router-link to="/login" class="btn-ghost">Iniciar sesión</router-link>
        <router-link to="/register" class="btn-yellow">Empieza gratis</router-link>
      </template>
      <template v-else>
        <router-link to="/dashboard" class="btn-yellow">Ir a mi panel →</router-link>
      </template>
    </div>

    <!-- Mobile hamburger -->
    <button class="hamburger" @click="menuOpen = !menuOpen" aria-label="Menú">
      <span :class="{ open: menuOpen }"></span>
      <span :class="{ open: menuOpen }"></span>
      <span :class="{ open: menuOpen }"></span>
    </button>

    <!-- Mobile dropdown -->
    <div class="mobile-menu" :class="{ active: menuOpen }">
      <router-link to="/" class="mobile-link" @click="menuOpen = false">Inicio</router-link>
      <router-link to="/blog" class="mobile-link" @click="menuOpen = false">Blog</router-link>
      <template v-if="!isAuth">
        <router-link to="/login" class="mobile-link" @click="menuOpen = false">Iniciar sesión</router-link>
        <router-link to="/register" class="mobile-cta" @click="menuOpen = false">Empieza gratis →</router-link>
      </template>
      <template v-else>
        <router-link to="/dashboard" class="mobile-cta" @click="menuOpen = false">Ir a mi panel →</router-link>
      </template>
    </div>
  </nav>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { useAuth } from '../../composables/useAuth'
import { useTheme } from '../../composables/useTheme'

const menuOpen = ref(false)
const isScrolled = ref(false)
const { isAuthenticated } = useAuth()
const { theme, toggle: toggleTheme } = useTheme()

const isAuth = isAuthenticated

const handleScroll = () => { isScrolled.value = window.scrollY > 40 }
onMounted(() => window.addEventListener('scroll', handleScroll))
onUnmounted(() => window.removeEventListener('scroll', handleScroll))
</script>

<style scoped>
.topbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 100;
  display: flex;
  align-items: center;
  padding: 0 48px;
  height: 72px;
  background: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(12px);
  border-bottom: 1px solid transparent;
  transition: border-color 0.3s, box-shadow 0.3s;
}
.topbar.scrolled {
  border-bottom-color: var(--gray-light);
  box-shadow: 0 2px 16px rgba(30, 58, 138, 0.08);
}

.logo {
  display: inline-flex;
  align-items: center;
  text-decoration: none;
  background: #fff;
  padding: 9px 14px;
  border-radius: 12px;
  box-shadow: 0 4px 14px rgba(0, 0, 0, 0.14);
}
.logo-img {
  height: 40px;
  width: auto;
  display: block;
  transition: transform 0.2s ease, filter 0.2s ease;
}
/* En modo oscuro el fondo de la topbar es azul muy oscuro y el logo
   tambien lo es -> lo renderizamos en blanco para que sea visible. */
:global(.dark) .logo-img { filter: brightness(0) invert(1); }
.logo:hover .logo-img { transform: scale(1.04); }

.nav-links {
  display: flex;
  gap: 36px;
  margin: 0 auto;
}
.nav-link {
  font-size: 14px;
  font-weight: 500;
  color: var(--gray);
  letter-spacing: 0.3px;
  transition: color 0.2s;
}
.nav-link:hover, .nav-link.router-link-active { color: var(--blue); }

.nav-actions {
  display: flex;
  align-items: center;
  gap: 12px;
}
.theme-btn {
  background: var(--white);
  border: 1px solid var(--gray-light);
  width: 38px; height: 38px;
  border-radius: 50%;
  font-size: 16px;
  display: inline-flex; align-items: center; justify-content: center;
  transition: border-color 0.2s, transform 0.2s;
}
.theme-btn:hover { border-color: var(--blue-mid); transform: scale(1.06); }
.btn-ghost {
  background: none;
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 8px 18px;
  border-radius: 100px;
  font-size: 13px;
  font-weight: 500;
  transition: border-color 0.2s, color 0.2s;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
}
.btn-ghost:hover { border-color: var(--blue-mid); color: var(--blue-mid); }

.btn-yellow {
  background: var(--yellow);
  color: #1E3A8A;
  padding: 9px 22px;
  border-radius: 100px;
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  transition: opacity 0.2s, transform 0.2s;
  border: none;
}
.btn-yellow:hover { opacity: 0.88; transform: translateY(-1px); }

.user-name {
  font-size: 13px;
  color: var(--gray);
}

/* Hamburger */
.hamburger {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: none;
  border: none;
  padding: 4px;
  margin-left: auto;
}
.hamburger span {
  display: block;
  width: 24px;
  height: 2px;
  background: var(--dark);
  border-radius: 2px;
  transition: all 0.3s;
}

/* Mobile menu */
.mobile-menu {
  display: none;
  position: absolute;
  top: 72px;
  left: 0;
  right: 0;
  background: var(--white);
  border-top: 1px solid var(--gray-light);
  border-bottom: 1px solid var(--gray-light);
  flex-direction: column;
  padding: 20px 24px;
  gap: 4px;
  box-shadow: 0 8px 24px rgba(30,58,138,0.08);
}
.mobile-menu.active { display: flex; }
.mobile-link {
  padding: 14px 0;
  border-bottom: 1px solid var(--gray-light);
  font-size: 15px;
  color: var(--dark);
  background: none;
  border-right: none;
  border-left: none;
  border-top: none;
  text-align: left;
  text-decoration: none;
  display: block;
  transition: color 0.2s;
}
.mobile-link:hover { color: var(--blue-mid); }
.mobile-cta {
  margin-top: 12px;
  background: var(--yellow);
  color: #1E3A8A;
  padding: 14px 20px;
  border-radius: 10px;
  font-weight: 600;
  text-align: center;
  text-decoration: none;
  display: block;
}

@media (max-width: 768px) {
  .topbar { padding: 0 20px; }
  .nav-links, .nav-actions { display: none; }
  .hamburger { display: flex; }
}
</style>
