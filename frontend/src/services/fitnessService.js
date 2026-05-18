import { http } from '../lib/http'

export const fitnessService = {
  async exercises() {
    const { data } = await http.get('/exercises')
    return data
  },
  async workouts() {
    const { data } = await http.get('/workouts')
    return data
  },
  async workout(id) {
    const { data } = await http.get(`/workouts/${id}`)
    return data
  },
  async sessions(limit = 20) {
    const { data } = await http.get(`/workout-sessions?limit=${limit}`)
    return data
  },
  async createSession(payload) {
    const { data } = await http.post('/workout-sessions', payload)
    return data
  },
}
