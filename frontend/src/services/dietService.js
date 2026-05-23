import { http } from '../lib/http'

export const dietService = {
  async list(goal) {
    const query = goal ? `?goal=${goal}` : ''
    const { data } = await http.get(`/diets${query}`)
    return data
  },
  async recommended() {
    const { data } = await http.get('/diets/recommended')
    return data
  },
  async saved() {
    const { data } = await http.get('/diets/saved')
    return data
  },
  async get(id) {
    const { data } = await http.get(`/diets/${id}`)
    return data
  },
  async save(id) {
    await http.post(`/diets/${id}/save`)
  },
  async unsave(id) {
    await http.delete(`/diets/${id}/save`)
  },

  // ===== Catálogo de alimentos =====
  async foods(q) {
    const query = q ? `?q=${encodeURIComponent(q)}` : ''
    const { data } = await http.get(`/foods${query}`)
    return data
  },

  // ===== Dietas personalizadas del usuario =====
  async myDiets() {
    const { data } = await http.get('/diets/mine')
    return data
  },
  async createMyDiet(payload) {
    const { data } = await http.post('/diets/mine', payload)
    return data
  },
  async updateMyDiet(id, payload) {
    const { data } = await http.put(`/diets/mine/${id}`, payload)
    return data
  },
  async deleteMyDiet(id) {
    await http.delete(`/diets/mine/${id}`)
  },
}
