import { http } from '../lib/http'

export const dashboardService = {
  async get() {
    const { data } = await http.get('/dashboard')
    return data
  },
}
