import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import { onAuthFailure } from './lib/http'
import { useAuth } from './composables/useAuth'
import './composables/useTheme'   // aplica el tema (claro/oscuro) lo antes posible
import './assets/main.css'
import './assets/animations.css'

// Cuando un refresh falla, limpiamos sesión y mandamos a /login
onAuthFailure(() => {
  const { clearSession } = useAuth()
  clearSession()
  if (router.currentRoute.value.path !== '/login') {
    router.push({ path: '/login', query: { redirect: router.currentRoute.value.fullPath } })
  }
})

// Rehidratamos el usuario desde el backend si hay token guardado
const { fetchCurrentUser } = useAuth()
fetchCurrentUser().finally(() => {
  createApp(App)
    .use(router)
    .mount('#app')
})
