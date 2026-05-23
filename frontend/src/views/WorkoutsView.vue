<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Entrenamiento</p>
        <h1 class="page-title">Rutinas</h1>
        <p class="page-sub">Elige una rutina, complétala y regístrala 💪</p>
      </div>
    </header>

    <div v-if="loading" class="loading">Cargando rutinas…</div>

    <div v-else class="workout-grid">
      <div v-for="w in workouts" :key="w.id" class="workout-card">
        <div class="wc-head">
          <span class="wc-type" :class="w.type.toLowerCase()">{{ typeLabel(w.type) }}</span>
          <span class="wc-premium" v-if="w.premium">⭐ Premium</span>
        </div>
        <h3 class="wc-name">{{ w.name }}</h3>
        <p class="wc-desc">{{ w.description }}</p>
        <div class="wc-meta">
          <span>⏱ {{ w.estimatedDurationMinutes }} min</span>
          <span>🎯 {{ difficultyLabel(w.difficulty) }}</span>
          <span>🏋 {{ w.exercises.length }} ejercicios</span>
        </div>
        <ul class="wc-ex">
          <li v-for="ex in w.exercises" :key="ex.exerciseId">
            {{ ex.exerciseName }}
            <span class="ex-detail">
              {{ ex.sets ? ex.sets + '×' : '' }}{{ ex.reps ? ex.reps + ' reps' : (ex.durationSeconds ? ex.durationSeconds + 's' : '') }}
            </span>
          </li>
        </ul>
        <button class="btn-primary" @click="complete(w)" :disabled="savingId === w.id">
          {{ savingId === w.id ? 'Registrando…' : '✓ Marcar como completado' }}
        </button>
      </div>
    </div>

    <section class="history">
      <h2 class="section-title">Historial de sesiones</h2>
      <div v-if="sessions.length === 0" class="empty">Aún no has completado ningún entrenamiento.</div>
      <div v-else class="sess-list">
        <div v-for="s in sessions" :key="s.id" class="sess-card">
          <span class="sess-name">{{ s.workoutName }}</span>
          <span class="sess-date">{{ formatDate(s.startedAt) }}</span>
          <span class="sess-dur" v-if="s.durationSeconds">{{ Math.round(s.durationSeconds / 60) }} min</span>
        </div>
      </div>
    </section>

    <transition name="fade">
      <div v-if="toast" class="toast">{{ toast }}</div>
    </transition>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { fitnessService } from '../services/fitnessService'

const workouts = ref([])
const sessions = ref([])
const loading = ref(true)
const savingId = ref(null)
const toast = ref('')

const loadAll = async () => {
  const [w, s] = await Promise.all([fitnessService.workouts(), fitnessService.sessions()])
  workouts.value = w
  sessions.value = s
}

onMounted(async () => {
  try { await loadAll() } finally { loading.value = false }
})

const complete = async (w) => {
  savingId.value = w.id
  try {
    await fitnessService.createSession({
      workoutId: w.id,
      durationSeconds: (w.estimatedDurationMinutes || 0) * 60,
      caloriesBurned: Math.round((w.estimatedDurationMinutes || 0) * 8),
    })
    toast.value = `¡"${w.name}" registrado! 🎉`
    setTimeout(() => (toast.value = ''), 3000)
    sessions.value = await fitnessService.sessions()
  } finally {
    savingId.value = null
  }
}

const typeLabel = (t) => ({
  STRENGTH: 'Fuerza', CARDIO: 'Cardio', HIIT: 'HIIT', YOGA: 'Yoga',
  MOBILITY: 'Movilidad', STRETCHING: 'Estiramiento', RECOVERY: 'Recuperación',
}[t] || t)
const difficultyLabel = (d) => ({ BEGINNER: 'Principiante', INTERMEDIATE: 'Intermedio', ADVANCED: 'Avanzado' }[d] || d)
const formatDate = (d) => new Date(d).toLocaleDateString('es-ES', { day: 'numeric', month: 'short', hour: '2-digit', minute: '2-digit' })
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 1100px; margin: 0 auto; }
.page-head { margin-bottom: 28px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }
.loading, .empty { color: var(--gray); padding: 30px 0; text-align: center; }

.workout-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 20px; margin-bottom: 48px; }
.workout-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 18px; padding: 24px;
  display: flex; flex-direction: column; gap: 12px; box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.wc-head { display: flex; justify-content: space-between; align-items: center; }
/* Badges con colores hardcodeados (no usan vars que cambian en modo oscuro)
   para que siempre tengan contraste en ambos temas. */
.wc-type {
  font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 100px;
  background: #1E3A8A; color: #FFFFFF; text-transform: uppercase; letter-spacing: 0.5px;
}
.wc-type.hiit, .wc-type.cardio { background: #F2E638; color: #1E3A8A; }
.wc-type.yoga, .wc-type.mobility, .wc-type.stretching, .wc-type.recovery { background: #2563EB; color: #FFFFFF; }
.wc-premium { font-size: 11px; color: var(--yellow); font-weight: 700; }
.wc-name { font-size: 20px; font-weight: 700; color: var(--dark); }
.wc-desc { font-size: 13px; color: var(--gray); }
.wc-meta { display: flex; gap: 14px; font-size: 12px; color: var(--gray); flex-wrap: wrap; }
.wc-ex { list-style: none; display: flex; flex-direction: column; gap: 6px; padding: 12px 0; border-top: 1px solid var(--gray-light); }
.wc-ex li { font-size: 13px; color: var(--dark); display: flex; justify-content: space-between; }
.ex-detail { color: var(--gray); font-size: 12px; }
.btn-primary {
  background: var(--yellow); color: var(--dark); border: none; padding: 12px; border-radius: 10px;
  font-size: 14px; font-weight: 700; cursor: pointer; margin-top: auto;
  transition: opacity 0.2s, transform 0.2s;
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.section-title { font-family: var(--font-display); font-size: 24px; color: var(--dark); margin-bottom: 16px; }
.sess-list { display: flex; flex-direction: column; gap: 10px; }
.sess-card {
  display: flex; align-items: center; gap: 16px; background: var(--white);
  border: 1px solid var(--gray-light); border-radius: 12px; padding: 14px 18px;
}
.sess-name { flex: 1; font-size: 14px; font-weight: 600; color: var(--dark); }
.sess-date { font-size: 13px; color: var(--gray); }
.sess-dur { font-size: 13px; font-weight: 700; color: var(--blue-mid); }

.toast {
  position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%);
  background: var(--dark); color: var(--white); padding: 14px 28px; border-radius: 100px;
  font-size: 14px; font-weight: 600; box-shadow: 0 8px 24px rgba(0,0,0,0.2); z-index: 200;
}
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .workout-grid { grid-template-columns: 1fr; }
}
</style>
