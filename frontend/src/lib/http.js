import axios from 'axios'
import { storage } from './storage'

const baseURL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080'

export const http = axios.create({
  baseURL,
  headers: { 'Content-Type': 'application/json' },
  // 60s: el plan Free de Render "duerme" el backend tras 15 min de inactividad
  // y el arranque en frío puede tardar 30-60s en la primera petición.
  timeout: 60000,
})

// Adjunta Bearer token automáticamente
http.interceptors.request.use((config) => {
  const token = storage.getAccessToken()
  if (token && !config.headers.Authorization) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Refresh automático en 401 (single-flight: una sola request de refresh en paralelo)
let refreshPromise = null
let onAuthFailureCallback = null

export const onAuthFailure = (cb) => { onAuthFailureCallback = cb }

const refreshSession = async () => {
  const refreshToken = storage.getRefreshToken()
  if (!refreshToken) throw new Error('No refresh token')
  // Usamos axios "puro" para no entrar en bucle con los interceptors
  const { data } = await axios.post(`${baseURL}/auth/refresh`, { refreshToken })
  storage.setSession({
    accessToken: data.accessToken,
    refreshToken: data.refreshToken,
    user: data.user,
  })
  return data.accessToken
}

http.interceptors.response.use(
  (res) => res,
  async (error) => {
    const original = error.config
    const status = error.response?.status

    // No reintentar para endpoints de auth (sus 401 son finales)
    const url = original?.url || ''
    const isAuthEndpoint = url.includes('/auth/login') || url.includes('/auth/register') || url.includes('/auth/refresh')

    if (status === 401 && !original._retry && !isAuthEndpoint) {
      original._retry = true
      try {
        refreshPromise = refreshPromise || refreshSession().finally(() => { refreshPromise = null })
        const newToken = await refreshPromise
        original.headers.Authorization = `Bearer ${newToken}`
        return http(original)
      } catch (refreshErr) {
        storage.clear()
        if (onAuthFailureCallback) onAuthFailureCallback()
        return Promise.reject(refreshErr)
      }
    }
    return Promise.reject(error)
  }
)
