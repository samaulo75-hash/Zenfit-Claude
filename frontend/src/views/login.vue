<template>
  <div class="auth-page">
    <div class="auth-left">
      <div class="auth-brand">
        <img src="@/assets/logo.png" alt="ZenFit" class="auth-brand-img" />
      </div>
      <h1 class="auth-headline">Tu cuerpo,<br/><span class="yellow">tu mejor proyecto.</span></h1>
      <p class="auth-sub">Más de 50.000 personas ya mejoran su salud con ZenFit cada día.</p>
      <div class="auth-perks">
        <div class="perk" v-for="p in perks" :key="p">
          <span class="perk-check">✓</span> {{ p }}
        </div>
      </div>
    </div>

    <div class="auth-right">
      <div class="auth-box">
        <h2>Bienvenido de nuevo</h2>
        <p class="auth-box-sub">¿No tienes cuenta? <router-link to="/register">Regístrate gratis →</router-link></p>

        <div class="form-group">
          <label>Correo electrónico</label>
          <input type="email" v-model="email" placeholder="hola@zenfit.app" />
        </div>
        <div class="form-group">
          <label>Contraseña</label>
          <input type="password" v-model="password" placeholder="••••••••" />
        </div>

        <button class="submit-btn" @click="login" :disabled="loading">
          <span v-if="!loading">Entrar →</span>
          <span v-else>Cargando...</span>
        </button>

        <div class="error-msg" v-if="error">{{ error }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../composables/useAuth'

const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')
const router = useRouter()
const { login: doLogin } = useAuth()

const perks = ['Sueño optimizado', 'Dietas personalizadas', 'Entrenamientos adaptados', 'Progreso en tiempo real']

const extractError = (err) => {
  const data = err?.response?.data
  if (data?.message) return data.message
  if (data?.fieldErrors) {
    return Object.values(data.fieldErrors).flat().join(' · ')
  }
  return err?.message || 'No se pudo iniciar sesión'
}

const login = async () => {
  error.value = ''
  loading.value = true
  try {
    await doLogin({ email: email.value, password: password.value })
    router.push('/dashboard')
  } catch (err) {
    error.value = extractError(err)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page {
  min-height: 100vh;
  display: grid;
  grid-template-columns: 1fr 1fr;
}

.auth-left {
  background: linear-gradient(150deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
  padding: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 28px;
}
.auth-brand { display: flex; align-items: center; }
.auth-brand-img {
  height: 110px; width: auto; display: block;
  background: #fff; border-radius: 18px;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.22);
}
.auth-headline {
  font-family: var(--font-display);
  font-size: clamp(40px, 5vw, 64px);
  line-height: 1.05;
  letter-spacing: 1px;
  color: var(--white);
}
.yellow { color: var(--yellow); }
.auth-sub { font-size: 15px; color: rgba(255,255,255,0.65); line-height: 1.6; max-width: 360px; }
.auth-perks { display: flex; flex-direction: column; gap: 12px; }
.perk {
  font-size: 14px;
  color: rgba(255,255,255,0.8);
  display: flex;
  align-items: center;
  gap: 10px;
}
.perk-check {
  width: 22px; height: 22px;
  background: rgba(245,158,11,0.2);
  border: 1px solid rgba(245,158,11,0.5);
  color: var(--yellow);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  flex-shrink: 0;
}

.auth-right {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 40px;
  background: var(--white);
}
.auth-box {
  width: 100%;
  max-width: 380px;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.auth-box h2 { font-size: 28px; font-weight: 700; color: var(--dark); }
.auth-box-sub { font-size: 14px; color: var(--gray); }
.auth-box-sub a { color: var(--blue-mid); font-weight: 600; }

.form-group { display: flex; flex-direction: column; gap: 8px; }
.form-group label { font-size: 13px; font-weight: 500; color: var(--dark); letter-spacing: 0.3px; }
.form-group input {
  background: var(--off-white);
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 13px 16px;
  border-radius: 10px;
  font-size: 15px;
  font-family: var(--font-body);
  outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.form-group input:focus {
  border-color: var(--blue-mid);
  box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}
.form-group input::placeholder { color: var(--gray); opacity: 0.5; }

.submit-btn {
  background: var(--yellow);
  color: var(--dark);
  border: none;
  padding: 14px;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 700;
  font-family: var(--font-body);
  cursor: pointer;
  margin-top: 4px;
  transition: opacity 0.2s, transform 0.2s;
  box-shadow: 0 4px 16px rgba(245,158,11,0.3);
}
.submit-btn:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.submit-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.error-msg {
  background: #FEF2F2;
  border: 1px solid #FECACA;
  color: #DC2626;
  padding: 12px 16px;
  border-radius: 8px;
  font-size: 13px;
}

@media (max-width: 768px) {
  .auth-page { grid-template-columns: 1fr; }
  .auth-left { padding: 40px 24px; gap: 20px; }
  .auth-right { padding: 32px 24px; }
}
</style>
