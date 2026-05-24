import { ref } from 'vue'

/**
 * Estado global del servidor para mostrar un banner amigable cuando el backend
 * tarda en responder (escenario clásico: cold start del plan free de Render,
 * que duerme el contenedor tras 15 min sin tráfico y tarda 30-60s en despertar).
 *
 * El cliente Axios marca isWaking = true cuando una petición lleva más de
 * COLD_START_THRESHOLD_MS sin responder, y a false en cuanto llega cualquier
 * respuesta. La SPA pinta el banner según ese flag.
 */
const isWaking = ref(false)
let pendingTimers = 0

/** Llamado por el interceptor antes de cada request HTTP. */
export const onHttpRequestStart = (timeoutMs = 4000) => {
  const timer = setTimeout(() => {
    isWaking.value = true
    pendingTimers--
  }, timeoutMs)
  pendingTimers++
  return () => {
    clearTimeout(timer)
    pendingTimers--
    if (pendingTimers <= 0) isWaking.value = false
  }
}

/** Llamado por el interceptor cuando recibe respuesta (éxito o error). */
export const onHttpResponse = () => {
  // Al volver de cualquier petición consideramos que el server respondió;
  // si quedaran otras peticiones lentas, mantienen el flag activo por su cuenta.
  if (pendingTimers <= 0) isWaking.value = false
}

export const useServerStatus = () => ({ isWaking })

/**
 * Warm-up: golpea /actuator/health al cargar la SPA para que Render despierte
 * el contenedor en paralelo mientras el usuario navega la landing pública.
 * Así, cuando intente login o cargar el dashboard, el backend ya estará vivo.
 */
export const warmUpBackend = async (baseURL) => {
  if (!baseURL) return
  try {
    // Petición ligera, sin auth y con timeout amplio.
    await fetch(`${baseURL}/actuator/health`, { method: 'GET', mode: 'cors' })
  } catch { /* silencioso: el warm-up es best-effort */ }
}
