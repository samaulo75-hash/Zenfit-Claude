import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/login.vue'
import Register from '../views/register.vue'
import ForgotPasswordView from '../views/ForgotPasswordView.vue'
import ResetPasswordView from '../views/ResetPasswordView.vue'
import Dashboard from '../views/dashboard.vue'
import HomeView from '../views/HomeView.vue'
import BlogHome from '../views/BlogHome.vue'
import BlogPost from '../views/BlogPost.vue'
import ProfileView from '../views/ProfileView.vue'
import HabitsView from '../views/HabitsView.vue'
import SleepView from '../views/SleepView.vue'
import WorkoutsView from '../views/WorkoutsView.vue'
import DietsView from '../views/DietsView.vue'
import MainLayout from '../layouts/MainLayout.vue'
import AppLayout from '../layouts/AppLayout.vue'
import { useAuth } from '../composables/useAuth'

const routes = [
  // Zona pública (barra superior)
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: '', component: HomeView },
      { path: 'blog', component: BlogHome },
      { path: 'blog/:slug', component: BlogPost },
      { path: 'post/:id', redirect: '/blog' }
    ]
  },
  // Zona privada (barra lateral, sin Inicio/Blog)
  {
    path: '/',
    component: AppLayout,
    meta: { requiresAuth: true },
    children: [
      { path: 'dashboard', component: Dashboard },
      { path: 'profile', component: ProfileView },
      { path: 'habits', component: HabitsView },
      { path: 'sleep', component: SleepView },
      { path: 'workouts', component: WorkoutsView },
      { path: 'diets', component: DietsView }
    ]
  },
  { path: '/login', component: Login, meta: { guestOnly: true } },
  { path: '/register', component: Register, meta: { guestOnly: true } },
  { path: '/forgot-password', component: ForgotPasswordView, meta: { guestOnly: true } },
  { path: '/reset-password', component: ResetPasswordView, meta: { guestOnly: true } }
]

const router = createRouter({ history: createWebHistory(), routes })

router.beforeEach((to) => {
  const { isAuthenticated } = useAuth()
  if (to.meta.requiresAuth && !isAuthenticated.value) {
    return { path: '/login', query: { redirect: to.fullPath } }
  }
  if (to.meta.guestOnly && isAuthenticated.value) {
    return { path: '/dashboard' }
  }
  return true
})

export default router
