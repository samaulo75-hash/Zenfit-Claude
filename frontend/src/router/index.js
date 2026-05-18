import { createRouter, createWebHistory } from 'vue-router'
import Login from '../views/login.vue'
import Register from '../views/register.vue'
import Dashboard from '../views/dashboard.vue'
import BlogHome from '../views/BlogHome.vue'
import BlogPost from '../views/BlogPost.vue'
import MainLayout from '../layouts/MainLayout.vue'
import { useAuth } from '../composables/useAuth'

const routes = [
  { path: '/', redirect: '/blog' },
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: 'blog', component: BlogHome },
      { path: 'post/:id', component: BlogPost },
      { path: 'dashboard', component: Dashboard, meta: { requiresAuth: true } }
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
