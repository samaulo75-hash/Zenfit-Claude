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
}
