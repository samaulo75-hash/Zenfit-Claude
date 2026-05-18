import { computed, reactive } from 'vue'
import { authService } from '../services/authService'
import { storage } from '../lib/storage'

// Estado global reactivo (módulo singleton)
const state = reactive({
  user: storage.getUser(),
  initializing: false,
})

const setSession = ({ accessToken, refreshToken, user }) => {
  storage.setSession({ accessToken, refreshToken, user })
  state.user = user
}

const clearSession = () => {
  storage.clear()
  state.user = null
}

export const useAuth = () => {
  const isAuthenticated = computed(() => !!state.user && !!storage.getAccessToken())
  const user = computed(() => state.user)

  const register = async ({ email, password, fullName }) => {
    const data = await authService.register({ email, password, fullName })
    setSession(data)
    return data
  }

  const login = async ({ email, password }) => {
    const data = await authService.login({ email, password })
    setSession(data)
    return data
  }

  const logout = async () => {
    const refreshToken = storage.getRefreshToken()
    if (refreshToken) await authService.logout(refreshToken)
    clearSession()
  }

  // Rehidratar el usuario desde el backend (útil tras refresh de página)
  const fetchCurrentUser = async () => {
    if (!storage.getAccessToken()) return null
    try {
      state.initializing = true
      const me = await authService.me()
      state.user = me
      storage.setSession({ user: me })
      return me
    } catch {
      clearSession()
      return null
    } finally {
      state.initializing = false
    }
  }

  return {
    user,
    isAuthenticated,
    register,
    login,
    logout,
    fetchCurrentUser,
    clearSession,
  }
}
