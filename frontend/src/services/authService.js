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
}
