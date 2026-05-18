import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/login.vue'
import Register from '../views/register.vue'
import Dashboard from '../views/dashboard.vue'
import HomeView from '../views/HomeView.vue'
import BlogHome from '../views/BlogHome.vue'
import BlogPost from '../views/BlogPost.vue'
import ProfileView from '../views/ProfileView.vue'
import HabitsView from '../views/HabitsView.vue'
import SleepView from '../views/SleepView.vue'
import WorkoutsView from '../views/WorkoutsView.vue'
import MainLayout from '../layouts/MainLayout.vue'
import { useAuth } from '../composables/useAuth'

const routes = [
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: '', component: HomeView },
      { path: 'blog', component: BlogHome },
      { path: 'blog/:slug', component: BlogPost },
      { path: 'post/:id', redirect: '/blog' },
      { path: 'dashboard', component: Dashboard, meta: { requiresAuth: true } },
      { path: 'profile', component: ProfileView, meta: { requiresAuth: true } },
      { path: 'habits', component: HabitsView, meta: { requiresAuth: true } },
      { path: 'sleep', component: SleepView, meta: { requiresAuth: true } },
      { path: 'workouts', component: WorkoutsView, meta: { requiresAuth: true } }
    ]
  },
  { path: '/login', component: Login, meta: { guestOnly: true } },
  { path: '/register', component: Register, meta: { guestOnly: true } }
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
