import { http } from '../lib/http'

export const authService = {
  async register({ email, password, fullName }) {
    const { data } = await http.post('/auth/register', { email, password, fullName })
    return data
  },

  async login({ email, password }) {
    const { data } = await http.post('/auth/login', { email, password })
    return data
  },

  async logout(refreshToken) {
    try {
      await http.post('/auth/logout', { refreshToken })
    } catch { /* no-op: incluso si falla queremos limpiar local */ }
  },

  async me() {
    const { data } = await http.get('/users/me')
    return data
  },

  async changePassword({ currentPassword, newPassword }) {
    await http.post('/auth/change-password', { currentPassword, newPassword })
  },

  async forgotPassword(email) {
    // Devuelve { token, expiresAt }. En esta version sin SMTP el token llega
    // directo a la UI para que el usuario pueda fijar nueva contrasena.
    const { data } = await http.post('/auth/forgot-password', { email })
    return data
  },

  async resetPassword({ token, newPassword }) {
    await http.post('/auth/reset-password', { token, newPassword })
  },
}
