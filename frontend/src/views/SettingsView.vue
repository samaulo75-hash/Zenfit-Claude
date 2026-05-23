<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Configuración</p>
        <h1 class="page-title">Ajustes</h1>
        <p class="page-sub">Gestiona tu cuenta, apariencia, privacidad y preferencias 🛠️</p>
      </div>
    </header>

    <!-- ===== Mi cuenta ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>👤 Mi cuenta</h2>
        <p>Datos básicos de tu cuenta ZenFit. Tu correo es el que usas para iniciar sesión.</p>
      </header>

      <div class="account-row">
        <div class="avatar-big">{{ initial }}</div>
        <div class="account-info">
          <span class="account-name">{{ user?.fullName || 'Usuario' }}</span>
          <span class="account-email">{{ user?.email }}</span>
        </div>
      </div>

      <form class="form" @submit.prevent="saveName">
        <div class="grid">
          <div class="field field-wide">
            <label>Nombre completo</label>
            <input type="text" v-model="nameForm.fullName" maxlength="150" placeholder="Tu nombre completo" />
          </div>
        </div>
        <div class="actions">
          <button class="btn-primary" type="submit" :disabled="nameSaving || !nameCanSubmit">
            {{ nameSaving ? 'Guardando…' : 'Guardar nombre' }}
          </button>
          <span v-if="nameSavedMsg" class="saved">{{ nameSavedMsg }}</span>
          <span v-if="nameError" class="error">{{ nameError }}</span>
        </div>
      </form>
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
        <button type="button" class="theme-option" :class="{ active: theme === 'light' }" @click="setTheme('light')">
          <span class="theme-icon">☀️</span>
          <span class="theme-name">Claro</span>
        </button>
        <button type="button" class="theme-option" :class="{ active: theme === 'dark' }" @click="setTheme('dark')">
          <span class="theme-icon">🌙</span>
          <span class="theme-name">Oscuro</span>
        </button>
      </div>
    </section>

    <!-- ===== Preferencias de la app ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>⚙️ Preferencias de la app</h2>
        <p>Cómo se comporta ZenFit en este dispositivo. No se sincroniza entre navegadores.</p>
      </header>

      <div class="toggle-row">
        <div class="toggle-text">
          <strong>Pedir confirmación antes de eliminar</strong>
          <span>Te preguntaremos cada vez que vayas a borrar un hábito, sesión, registro de sueño o dieta.</span>
        </div>
        <label class="switch">
          <input type="checkbox" v-model="ui.confirmDelete" @change="saveUiPrefs" />
          <span class="slider"></span>
        </label>
      </div>

      <div class="toggle-row">
        <div class="toggle-text">
          <strong>Mostrar el menú lateral abierto al entrar</strong>
          <span>Si lo desactivas, el menú aparecerá colapsado al cargar la web (puedes abrirlo con ☰).</span>
        </div>
        <label class="switch">
          <input type="checkbox" v-model="ui.sidebarOpen" @change="saveUiPrefs" />
          <span class="slider"></span>
        </label>
      </div>

      <div class="reset-row">
        <button type="button" class="btn-ghost" @click="resetLocalPrefs">Restablecer preferencias locales</button>
        <p>Borra el tema, la hora de despertar guardada y las preferencias de la app. No afecta a tus datos.</p>
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

    <!-- ===== Privacidad y datos ===== -->
    <section class="card setting-card">
      <header class="card-head">
        <h2>📥 Privacidad y datos</h2>
        <p>Descarga una copia de toda tu información o elimina tu cuenta cuando quieras.</p>
      </header>

      <div class="data-row">
        <div class="data-text">
          <strong>Exportar mis datos</strong>
          <span>Descarga un archivo JSON con tu perfil, hábitos, sueño, sesiones de entrenamiento y dietas personalizadas.</span>
        </div>
        <button type="button" class="btn-primary" @click="exportData" :disabled="exporting">
          {{ exporting ? 'Preparando…' : '⬇ Descargar JSON' }}
        </button>
      </div>

      <div class="danger-zone">
        <div class="data-text">
          <strong class="danger">Eliminar mi cuenta</strong>
          <span>Se borrarán tu cuenta y todos tus datos de forma permanente. Esta acción no se puede deshacer.</span>
        </div>

        <div v-if="!deleteConfirming">
          <button type="button" class="btn-danger" @click="deleteConfirming = true">Eliminar mi cuenta…</button>
        </div>
        <div v-else class="delete-confirm">
          <p>Para confirmar, escribe exactamente <code>ELIMINAR</code> y pulsa el botón:</p>
          <input type="text" v-model="deleteTyped" placeholder="ELIMINAR" />
          <div class="ed-actions">
            <button type="button" class="btn-ghost" @click="cancelDelete">Cancelar</button>
            <button
              type="button"
              class="btn-danger"
              :disabled="deleteTyped !== 'ELIMINAR' || deleting"
              @click="doDelete"
            >
              {{ deleting ? 'Eliminando…' : 'Sí, eliminar para siempre' }}
            </button>
          </div>
          <span v-if="deleteError" class="error">{{ deleteError }}</span>
        </div>
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
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../composables/useAuth'
import { useTheme } from '../composables/useTheme'
import { authService } from '../services/authService'
import { prefs } from '../lib/preferences'

const router = useRouter()
const { user, logout, clearSession, fetchCurrentUser } = useAuth()
const { theme, toggle: toggleTheme } = useTheme()

const initial = computed(() => (user.value?.fullName || 'U').trim().charAt(0).toUpperCase())

// ===== Editar nombre =====
const nameForm = reactive({ fullName: user.value?.fullName || '' })
const nameSaving = ref(false)
const nameError = ref('')
const nameSavedMsg = ref('')
const nameCanSubmit = computed(() =>
  nameForm.fullName.trim().length > 0
  && nameForm.fullName.trim() !== (user.value?.fullName || '').trim()
)

onMounted(() => {
  if (user.value?.fullName) nameForm.fullName = user.value.fullName
})

const saveName = async () => {
  nameError.value = ''
  nameSavedMsg.value = ''
  nameSaving.value = true
  try {
    await authService.updateMe({ fullName: nameForm.fullName.trim() })
    // Recarga el user reactivo desde el backend para que sidebar/avatar/storage se actualicen
    await fetchCurrentUser()
    nameSavedMsg.value = '✓ Nombre actualizado'
    setTimeout(() => (nameSavedMsg.value = ''), 3000)
  } catch (e) {
    const data = e?.response?.data
    nameError.value = data?.message
      || (data?.fieldErrors && Object.values(data.fieldErrors).flat().join(' · '))
      || 'No se pudo actualizar'
  } finally {
    nameSaving.value = false
  }
}

// ===== Tema =====
const setTheme = (t) => { if (theme.value !== t) toggleTheme() }

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

// ===== Preferencias UI =====
const ui = reactive({
  confirmDelete: prefs.getConfirmDelete(),
  sidebarOpen: prefs.getSidebarOpenDefault(),
})
const saveUiPrefs = () => {
  prefs.setConfirmDelete(ui.confirmDelete)
  prefs.setSidebarOpenDefault(ui.sidebarOpen)
}
const resetLocalPrefs = () => {
  if (!confirm('Esto borrará tema, hora de despertar y preferencias locales. ¿Continuar?')) return
  prefs.resetAll()
  ui.confirmDelete = true
  ui.sidebarOpen = true
  // Forzamos un refresh suave para reaplicar tema por defecto
  window.location.reload()
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

// ===== Exportar mis datos =====
const exporting = ref(false)
const exportData = async () => {
  exporting.value = true
  try {
    const res = await authService.exportMyData()
    const blob = new Blob([res.data], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    // Intenta usar el filename del header; si no, usa uno por defecto con la fecha
    const disp = res.headers?.['content-disposition'] || ''
    const match = disp.match(/filename="?([^"]+)"?/)
    a.download = match?.[1] || `zenfit-export-${new Date().toISOString().slice(0, 10)}.json`
    document.body.appendChild(a)
    a.click()
    a.remove()
    URL.revokeObjectURL(url)
  } catch (e) {
    alert(e?.response?.data?.message || 'No se pudo descargar el archivo')
  } finally {
    exporting.value = false
  }
}

// ===== Eliminar cuenta =====
const deleteConfirming = ref(false)
const deleteTyped = ref('')
const deleting = ref(false)
const deleteError = ref('')

const cancelDelete = () => {
  deleteConfirming.value = false
  deleteTyped.value = ''
  deleteError.value = ''
}

const doDelete = async () => {
  if (deleteTyped.value !== 'ELIMINAR') return
  deleting.value = true
  deleteError.value = ''
  try {
    await authService.deleteMe()
    // Limpiamos sesión local sin llamar a /auth/logout (el user ya no existe).
    clearSession()
    router.push('/')
  } catch (e) {
    deleteError.value = e?.response?.data?.message || 'No se pudo eliminar la cuenta'
  } finally {
    deleting.value = false
  }
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

/* Forms */
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

.btn-ghost {
  background: transparent; border: 1px solid var(--gray-light); color: var(--dark);
  padding: 11px 22px; border-radius: 10px; font-size: 14px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: border-color 0.2s, color 0.2s;
}
.btn-ghost:hover { border-color: var(--blue-mid); color: var(--blue-mid); }

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

/* Toggles (preferencias UI) */
.toggle-row {
  display: flex; justify-content: space-between; align-items: center; gap: 16px;
  padding: 14px 0; border-bottom: 1px solid var(--gray-light);
}
.toggle-row:last-of-type { border-bottom: none; }
.toggle-text { display: flex; flex-direction: column; gap: 4px; flex: 1; min-width: 0; }
.toggle-text strong { font-size: 14px; font-weight: 600; color: var(--dark); }
.toggle-text span { font-size: 12px; color: var(--gray); line-height: 1.5; }

.switch { position: relative; display: inline-block; width: 46px; height: 26px; flex-shrink: 0; }
.switch input { opacity: 0; width: 0; height: 0; }
.slider {
  position: absolute; cursor: pointer; inset: 0;
  background: var(--gray-light); border-radius: 26px;
  transition: background 0.2s;
}
.slider::before {
  content: ''; position: absolute; height: 20px; width: 20px;
  left: 3px; bottom: 3px; background: #FFFFFF; border-radius: 50%;
  transition: transform 0.2s;
  box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}
.switch input:checked + .slider { background: #1E3A8A; }
.switch input:checked + .slider::before { transform: translateX(20px); }

.reset-row { display: flex; align-items: center; gap: 14px; padding-top: 8px; flex-wrap: wrap; }
.reset-row p { font-size: 12px; color: var(--gray); flex: 1; min-width: 200px; line-height: 1.5; }

/* Privacidad y datos */
.data-row {
  display: flex; justify-content: space-between; align-items: center; gap: 16px;
  padding: 10px 0; border-bottom: 1px solid var(--gray-light); flex-wrap: wrap;
}
.data-text { display: flex; flex-direction: column; gap: 4px; flex: 1; min-width: 240px; }
.data-text strong { font-size: 14px; font-weight: 600; color: var(--dark); }
.data-text span { font-size: 12px; color: var(--gray); line-height: 1.5; }
.data-text strong.danger { color: #DC2626; }

.danger-zone {
  display: flex; justify-content: space-between; align-items: flex-start; gap: 16px;
  padding: 14px 0 4px; flex-wrap: wrap;
}
.delete-confirm {
  display: flex; flex-direction: column; gap: 10px;
  background: rgba(239,68,68,0.06); border: 1px solid rgba(239,68,68,0.25);
  border-radius: 12px; padding: 14px; width: 100%;
}
.delete-confirm p { font-size: 13px; color: var(--dark); }
.delete-confirm code {
  background: rgba(239,68,68,0.15); padding: 1px 6px; border-radius: 4px;
  font-family: monospace; font-weight: 700; color: #DC2626;
}
.delete-confirm input {
  background: var(--white); border: 1px solid var(--gray-light);
  padding: 10px 12px; border-radius: 8px; font-size: 14px;
  font-family: var(--font-body); color: var(--dark); outline: none;
}
.delete-confirm input:focus { border-color: #DC2626; box-shadow: 0 0 0 3px rgba(239,68,68,0.1); }
.ed-actions { display: flex; gap: 10px; }

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
  .data-row { flex-direction: column; align-items: stretch; }
  .data-row > button { width: 100%; }
  .danger-zone { flex-direction: column; align-items: stretch; }
  .ed-actions button { flex: 1; }
}
</style>
