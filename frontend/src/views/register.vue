<template>
  <div class="auth-page">
    <AuthBackButton />
    <div class="auth-left">
      <div class="auth-brand">
        <img src="@/assets/logo-trim.png" alt="ZenFit" class="auth-brand-img" />
      </div>
      <h1 class="auth-headline">Empieza hoy.<br/><span class="yellow">Sin excusas.</span></h1>
      <p class="auth-sub">Crea tu cuenta y accede a planes de sueño, nutrición y entrenamiento totalmente personalizados.</p>
      <div class="auth-perks">
        <div class="perk" v-for="p in perks" :key="p">
          <span class="perk-check">✓</span> {{ p }}
        </div>
      </div>
    </div>

    <div class="auth-right">
      <div class="auth-box">
        <h2>Crear cuenta gratis</h2>
        <p class="auth-box-sub">¿Ya tienes cuenta? <router-link to="/login">Inicia sesión →</router-link></p>

        <div class="form-group">
          <label>Nombre completo</label>
          <input type="text" v-model="nombre" placeholder="Tu nombre" />
        </div>
        <div class="form-group">
          <label>Correo electrónico</label>
          <input type="email" v-model="email" placeholder="hola@zenfit.app" />
        </div>
        <div class="form-group">
          <label>Contraseña</label>
          <input type="password" v-model="password" placeholder="Mínimo 8 caracteres" />
        </div>

        <button class="submit-btn" @click="register" :disabled="loading">
          <span v-if="!loading">Crear cuenta gratis →</span>
          <span v-else>Registrando...</span>
        </button>

        <p class="terms">Al registrarte aceptas nuestros <a href="#">Términos</a> y <a href="#">Política de privacidad</a>.</p>
        <div class="error-msg" v-if="error">{{ error }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuth } from '../composables/useAuth'
import AuthBackButton from '../components/auth/AuthBackButton.vue'

const nombre = ref('')
const email = ref('')
const password = ref('')
const loading = ref(false)
const error = ref('')
const router = useRouter()
const { register: doRegister } = useAuth()

const perks = ['Sin tarjeta de crédito', '60 días de prueba gratuita', 'Cancela cuando quieras', 'Soporte prioritario']

const extractError = (err) => {
  const data = err?.response?.data
  if (data?.message) {
    if (data.fieldErrors) {
      const fields = Object.values(data.fieldErrors).flat().join(' · ')
      return `${data.message}: ${fields}`
    }
    return data.message
  }
  return err?.message || 'No se pudo completar el registro'
}

const register = async () => {
  error.value = ''
  loading.value = true
  try {
    await doRegister({ email: email.value, password: password.value, fullName: nombre.value })
    router.push('/dashboard')
  } catch (err) {
    error.value = extractError(err)
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.auth-page { position: relative; min-height: 100vh; display: grid; grid-template-columns: 1fr 1fr; }

.auth-left {
  background: linear-gradient(150deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
  padding: 60px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 24px;
}
.auth-brand {
  display: inline-flex;
  width: fit-content;
}
.auth-brand-img {
  height: 90px;
  width: auto;
  display: block;
  filter: brightness(0) invert(1) drop-shadow(0 6px 16px rgba(0,0,0,0.25));
}

.offer-badge {
  display: inline-block;
  background: rgba(242,230,56,0.2);
  border: 1px solid rgba(242,230,56,0.4);
  color: var(--yellow-warm);
  font-size: 12px;
  font-weight: 800;
  padding: 6px 16px;
  border-radius: 100px;
  width: fit-content;
  letter-spacing: 0.5px;
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
  background: rgba(242,230,56,0.2);
  border: 1px solid rgba(242,230,56,0.5);
  color: var(--yellow);
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 700;
  flex-shrink: 0;
}

.auth-right { display: flex; align-items: center; justify-content: center; padding: 40px; background: var(--white); }
.auth-box { width: 100%; max-width: 380px; display: flex; flex-direction: column; gap: 18px; }
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
  color: #1E3A8A;
  border: none;
  padding: 14px;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 700;
  font-family: var(--font-body);
  cursor: pointer;
  margin-top: 4px;
  transition: opacity 0.2s, transform 0.2s;
  box-shadow: 0 4px 16px rgba(242,230,56,0.3);
}
.submit-btn:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.submit-btn:disabled { opacity: 0.5; cursor: not-allowed; }

.terms { font-size: 11px; color: var(--gray); line-height: 1.5; }
.terms a { color: var(--blue-mid); }
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
  .auth-left { padding: 40px 24px; }
  .auth-right { padding: 32px 24px; }
}
</style>
