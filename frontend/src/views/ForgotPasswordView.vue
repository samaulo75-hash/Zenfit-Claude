<template>
  <div class="auth-page">
    <div class="auth-left">
      <div class="auth-brand">
        <img src="@/assets/logo-trim.png" alt="ZenFit" class="auth-brand-img" />
      </div>
      <h1 class="auth-headline">¿Olvidaste<br/><span class="yellow">tu contraseña?</span></h1>
      <p class="auth-sub">No pasa nada — te generamos un enlace seguro al momento para que puedas fijar una nueva.</p>
    </div>

    <div class="auth-right">
      <div class="auth-box" v-if="!result">
        <h2>Recuperar acceso</h2>
        <p class="auth-box-sub">Escribe el correo con el que te registraste y te daremos un enlace para fijar nueva contraseña.</p>

        <div class="form-group">
          <label>Correo electrónico</label>
          <input type="email" v-model="email" placeholder="hola@zenfit.app" @keyup.enter="submit" />
        </div>

        <button class="submit-btn" @click="submit" :disabled="loading || !email">
          <span v-if="!loading">Generar enlace →</span>
          <span v-else>Generando…</span>
        </button>

        <router-link to="/login" class="back-link">← Volver al inicio de sesión</router-link>

        <div class="error-msg" v-if="error">{{ error }}</div>
      </div>

      <!-- Resultado: enlace de reset listo (sin email, lo mostramos en pantalla) -->
      <div class="auth-box" v-else>
        <h2>Enlace generado ✅</h2>
        <p class="auth-box-sub">
          En producción te lo enviaríamos por email. Como esta es la versión demo
          del proyecto sin SMTP, te lo mostramos directamente aquí:
        </p>

        <div class="link-box">
          <code>{{ resetUrl }}</code>
        </div>

        <button class="submit-btn" @click="goToReset">Ir a fijar nueva contraseña →</button>
        <button class="ghost-btn" @click="copy">{{ copied ? '¡Copiado!' : 'Copiar enlace' }}</button>

        <p class="expires">El enlace expira en 30 minutos.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { authService } from '../services/authService'

const router = useRouter()
const email = ref('')
const loading = ref(false)
const error = ref('')
const result = ref(null)
const copied = ref(false)

const resetUrl = computed(() => {
  if (!result.value) return ''
  return `${window.location.origin}/reset-password?token=${encodeURIComponent(result.value.token)}`
})

const extractError = (err) => {
  const data = err?.response?.data
  if (data?.message) return data.message
  if (data?.fieldErrors) return Object.values(data.fieldErrors).flat().join(' · ')
  return err?.message || 'No se pudo generar el enlace'
}

const submit = async () => {
  error.value = ''
  loading.value = true
  try {
    result.value = await authService.forgotPassword(email.value.trim())
  } catch (err) {
    error.value = extractError(err)
  } finally {
    loading.value = false
  }
}

const goToReset = () => {
  router.push({ path: '/reset-password', query: { token: result.value.token } })
}

const copy = async () => {
  try {
    await navigator.clipboard.writeText(resetUrl.value)
    copied.value = true
    setTimeout(() => (copied.value = false), 1500)
  } catch { /* no-op */ }
}
</script>

<style scoped>
.auth-page { min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr; }

.auth-left {
  background: linear-gradient(150deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
  padding: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 28px;
}
.auth-brand {
  display: inline-flex; width: fit-content;
  background: #fff; padding: 16px; border-radius: 18px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.22);
}
.auth-brand-img { height: 72px; width: auto; display: block; }
.auth-headline {
  font-family: var(--font-display);
  font-size: clamp(40px, 5vw, 64px);
  line-height: 1.05; letter-spacing: 1px; color: var(--white);
}
.yellow { color: var(--yellow); }
.auth-sub { font-size: 15px; color: rgba(255,255,255,0.7); line-height: 1.6; max-width: 360px; }

.auth-right {
  display: flex; align-items: center; justify-content: center;
  padding: 40px; background: var(--white);
}
.auth-box {
  width: 100%; max-width: 420px;
  display: flex; flex-direction: column; gap: 18px;
}
.auth-box h2 { font-size: 28px; font-weight: 700; color: var(--dark); }
.auth-box-sub { font-size: 14px; color: var(--gray); line-height: 1.6; }

.form-group { display: flex; flex-direction: column; gap: 8px; }
.form-group label { font-size: 13px; font-weight: 500; color: var(--dark); }
.form-group input {
  background: var(--off-white);
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 13px 16px; border-radius: 10px;
  font-size: 15px; font-family: var(--font-body);
  outline: none; transition: border-color 0.2s, box-shadow 0.2s;
}
.form-group input:focus {
  border-color: var(--blue-mid);
  box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}

.submit-btn {
  background: var(--yellow); color: #1E3A8A; border: none;
  padding: 14px; border-radius: 10px;
  font-size: 15px; font-weight: 700; font-family: var(--font-body);
  cursor: pointer; transition: opacity 0.2s, transform 0.2s;
  box-shadow: 0 4px 16px rgba(242,230,56,0.3);
}
.submit-btn:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.submit-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.ghost-btn {
  background: transparent;
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 12px; border-radius: 10px;
  font-size: 14px; font-weight: 600; font-family: var(--font-body);
  cursor: pointer; transition: border-color 0.2s, color 0.2s;
}
.ghost-btn:hover { border-color: var(--blue-mid); color: var(--blue-mid); }

.back-link {
  font-size: 13px; color: var(--blue-mid);
  text-align: center; text-decoration: none; font-weight: 600;
}
.back-link:hover { text-decoration: underline; }

.link-box {
  background: var(--off-white);
  border: 1px solid var(--gray-light);
  border-radius: 10px;
  padding: 12px 14px;
  word-break: break-all;
  font-size: 12px;
  color: var(--dark);
  font-family: monospace;
}

.expires { font-size: 12px; color: var(--gray); text-align: center; margin-top: 4px; }

.error-msg {
  background: #FEF2F2;
  border: 1px solid #FECACA;
  color: #DC2626;
  padding: 12px 16px; border-radius: 8px; font-size: 13px;
}

@media (max-width: 768px) {
  .auth-page { grid-template-columns: 1fr; }
  .auth-left { padding: 40px 24px; gap: 20px; }
  .auth-right { padding: 32px 24px; }
}
</style>
