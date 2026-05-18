import { http } from '../lib/http'

export const habitService = {
  async list() {
    const { data } = await http.get('/habits')
    return data
  },
  async create(payload) {
    const { data } = await http.post('/habits', payload)
    return data
  },
  async update(id, payload) {
    const { data } = await http.put(`/habits/${id}`, payload)
    return data
  },
  async remove(id) {
    await http.delete(`/habits/${id}`)
  },
  async toggle(id, date) {
    const query = date ? `?date=${date}` : ''
    const { data } = await http.post(`/habits/${id}/toggle${query}`)
    return data
  },
}
