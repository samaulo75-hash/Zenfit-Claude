<template>
  <div class="player">
    <!-- ===== Top bar ===== -->
    <header class="player-head">
      <div class="head-left">
        <p class="head-label">Entrenamiento</p>
        <h2 class="head-title">{{ workout.name }}</h2>
      </div>
      <div class="head-right">
        <div class="total-timer" :title="'Tiempo total de la sesión'">
          ⏱ {{ formatTime(totalElapsed) }}
        </div>
        <button class="close-btn" @click="confirmExit" :title="'Salir'">✕</button>
      </div>
    </header>

    <!-- Barra de progreso global -->
    <div class="global-progress">
      <div class="bar" :style="{ width: globalProgress + '%' }"></div>
    </div>

    <!-- ===== Cuerpo ===== -->
    <div v-if="state === 'done'" class="screen done-screen">
      <h1 class="big">🎉 ¡Sesión completada!</h1>
      <div class="summary-grid">
        <div class="summary-item">
          <span class="s-label">Tiempo total</span>
          <span class="s-value">{{ formatTime(totalElapsed) }}</span>
        </div>
        <div class="summary-item">
          <span class="s-label">Ejercicios</span>
          <span class="s-value">{{ workout.exercises.length }} / {{ workout.exercises.length }}</span>
        </div>
        <div class="summary-item">
          <span class="s-label">Series totales</span>
          <span class="s-value">{{ totalSetsDone }}</span>
        </div>
        <div class="summary-item">
          <span class="s-label">Kcal estimadas</span>
          <span class="s-value">{{ estimatedKcal }}</span>
        </div>
      </div>
      <div class="done-actions">
        <button class="btn-primary big-btn" @click="saveSession" :disabled="saving">
          {{ saving ? 'Guardando…' : '✓ Guardar sesión' }}
        </button>
        <button class="btn-ghost big-btn" @click="$emit('close')">Salir sin guardar</button>
      </div>
      <p v-if="saveError" class="error">{{ saveError }}</p>
    </div>

    <div v-else class="screen">
      <!-- Sub-progress: ejercicio actual / total -->
      <p class="sub-progress">Ejercicio {{ currentExerciseIdx + 1 }} de {{ workout.exercises.length }}</p>

      <!-- Modo "rest" -->
      <div v-if="state === 'rest'" class="rest-screen">
        <p class="big-label">Descanso</p>
        <div class="big-timer rest">{{ formatTime(timerRemaining) }}</div>
        <p class="rest-next">
          Próximo:
          <strong>{{ currentExercise.exerciseName }}</strong>
          · Serie {{ currentSetIdx + 1 }} de {{ currentExercise.sets || 1 }}
        </p>
        <button class="btn-ghost big-btn" @click="skipRest">⏭ Saltar descanso</button>
      </div>

      <!-- Modo "work" -->
      <div v-else-if="state === 'work'" class="work-screen">
        <p class="big-label">{{ currentExercise.exerciseName }}</p>
        <p class="set-label">Serie {{ currentSetIdx + 1 }} de {{ currentExercise.sets || 1 }}</p>

        <!-- Ejercicio por DURACIÓN -->
        <div v-if="currentExercise.durationSeconds">
          <div class="big-timer work">{{ formatTime(timerRemaining) }}</div>
          <p class="hint">Mantén la posición / haz el ejercicio hasta que llegue a 0</p>
        </div>

        <!-- Ejercicio por REPETICIONES -->
        <div v-else>
          <div class="reps-display">
            <span class="reps-number">{{ currentExercise.reps || '—' }}</span>
            <span class="reps-unit">reps</span>
          </div>
          <p class="hint">Cuando termines la serie, pulsa "Serie completada"</p>
          <button class="btn-primary big-btn" @click="completeSet">✓ Serie completada</button>
        </div>

        <p v-if="currentExercise.notes" class="notes">💡 {{ currentExercise.notes }}</p>
      </div>
    </div>

    <!-- ===== Bottom controls (solo durante work/rest) ===== -->
    <footer v-if="state !== 'done'" class="player-controls">
      <button class="ctrl-btn" @click="togglePause" :title="paused ? 'Reanudar' : 'Pausar'">
        {{ paused ? '▶' : '⏸' }}
      </button>
      <button class="ctrl-btn" @click="skipExercise" :title="'Saltar ejercicio'">⏭</button>
    </footer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { fitnessService } from '../../services/fitnessService'

const props = defineProps({
  workout: { type: Object, required: true },
})
const emit = defineEmits(['close', 'saved'])

const REST_FALLBACK = 30 // segundos si el ejercicio no define restSeconds

// ===== Estado de la sesión =====
const state = ref('work')           // 'work' | 'rest' | 'done'
const currentExerciseIdx = ref(0)
const currentSetIdx = ref(0)        // 0-based dentro del ejercicio actual
const timerRemaining = ref(0)
const totalElapsed = ref(0)
const paused = ref(false)
const totalSetsDone = ref(0)

const currentExercise = computed(() => props.workout.exercises[currentExerciseIdx.value])

const totalSetsPlanned = computed(() =>
  props.workout.exercises.reduce((acc, ex) => acc + (ex.sets || 1), 0)
)

const globalProgress = computed(() => {
  if (state.value === 'done') return 100
  if (!totalSetsPlanned.value) return 0
  return Math.min(99, Math.round((totalSetsDone.value / totalSetsPlanned.value) * 100))
})

const estimatedKcal = computed(() =>
  Math.round((totalElapsed.value / 60) * 8) // 8 kcal/min aprox., igual que la versión simple
)

// ===== Loop de tiempo =====
let intervalId = null

const tick = () => {
  if (paused.value || state.value === 'done') return
  totalElapsed.value++

  if (state.value === 'work' && currentExercise.value.durationSeconds) {
    if (timerRemaining.value > 0) {
      timerRemaining.value--
      if (timerRemaining.value === 0) {
        // Auto-completa la serie cuando llega a 0 (ejercicio por duración)
        beep()
        completeSet()
      }
    }
  } else if (state.value === 'rest') {
    if (timerRemaining.value > 0) {
      timerRemaining.value--
      if (timerRemaining.value === 0) {
        beep()
        startWork()
      }
    }
  }
}

// ===== Audio cue (sintetizado, sin assets externos) =====
let audioCtx = null
const beep = () => {
  try {
    audioCtx ||= new (window.AudioContext || window.webkitAudioContext)()
    const osc = audioCtx.createOscillator()
    const gain = audioCtx.createGain()
    osc.connect(gain)
    gain.connect(audioCtx.destination)
    osc.frequency.value = 880
    gain.gain.value = 0.18
    osc.start()
    gain.gain.exponentialRampToValueAtTime(0.0001, audioCtx.currentTime + 0.25)
    osc.stop(audioCtx.currentTime + 0.25)
  } catch { /* AudioContext puede no estar disponible — fallamos silenciosamente */ }
}

// ===== Transiciones de estado =====
const startWork = () => {
  state.value = 'work'
  if (currentExercise.value.durationSeconds) {
    timerRemaining.value = currentExercise.value.durationSeconds
  } else {
    timerRemaining.value = 0
  }
}

const startRest = () => {
  state.value = 'rest'
  timerRemaining.value = currentExercise.value.restSeconds || REST_FALLBACK
}

const completeSet = () => {
  totalSetsDone.value++
  const sets = currentExercise.value.sets || 1
  if (currentSetIdx.value + 1 < sets) {
    // Quedan más series del mismo ejercicio → descanso
    currentSetIdx.value++
    startRest()
  } else {
    // Pasar al siguiente ejercicio
    if (currentExerciseIdx.value + 1 < props.workout.exercises.length) {
      currentExerciseIdx.value++
      currentSetIdx.value = 0
      startRest()
    } else {
      state.value = 'done'
    }
  }
}

const skipExercise = () => {
  // Marca las series restantes del ejercicio actual como "no hechas" y pasa al siguiente
  if (currentExerciseIdx.value + 1 < props.workout.exercises.length) {
    currentExerciseIdx.value++
    currentSetIdx.value = 0
    startWork()
  } else {
    state.value = 'done'
  }
}

const skipRest = () => { startWork() }

const togglePause = () => { paused.value = !paused.value }

const confirmExit = () => {
  if (state.value === 'done') { emit('close'); return }
  if (confirm('¿Salir del entrenamiento? Se perderá el progreso de esta sesión.')) {
    emit('close')
  }
}

// ===== Guardar sesión =====
const saving = ref(false)
const saveError = ref('')
const saveSession = async () => {
  saving.value = true
  saveError.value = ''
  try {
    await fitnessService.createSession({
      workoutId: props.workout.id,
      durationSeconds: totalElapsed.value,
      caloriesBurned: estimatedKcal.value,
    })
    emit('saved')
    emit('close')
  } catch (e) {
    saveError.value = e?.response?.data?.message || 'No se pudo guardar la sesión'
  } finally {
    saving.value = false
  }
}

// ===== Formato =====
const formatTime = (sec) => {
  const s = Math.max(0, Math.floor(sec))
  const m = Math.floor(s / 60)
  const r = s % 60
  return `${String(m).padStart(2, '0')}:${String(r).padStart(2, '0')}`
}

// ===== Lifecycle =====
onMounted(() => {
  startWork()
  intervalId = setInterval(tick, 1000)
})
onBeforeUnmount(() => {
  if (intervalId) clearInterval(intervalId)
  if (audioCtx) audioCtx.close().catch(() => {})
})
</script>

<style scoped>
.player {
  position: fixed; inset: 0; z-index: 300;
  background: linear-gradient(180deg, #0F172A 0%, #1E293B 100%);
  color: #FFFFFF;
  display: flex; flex-direction: column;
  font-family: var(--font-body);
}

/* Header */
.player-head {
  display: flex; justify-content: space-between; align-items: flex-start;
  padding: 24px 32px 16px; gap: 14px; flex-wrap: wrap;
}
.head-left { flex: 1; min-width: 0; }
.head-label {
  font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase;
  color: #F2E638; margin-bottom: 4px;
}
.head-title { font-family: var(--font-display); font-size: 26px; letter-spacing: 0.5px; }

.head-right { display: flex; align-items: center; gap: 12px; }
.total-timer {
  background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.15);
  padding: 8px 14px; border-radius: 100px; font-weight: 700; font-size: 14px;
  font-variant-numeric: tabular-nums;
}
.close-btn {
  background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.18);
  color: #FFFFFF; width: 38px; height: 38px; border-radius: 50%; cursor: pointer;
  font-size: 16px; display: flex; align-items: center; justify-content: center;
  transition: background 0.2s, border-color 0.2s;
}
.close-btn:hover { background: rgba(239,68,68,0.2); border-color: rgba(239,68,68,0.5); }

/* Barra de progreso global */
.global-progress {
  height: 4px; background: rgba(255,255,255,0.08); margin: 0 32px;
  border-radius: 100px; overflow: hidden;
}
.bar {
  height: 100%; background: linear-gradient(90deg, #F2E638, #FCD34D);
  transition: width 0.4s ease;
}

/* Pantalla central */
.screen {
  flex: 1; display: flex; flex-direction: column; align-items: center; justify-content: center;
  padding: 24px 32px; text-align: center; gap: 16px;
}
.sub-progress {
  font-size: 12px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase;
  color: rgba(255,255,255,0.55); margin-bottom: 8px;
}

.big-label {
  font-family: var(--font-display); font-size: clamp(36px, 6vw, 64px);
  letter-spacing: 1px; color: #FFFFFF; line-height: 1.1;
}
.set-label { font-size: 16px; color: rgba(255,255,255,0.7); margin-bottom: 12px; }

.big-timer {
  font-family: var(--font-display); font-size: clamp(80px, 18vw, 160px);
  letter-spacing: 2px; line-height: 1; font-variant-numeric: tabular-nums;
  margin: 16px 0;
}
.big-timer.work { color: #F2E638; }
.big-timer.rest { color: #60A5FA; }

.reps-display { display: flex; align-items: baseline; justify-content: center; gap: 14px; margin: 16px 0; }
.reps-number {
  font-family: var(--font-display); font-size: clamp(80px, 18vw, 160px);
  color: #F2E638; line-height: 1;
}
.reps-unit { font-size: 22px; font-weight: 600; color: rgba(255,255,255,0.7); }

.hint { font-size: 14px; color: rgba(255,255,255,0.6); max-width: 480px; line-height: 1.5; }
.notes {
  background: rgba(242,230,56,0.08); border: 1px solid rgba(242,230,56,0.25);
  padding: 10px 18px; border-radius: 12px; font-size: 13px; color: rgba(255,255,255,0.85);
  max-width: 520px; line-height: 1.5;
}

.rest-screen, .work-screen { display: flex; flex-direction: column; align-items: center; gap: 14px; }
.rest-next { font-size: 14px; color: rgba(255,255,255,0.7); }
.rest-next strong { color: #FFFFFF; }

/* Botones */
.btn-primary {
  background: #F2E638; color: #1E3A8A; border: none;
  padding: 14px 32px; border-radius: 12px; font-size: 15px; font-weight: 700;
  font-family: var(--font-body); cursor: pointer; transition: opacity 0.2s, transform 0.2s;
  box-shadow: 0 6px 22px rgba(242,230,56,0.35);
}
.btn-primary:hover:not(:disabled) { opacity: 0.92; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-ghost {
  background: transparent; border: 1px solid rgba(255,255,255,0.25); color: #FFFFFF;
  padding: 12px 26px; border-radius: 12px; font-size: 14px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: border-color 0.2s, background 0.2s;
}
.btn-ghost:hover { border-color: rgba(255,255,255,0.5); background: rgba(255,255,255,0.05); }

.big-btn { margin-top: 8px; }

/* Footer controles */
.player-controls {
  display: flex; justify-content: center; gap: 16px;
  padding: 16px 32px 28px;
}
.ctrl-btn {
  background: rgba(255,255,255,0.08); border: 1px solid rgba(255,255,255,0.2);
  color: #FFFFFF; width: 64px; height: 64px; border-radius: 50%; cursor: pointer;
  font-size: 24px; display: flex; align-items: center; justify-content: center;
  transition: background 0.2s, border-color 0.2s, transform 0.15s;
}
.ctrl-btn:hover { background: rgba(255,255,255,0.16); border-color: rgba(255,255,255,0.4); transform: scale(1.05); }

/* Done screen */
.done-screen .big {
  font-family: var(--font-display); font-size: clamp(36px, 6vw, 56px);
  color: #F2E638; letter-spacing: 1px; margin-bottom: 16px;
}
.summary-grid {
  display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px;
  max-width: 480px; width: 100%; margin: 16px 0 24px;
}
.summary-item {
  background: rgba(255,255,255,0.06); border: 1px solid rgba(255,255,255,0.12);
  border-radius: 14px; padding: 16px; display: flex; flex-direction: column; gap: 4px;
}
.s-label { font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: rgba(255,255,255,0.55); }
.s-value { font-family: var(--font-display); font-size: 26px; letter-spacing: 0.5px; color: #FFFFFF; }
.done-actions { display: flex; flex-direction: column; gap: 12px; width: 100%; max-width: 320px; }
.error { color: #FCA5A5; font-size: 13px; }

@media (max-width: 540px) {
  .player-head { padding: 16px 18px; }
  .screen { padding: 16px 18px; }
  .summary-grid { grid-template-columns: 1fr; }
}
</style>
