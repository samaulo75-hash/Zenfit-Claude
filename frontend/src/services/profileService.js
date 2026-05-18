import { http } from '../lib/http'

export const profileService = {
  async get() {
    const { data } = await http.get('/users/me/profile')
    return data
  },
  async update(payload) {
    const { data } = await http.put('/users/me/profile', payload)
    return data
  },
}
