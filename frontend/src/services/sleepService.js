import { http } from '../lib/http'

export const sleepService = {
  async list(limit = 30) {
    const { data } = await http.get(`/sleep-logs?limit=${limit}`)
    return data
  },
  async save(payload) {
    const { data } = await http.post('/sleep-logs', payload)
    return data
  },
  async remove(id) {
    await http.delete(`/sleep-logs/${id}`)
  },
}
