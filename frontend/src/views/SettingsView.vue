<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Configuración</p>
        <h1 class="page-title">Ajustes</h1>
        <p class="page-sub">Gestiona tu cuenta, apariencia y preferencias 🛠️</p>
      </div>
    </header>

    <!-- ===== Mi cuenta ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>👤 Mi cuenta</h2>
        <p>Datos básicos de tu cuenta ZenFit.</p>
      </header>

      <div class="account-row">
        <div class="avatar-big">{{ initial }}</div>
        <div class="account-info">
          <span class="account-name">{{ user?.fullName || 'Usuario' }}</span>
          <span class="account-email">{{ user?.email }}</span>
        </div>
      </div>
    </section>

    <!-- ===== Cambiar contraseña ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>🔒 Cambiar contraseña</h2>
        <p>Si no te acuerdas de la actual, <router-link to="/forgot-password">recupera el acceso</router-link>.</p>
      </header>

      <form class="form" @submit.prevent="changePwd">
        <div class="grid">
          <div class="field field-wide">
            <label>Contraseña actual</label>
            <input type="password" v-model="pwd.current" autocomplete="current-password" />
          </div>
          <div class="field">
            <label>Nueva contraseña</label>
            <input type="password" v-model="pwd.next" autocomplete="new-password" placeholder="Mínimo 8 caracteres" />
          </div>
          <div class="field">
            <label>Repite la nueva contraseña</label>
            <input type="password" v-model="pwd.confirm" autocomplete="new-password" />
          </div>
        </div>
        <div class="actions">
          <button class="btn-primary" type="submit" :disabled="pwdSaving || !pwdCanSubmit">
            {{ pwdSaving ? 'Guardando…' : 'Actualizar contraseña' }}
          </button>
          <span v-if="pwdSavedMsg" class="saved">{{ pwdSavedMsg }}</span>
          <span v-if="pwdError" class="error">{{ pwdError }}</span>
        </div>
      </form>
    </section>

    <!-- ===== Apariencia ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>🎨 Apariencia</h2>
        <p>Cambia entre tema claro y oscuro según tu preferencia.</p>
      </header>

      <div class="theme-row">
        <button
          type="button"
          class="theme-option"
          :class="{ active: theme === 'light' }"
          @click="setTheme('light')"
        >
          <span class="theme-icon">☀️</span>
          <span class="theme-name">Claro</span>
        </button>
        <button
          type="button"
          class="theme-option"
          :class="{ active: theme === 'dark' }"
          @click="setTheme('dark')"
        >
          <span class="theme-icon">🌙</span>
          <span class="theme-name">Oscuro</span>
        </button>
      </div>
    </section>

    <!-- ===== Preferencias de sueño ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>⏰ Preferencias de sueño</h2>
        <p>Hora a la que sueles despertarte. Se usará por defecto en la <router-link to="/sleep">calculadora de sueño</router-link>.</p>
      </header>

      <div class="field" style="max-width: 220px;">
        <label>Hora habitual de despertar</label>
        <input type="time" v-model="wakeTime" @change="saveWakeTime" />
      </div>
      <span v-if="wakeSavedMsg" class="saved">{{ wakeSavedMsg }}</span>
    </section>

    <!-- ===== Notificaciones (placeholder) ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>🔔 Notificaciones</h2>
        <p>Aún no están disponibles — llegarán muy pronto.</p>
      </header>

      <div class="placeholder-row">
        <span class="badge-soon">Próximamente</span>
        <p>Te avisaremos cuando puedas configurar recordatorios de hábitos, sueño y entrenamientos.</p>
      </div>
    </section>

    <!-- ===== Sesión ===== -->
    <section class="card setting-card danger-card">
      <header class="card-head">
        <h2>🚪 Cerrar sesión</h2>
        <p>Cierras la sesión solo en este navegador. Tu cuenta y tus datos se mantienen intactos.</p>
      </header>

      <div class="actions">
        <button class="btn-danger" type="button" @click="doLogout" :disabled="loggingOut">
          {{ loggingOut ? 'Cerrando…' : 'Cerrar sesión' }}
        </button>
      </div>
    </section>

    <!-- ===== Acerca de ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>ℹ️ Acerca de ZenFit</h2>
        <p>Plataforma de bienestar integral — fitness, nutrición, sueño y hábitos.</p>
      </header>

      <ul class="about-list">
        <li><strong>Versión</strong> 1.0.0</li>
        <li><strong>Proyecto Intermodular DAM</strong> — Samuel López</li>
        <li><router-link to="/blog">Blog</router-link></li>
        <li><router-link to="/">Volver a la página de inicio</router-link></li>
      </ul>
    </section>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../composables/useAuth'
import { useTheme } from '../composables/useTheme'
import { authService } from '../services/authService'

const router = useRouter()
const { user, logout } = useAuth()
const { theme, toggle: toggleTheme } = useTheme()

const initial = computed(() => (user.value?.fullName || 'U').trim().charAt(0).toUpperCase())

// ===== Tema =====
const setTheme = (t) => {
  if (theme.value !== t) toggleTheme()
}

// ===== Cambiar contraseña =====
const pwd = reactive({ current: '', next: '', confirm: '' })
const pwdSaving = ref(false)
const pwdError = ref('')
const pwdSavedMsg = ref('')
const pwdCanSubmit = computed(() =>
  pwd.current.length > 0 && pwd.next.length >= 8 && pwd.next === pwd.confirm
)

const changePwd = async () => {
  pwdError.value = ''
  pwdSavedMsg.value = ''
  if (pwd.next.length < 8) {
    pwdError.value = 'La nueva contraseña debe tener al menos 8 caracteres'
    return
  }
  if (pwd.next !== pwd.confirm) {
    pwdError.value = 'Las contraseñas no coinciden'
    return
  }
  pwdSaving.value = true
  try {
    await authService.changePassword({ currentPassword: pwd.current, newPassword: pwd.next })
    pwdSavedMsg.value = '✓ Contraseña actualizada'
    pwd.current = ''; pwd.next = ''; pwd.confirm = ''
    setTimeout(() => (pwdSavedMsg.value = ''), 3000)
  } catch (e) {
    const data = e?.response?.data
    pwdError.value = data?.message
      || (data?.fieldErrors && Object.values(data.fieldErrors).flat().join(' · '))
      || 'No se pudo cambiar la contraseña'
  } finally {
    pwdSaving.value = false
  }
}

// ===== Preferencias de sueño =====
const SLEEP_STORAGE_KEY = 'zenfit.sleep.wakeTime'
const wakeTime = ref(localStorage.getItem(SLEEP_STORAGE_KEY) || '07:00')
const wakeSavedMsg = ref('')
const saveWakeTime = () => {
  localStorage.setItem(SLEEP_STORAGE_KEY, wakeTime.value)
  wakeSavedMsg.value = '✓ Hora guardada'
  setTimeout(() => (wakeSavedMsg.value = ''), 2000)
}

// ===== Cerrar sesión =====
const loggingOut = ref(false)
const doLogout = async () => {
  if (!confirm('¿Cerrar sesión en este navegador?')) return
  loggingOut.value = true
  try {
    await logout()
    router.push('/')
  } finally {
    loggingOut.value = false
  }
}
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 880px; margin: 0 auto; }
.page-head { margin-bottom: 28px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }

.card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 18px;
  padding: 24px 28px; box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.setting-card { margin-bottom: 18px; display: flex; flex-direction: column; gap: 16px; }
.danger-card { border-color: rgba(239,68,68,0.25); }

.card-head h2 { font-family: var(--font-display); font-size: 22px; letter-spacing: 0.5px; color: var(--dark); margin-bottom: 4px; }
.card-head p { font-size: 13px; color: var(--gray); line-height: 1.5; }
.card-head a { color: var(--blue-mid); font-weight: 600; text-decoration: none; }
.card-head a:hover { text-decoration: underline; }

/* Mi cuenta */
.account-row { display: flex; align-items: center; gap: 16px; }
.avatar-big {
  width: 56px; height: 56px; border-radius: 50%;
  background: var(--yellow); color: #1E3A8A;
  display: flex; align-items: center; justify-content: center;
  font-weight: 800; font-size: 22px; flex-shrink: 0;
}
.account-info { display: flex; flex-direction: column; gap: 2px; min-width: 0; }
.account-name { font-size: 16px; font-weight: 700; color: var(--dark); }
.account-email { font-size: 13px; color: var(--gray); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

/* Cambiar contraseña */
.form { display: flex; flex-direction: column; gap: 14px; }
.grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; }
.field { display: flex; flex-direction: column; gap: 7px; }
.field-wide { grid-column: 1 / -1; }
.field label { font-size: 13px; font-weight: 500; color: var(--dark); }
.field input {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 11px 14px; border-radius: 10px; font-size: 14px; font-family: var(--font-body); outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.field input:focus { border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }

.actions { display: flex; align-items: center; gap: 14px; flex-wrap: wrap; }
.btn-primary {
  background: var(--yellow); color: #1E3A8A; border: none; padding: 12px 24px; border-radius: 10px;
  font-size: 14px; font-weight: 700; font-family: var(--font-body); cursor: pointer;
  box-shadow: 0 4px 16px rgba(242,230,56,0.3); transition: opacity 0.2s, transform 0.2s;
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-danger {
  background: transparent; border: 1px solid rgba(239,68,68,0.5); color: #DC2626;
  padding: 12px 24px; border-radius: 10px; font-size: 14px; font-weight: 700;
  font-family: var(--font-body); cursor: pointer; transition: background 0.2s, border-color 0.2s;
}
.btn-danger:hover:not(:disabled) { background: rgba(239,68,68,0.08); border-color: #DC2626; }
.btn-danger:disabled { opacity: 0.5; cursor: not-allowed; }

.saved { color: #2563EB; font-size: 13px; font-weight: 600; }
.error { color: #DC2626; font-size: 13px; }

/* Tema */
.theme-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; max-width: 360px; }
.theme-option {
  background: var(--off-white); border: 2px solid var(--gray-light); color: var(--dark);
  padding: 16px; border-radius: 12px; cursor: pointer;
  display: flex; flex-direction: column; align-items: center; gap: 6px;
  font-family: var(--font-body); transition: border-color 0.2s, background 0.2s;
}
.theme-option:hover { border-color: var(--blue-mid); }
.theme-option.active {
  border-color: #F2E638;
  background: linear-gradient(160deg, rgba(242,230,56,0.12), var(--off-white));
  box-shadow: 0 4px 18px rgba(242,230,56,0.25);
}
.theme-icon { font-size: 24px; }
.theme-name { font-size: 13px; font-weight: 700; color: var(--dark); }

/* Notificaciones placeholder */
.placeholder-row { display: flex; align-items: center; gap: 14px; color: var(--gray); font-size: 13px; }
.badge-soon {
  background: #1E3A8A; color: #FFFFFF; font-size: 11px; font-weight: 700;
  padding: 4px 10px; border-radius: 100px; letter-spacing: 0.5px;
}

/* Acerca de */
.about-list { list-style: none; display: flex; flex-direction: column; gap: 8px; }
.about-list li { font-size: 13px; color: var(--gray); }
.about-list strong { color: var(--dark); margin-right: 8px; }
.about-list a { color: var(--blue-mid); font-weight: 600; text-decoration: none; }
.about-list a:hover { text-decoration: underline; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .grid { grid-template-columns: 1fr; }
  .theme-row { grid-template-columns: 1fr; }
}
</style>
