<template>
  <div class="auth-page">
    <div class="auth-left">
      <div class="auth-brand">
        <img src="@/assets/logo-zen.png" alt="ZenFit" class="auth-brand-img" />
      </div>
      <h1 class="auth-headline">Crea una<br/><span class="yellow">contraseña nueva.</span></h1>
      <p class="auth-sub">Elige una contraseña de al menos 8 caracteres. Mejor si mezclas letras, números y símbolos.</p>
    </div>

    <div class="auth-right">
      <div class="auth-box" v-if="!done">
        <h2>Nueva contraseña</h2>
        <p class="auth-box-sub" v-if="!token">Falta el token de reset en la URL. Vuelve a solicitar el enlace.</p>
        <p class="auth-box-sub" v-else>Introduce tu nueva contraseña y entrarás de nuevo a tu cuenta.</p>

        <div class="form-group" v-if="token">
          <label>Nueva contraseña</label>
          <input type="password" v-model="password1" placeholder="Mínimo 8 caracteres" />
        </div>
        <div class="form-group" v-if="token">
          <label>Repite la contraseña</label>
          <input type="password" v-model="password2" placeholder="Repite tu contraseña" @keyup.enter="submit" />
        </div>

        <button v-if="token" class="submit-btn" @click="submit" :disabled="loading || !canSubmit">
          <span v-if="!loading">Guardar contraseña →</span>
          <span v-else>Guardando…</span>
        </button>

        <router-link to="/forgot-password" class="back-link" v-if="!token">Volver a generar un enlace</router-link>
        <router-link to="/login" class="back-link" v-else>← Volver al inicio de sesión</router-link>

        <div class="error-msg" v-if="error">{{ error }}</div>
      </div>

      <div class="auth-box" v-else>
        <h2>Contraseña actualizada ✅</h2>
        <p class="auth-box-sub">Ya puedes iniciar sesión con la nueva contraseña.</p>
        <button class="submit-btn" @click="goLogin">Ir al login →</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { authService } from '../services/authService'

const route = useRoute()
const router = useRouter()
const token = ref(typeof route.query.token === 'string' ? route.query.token : '')
const password1 = ref('')
const password2 = ref('')
const loading = ref(false)
const error = ref('')
const done = ref(false)

const canSubmit = computed(() =>
  password1.value.length >= 8 && password1.value === password2.value
)

const extractError = (err) => {
  const data = err?.response?.data
  if (data?.message) return data.message
  if (data?.fieldErrors) return Object.values(data.fieldErrors).flat().join(' · ')
  return err?.message || 'No se pudo cambiar la contraseña'
}

const submit = async () => {
  error.value = ''
  if (password1.value.length < 8) {
    error.value = 'La contraseña debe tener al menos 8 caracteres'
    return
  }
  if (password1.value !== password2.value) {
    error.value = 'Las contraseñas no coinciden'
    return
  }
  loading.value = true
  try {
    await authService.resetPassword({ token: token.value, newPassword: password1.value })
    done.value = true
  } catch (err) {
    error.value = extractError(err)
  } finally {
    loading.value = false
  }
}

const goLogin = () => router.push('/login')
</script>

<style scoped>
.auth-page { min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr; }

.auth-left {
  background: linear-gradient(150deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
  padding: 60px;
  display: flex; flex-direction: column; justify-content: center; gap: 28px;
}
.auth-brand { display: inline-flex; width: fit-content; }
.auth-brand-img {
  height: 90px; width: auto; display: block;
  filter: brightness(0) invert(1) drop-shadow(0 6px 16px rgba(0,0,0,0.25));
}
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

.back-link {
  font-size: 13px; color: var(--blue-mid);
  text-align: center; text-decoration: none; font-weight: 600;
}
.back-link:hover { text-decoration: underline; }

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
