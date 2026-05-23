/**
 * Preferencias locales de la app, persistidas en localStorage.
 * Centralizamos las claves aquí para que sea trivial añadir nuevas y resetear
 * todas a la vez desde Ajustes.
 */
const KEYS = {
  CONFIRM_DELETE: 'zenfit.confirmDelete',
  SIDEBAR_OPEN: 'zenfit.sidebarOpen',
  SLEEP_WAKE: 'zenfit.sleep.wakeTime',
  THEME: 'zenfit.theme',
}

const readBool = (key, defaultValue) => {
  const raw = localStorage.getItem(key)
  if (raw === null) return defaultValue
  return raw === 'true'
}

export const prefs = {
  // ----- Confirmación al borrar -----
  getConfirmDelete() {
    return readBool(KEYS.CONFIRM_DELETE, true) // por defecto pedimos confirmación
  },
  setConfirmDelete(value) {
    localStorage.setItem(KEYS.CONFIRM_DELETE, String(!!value))
  },

  // ----- Sidebar abierta al iniciar (solo escritorio) -----
  getSidebarOpenDefault() {
    return readBool(KEYS.SIDEBAR_OPEN, true)
  },
  setSidebarOpenDefault(value) {
    localStorage.setItem(KEYS.SIDEBAR_OPEN, String(!!value))
  },

  // ----- Restablecer todas las preferencias locales -----
  resetAll() {
    Object.values(KEYS).forEach((k) => localStorage.removeItem(k))
  },
}

/**
 * Wrapper para confirmaciones destructivas que respeta la preferencia del
 * usuario. Si tiene "pedir confirmación" desactivada, devuelve true sin
 * preguntar; si está activa (por defecto), muestra el confirm() del navegador.
 */
export const confirmDestructive = (message) => {
  if (!prefs.getConfirmDelete()) return true
  return window.confirm(message)
}
