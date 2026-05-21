<template>
  <div class="dash">
    <div class="dash-header">
      <div>
        <p class="dash-label">Panel de control</p>
        <h1 class="dash-title">Bienvenido, <span class="accent">{{ firstName }}</span> 👋</h1>
        <p class="dash-sub">{{ today }} · Aquí está tu resumen real</p>
      </div>
      <div class="dash-streak">
        <span class="streak-fire">🔥</span>
        <span class="streak-num">{{ data?.bestHabitStreak ?? 0 }}</span>
        <span class="streak-lab">racha hábitos</span>
      </div>
    </div>

    <div v-if="loading" class="loading">Cargando tu resumen…</div>

    <template v-else>
      <div class="stats-row">
        <StatCard title="Entrenos totales" :value="String(data.totalWorkouts)" unit="" :subtitle="`${data.workoutsThisWeek} esta semana`" icon="🏋" :progress="weekProgress" />
        <StatCard title="Hábitos hoy" :value="`${data.habitsCompletedToday}/${data.habitsTotal}`" unit="" subtitle="completados hoy" icon="✅" :progress="habitProgress" />
        <StatCard title="Mejor racha" :value="String(data.bestHabitStreak)" unit="días" subtitle="hábito más constante" icon="🔥" :progress="Math.min(data.bestHabitStreak * 10, 100)" />
        <StatCard title="Último sueño" :value="lastSleepHours" unit="h" :subtitle="lastSleepQuality" icon="🌙" :progress="sleepProgress" />
      </div>

      <div class="dash-grid">
        <div class="panel">
          <div class="panel-head">
            <h3>Hábitos de hoy</h3>
            <router-link to="/habits" class="panel-link">Gestionar →</router-link>
          </div>
          <div v-if="data.habits.length === 0" class="panel-empty">
            No tienes hábitos. <router-link to="/habits">Crea el primero →</router-link>
          </div>
          <div v-else class="habit-mini-list">
            <div v-for="h in data.habits" :key="h.id" class="habit-mini">
              <span class="hm-check" :class="{ done: h.completedToday }">{{ h.completedToday ? '✓' : '○' }}</span>
              <span class="hm-name">{{ h.icon }} {{ h.name }}</span>
              <span class="hm-streak">🔥 {{ h.currentStreak }}</span>
            </div>
          </div>
        </div>

        <div class="panel">
          <div class="panel-head">
            <h3>Últimos entrenamientos</h3>
            <router-link to="/workouts" class="panel-link">Entrenar →</router-link>
          </div>
          <div v-if="data.recentSessions.length === 0" class="panel-empty">
            Sin sesiones aún. <router-link to="/workouts">Empieza una →</router-link>
          </div>
          <div v-else class="sess-mini-list">
            <div v-for="s in data.recentSessions" :key="s.id" class="sess-mini">
              <span class="sm-name">{{ s.workoutName }}</span>
              <span class="sm-date">{{ formatDate(s.startedAt) }}</span>
            </div>
          </div>
        </div>
      </div>

      <div class="quick-actions">
        <router-link to="/workouts" class="qa-card">🏋 <span>Entrenar</span></router-link>
        <router-link to="/habits" class="qa-card">✅ <span>Hábitos</span></router-link>
        <router-link to="/sleep" class="qa-card">😴 <span>Registrar sueño</span></router-link>
        <router-link to="/profile" class="qa-card">👤 <span>Mi perfil</span></router-link>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import StatCard from './../components/dashboard/statCard.vue'
import { dashboardService } from '../services/dashboardService'
import { useAuth } from '../composables/useAuth'

const { user } = useAuth()
const data = ref(null)
const loading = ref(true)

const firstName = computed(() =>
  (data.value?.userFullName || user.value?.fullName || 'Usuario').split(' ')[0]
)
const today = computed(() =>
  new Date().toLocaleDateString('es-ES', { weekday: 'long', day: 'numeric', month: 'long' })
)
const weekProgress = computed(() => Math.min((data.value?.workoutsThisWeek || 0) * 20, 100))
const habitProgress = computed(() => {
  const d = data.value
  if (!d || !d.habitsTotal) return 0
  return Math.round((d.habitsCompletedToday / d.habitsTotal) * 100)
})
const lastSleepHours = computed(() => {
  const m = data.value?.lastSleep?.durationMinutes
  return m ? (m / 60).toFixed(1) : '—'
})
const lastSleepQuality = computed(() => {
  const q = data.value?.lastSleep?.quality
  return q ? ['', 'Muy mala', 'Mala', 'Normal', 'Buena', 'Excelente'][q] : 'Sin registro'
})
const sleepProgress = computed(() => {
  const m = data.value?.lastSleep?.durationMinutes
  return m ? Math.min(Math.round((m / 480) * 100), 100) : 0
})

const formatDate = (d) =>
  new Date(d).toLocaleDateString('es-ES', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' })

onMounted(async () => {
  try {
    data.value = await dashboardService.get()
  } finally {
    loading.value = false
  }
})
</script>

<style scoped>
.dash { padding: 40px 48px 60px; max-width: 1200px; margin: 0 auto; display: flex; flex-direction: column; gap: 32px; }
.dash-header { display: flex; justify-content: space-between; align-items: flex-start; }
.dash-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 8px; }
.dash-title { font-family: var(--font-display); font-size: 44px; letter-spacing: 1px; color: var(--dark); line-height: 1; margin-bottom: 8px; }
.accent { color: var(--blue-mid); }
.dash-sub { font-size: 14px; color: var(--gray); text-transform: capitalize; }
.dash-streak { display: flex; flex-direction: column; align-items: center; background: var(--yellow-light); border: 1px solid var(--yellow-warm); border-radius: 16px; padding: 16px 24px; gap: 2px; }
.streak-fire { font-size: 24px; }
.streak-num { font-family: var(--font-display); font-size: 36px; color: var(--yellow); line-height: 1; }
.streak-lab { font-size: 11px; color: #92400E; }
.loading { color: var(--gray); padding: 60px 0; text-align: center; }

.stats-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; }
.dash-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }

.panel { background: var(--white); border: 1px solid var(--gray-light); border-radius: 20px; padding: 28px; box-shadow: 0 2px 8px rgba(30,58,138,0.05); }
.panel-head { display: flex; justify-content: space-between; align-items: center; margin-bottom: 18px; }
.panel-head h3 { font-size: 16px; font-weight: 600; color: var(--dark); }
.panel-link { font-size: 13px; color: var(--blue-mid); font-weight: 600; }
.panel-empty { font-size: 14px; color: var(--gray); padding: 20px 0; text-align: center; }
.panel-empty a { color: var(--blue-mid); font-weight: 600; }

.habit-mini-list, .sess-mini-list { display: flex; flex-direction: column; gap: 10px; }
.habit-mini { display: flex; align-items: center; gap: 12px; padding: 10px 0; border-bottom: 1px solid var(--gray-light); }
.habit-mini:last-child { border-bottom: none; }
.hm-check { width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 13px; color: var(--gray); border: 2px solid var(--gray-light); }
.hm-check.done { background: #059669; border-color: #059669; color: #fff; }
.hm-name { flex: 1; font-size: 14px; color: var(--dark); }
.hm-streak { font-size: 13px; font-weight: 700; color: var(--yellow); }
.sess-mini { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px solid var(--gray-light); }
.sess-mini:last-child { border-bottom: none; }
.sm-name { font-size: 14px; font-weight: 600; color: var(--dark); }
.sm-date { font-size: 13px; color: var(--gray); }

.quick-actions { display: grid; grid-template-columns: repeat(4, 1fr); gap: 16px; }
.qa-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 16px; padding: 24px;
  display: flex; flex-direction: column; align-items: center; gap: 10px; font-size: 28px;
  text-decoration: none; transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
}
.qa-card span { font-size: 14px; font-weight: 600; color: var(--dark); }
.qa-card:hover { border-color: var(--blue-pale); transform: translateY(-2px); box-shadow: 0 6px 20px rgba(30,58,138,0.08); }

@media (max-width: 1024px) {
  .stats-row { grid-template-columns: repeat(2, 1fr); }
  .dash-grid { grid-template-columns: 1fr; }
  .quick-actions { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .dash { padding: 32px 20px 40px; gap: 24px; }
  .dash-header { flex-direction: column; gap: 16px; }
  .dash-title { font-size: 32px; }
}
</style>
