import { ref, watch } from 'vue'

const STORAGE_KEY = 'zenfit.theme'

const initial = () => {
  const saved = localStorage.getItem(STORAGE_KEY)
  if (saved === 'dark' || saved === 'light') return saved
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'
}

const theme = ref(initial())

const apply = (value) => {
  document.documentElement.classList.toggle('dark', value === 'dark')
}

apply(theme.value)
watch(theme, (v) => {
  apply(v)
  localStorage.setItem(STORAGE_KEY, v)
})

export function useTheme() {
  const toggle = () => {
    theme.value = theme.value === 'dark' ? 'light' : 'dark'
  }
  return { theme, toggle }
}
