<template>
  <div class="dash">
    <!-- Header -->
    <div class="dash-header">
      <div>
        <p class="dash-label">Panel de control</p>
        <h1 class="dash-title">Bienvenido, <span class="accent">{{ firstName }}</span> 👋</h1>
        <p class="dash-sub">{{ today }} · Aquí está tu resumen del día</p>
      </div>
      <div class="dash-streak">
        <span class="streak-fire">🔥</span>
        <span class="streak-num">7</span>
        <span class="streak-lab">días seguidos</span>
      </div>
    </div>

    <!-- Stats row -->
    <div class="stats-row">
      <StatCard title="Calorías" value="1.840" unit="kcal" subtitle="Objetivo: 2.100 kcal" icon="🔥" progress="87" />
      <StatCard title="Sueño" value="7h 20'" unit="" subtitle="Recomendado: 8h" icon="🌙" progress="92" />
      <StatCard title="Pasos" value="8.200" unit="pasos" subtitle="Objetivo: 10.000" icon="👟" progress="82" />
      <StatCard title="Hidratación" value="1.8" unit="L" subtitle="Objetivo: 2.5 L" icon="💧" progress="72" />
    </div>

    <!-- Main grid -->
    <div class="dash-grid">
      <!-- Exercise card -->
      <ExerciseCard
        title="Push Ups"
        time="3:41"
        sets="6 × 10 repeticiones"
        image="./../assets/pushup.png"
      />

      <!-- Weekly chart -->
      <div class="weekly-card">
        <div class="weekly-header">
          <h3>Actividad semanal</h3>
          <span class="weekly-badge">Esta semana</span>
        </div>
        <div class="bars">
          <div class="bar-group" v-for="(day, i) in weekData" :key="i">
            <div class="bar-wrap">
              <div class="bar" :style="{ height: day.val + '%' }" :class="{ today: day.today }"></div>
            </div>
            <span class="bar-label">{{ day.label }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- Next sessions -->
    <div class="sessions-section">
      <h2 class="section-heading">Próximos entrenamientos</h2>
      <div class="sessions-grid">
        <div class="session-card" v-for="s in sessions" :key="s.name">
          <div class="session-icon-wrap" :class="s.type">{{ s.icon }}</div>
          <div class="session-info">
            <span class="session-name">{{ s.name }}</span>
            <span class="session-time">{{ s.time }}</span>
          </div>
          <div class="session-badge" :class="s.type">{{ s.label }}</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import ExerciseCard from './../components/dashboard/exerciseCard.vue'
import StatCard from './../components/dashboard/statCard.vue'
import { useAuth } from '../composables/useAuth'

const { user } = useAuth()
const firstName = computed(() => user.value?.fullName?.split(' ')[0] || 'Usuario')

const today = computed(() => {
  return new Date().toLocaleDateString('es-ES', { weekday: 'long', day: 'numeric', month: 'long' })
})

const weekData = ref([
  { label: 'L', val: 65, today: false },
  { label: 'M', val: 80, today: false },
  { label: 'X', val: 45, today: false },
  { label: 'J', val: 90, today: false },
  { label: 'V', val: 70, today: true },
  { label: 'S', val: 0, today: false },
  { label: 'D', val: 0, today: false },
])

const sessions = ref([
  { icon: '💪', name: 'Fuerza Upper Body', time: 'Hoy · 18:00', label: 'Hoy', type: 'today' },
  { icon: '🏃', name: 'Cardio HIIT', time: 'Mañana · 07:30', label: 'Mañana', type: 'tomorrow' },
  { icon: '🧘', name: 'Yoga & Flexibilidad', time: 'Domingo · 10:00', label: 'Próximo', type: 'next' },
])
</script>

<style scoped>
.dash {
  padding: 100px 48px 60px;
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 32px;
}

.dash-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
}
.dash-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--yellow);
  margin-bottom: 8px;
}
.dash-title {
  font-family: var(--font-display);
  font-size: 44px;
  letter-spacing: 1px;
  color: var(--dark);
  line-height: 1;
  margin-bottom: 8px;
}
.accent { color: var(--blue-mid); }
.dash-sub { font-size: 14px; color: var(--gray); text-transform: capitalize; }

.dash-streak {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: var(--yellow-light);
  border: 1px solid var(--yellow-warm);
  border-radius: 16px;
  padding: 16px 24px;
  gap: 2px;
}
.streak-fire { font-size: 24px; }
.streak-num { font-family: var(--font-display); font-size: 36px; color: var(--yellow); line-height: 1; }
.streak-lab { font-size: 11px; color: #92400E; }

.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
}

.dash-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 20px;
}

/* Weekly chart */
.weekly-card {
  background: var(--white);
  border: 1px solid var(--gray-light);
  border-radius: 20px;
  padding: 28px;
  display: flex;
  flex-direction: column;
  gap: 24px;
  box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.weekly-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.weekly-header h3 { font-size: 16px; font-weight: 600; color: var(--dark); }
.weekly-badge {
  background: var(--blue-light);
  color: var(--blue-mid);
  font-size: 11px;
  font-weight: 600;
  padding: 4px 12px;
  border-radius: 100px;
}
.bars {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  height: 120px;
  gap: 8px;
}
.bar-group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 8px;
  flex: 1;
}
.bar-wrap {
  flex: 1;
  width: 100%;
  display: flex;
  align-items: flex-end;
}
.bar {
  width: 100%;
  background: var(--blue-pale);
  border-radius: 6px 6px 4px 4px;
  min-height: 4px;
  transition: height 0.5s;
}
.bar.today { background: var(--yellow); }
.bar-label { font-size: 11px; color: var(--gray); }

/* Sessions */
.section-heading {
  font-family: var(--font-display);
  font-size: 28px;
  letter-spacing: 1px;
  color: var(--dark);
  margin-bottom: 4px;
}
.sessions-grid {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.session-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: var(--white);
  border: 1px solid var(--gray-light);
  border-radius: 14px;
  padding: 16px 20px;
  transition: box-shadow 0.2s, border-color 0.2s;
  box-shadow: 0 1px 4px rgba(30,58,138,0.04);
}
.session-card:hover { border-color: var(--blue-pale); box-shadow: 0 4px 16px rgba(30,58,138,0.08); }

.session-icon-wrap {
  width: 44px; height: 44px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 22px;
  flex-shrink: 0;
}
.session-icon-wrap.today { background: var(--yellow-light); }
.session-icon-wrap.tomorrow { background: var(--blue-light); }
.session-icon-wrap.next { background: var(--off-white); }

.session-info { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.session-name { font-size: 15px; font-weight: 600; color: var(--dark); }
.session-time { font-size: 12px; color: var(--gray); }
.session-badge {
  font-size: 11px;
  font-weight: 700;
  padding: 4px 12px;
  border-radius: 100px;
  letter-spacing: 0.5px;
}
.session-badge.today { background: var(--yellow-light); color: #92400E; }
.session-badge.tomorrow { background: var(--blue-light); color: var(--blue); }
.session-badge.next { background: var(--off-white); color: var(--gray); border: 1px solid var(--gray-light); }

@media (max-width: 1024px) {
  .stats-row { grid-template-columns: repeat(2, 1fr); }
  .dash-grid { grid-template-columns: 1fr; }
}
@media (max-width: 768px) {
  .dash { padding: 90px 20px 40px; gap: 24px; }
  .dash-header { flex-direction: column; gap: 16px; }
  .dash-streak { flex-direction: row; align-self: stretch; justify-content: center; }
  .stats-row { grid-template-columns: repeat(2, 1fr); gap: 12px; }
  .dash-title { font-size: 32px; }
}
</style>
