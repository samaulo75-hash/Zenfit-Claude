<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Descanso</p>
        <h1 class="page-title">Sueño</h1>
        <p class="page-sub">Calcula tus mejores horas para dormir y anota cómo descansas 😴</p>
      </div>
    </header>

    <!-- ===== Calculadora de sueño (basada en ciclos de 90 min) ===== -->
    <section class="card calc-card">
      <header class="calc-head">
        <div>
          <h2 class="calc-title">⏰ Calculadora de sueño</h2>
          <p class="calc-sub">Los ciclos de sueño duran ~90 min. Despertarte al final de un ciclo es mucho más reparador que a mitad de él.</p>
        </div>
        <div class="mode-toggle">
          <button type="button" :class="{ active: mode === 'wake' }" @click="mode = 'wake'">Quiero despertarme a…</button>
          <button type="button" :class="{ active: mode === 'now' }" @click="mode = 'now'">Voy a dormir ahora</button>
        </div>
      </header>

      <div v-if="mode === 'wake'" class="calc-input-row">
        <label>Hora a la que quiero despertarme</label>
        <input type="time" v-model="wakeTime" />
      </div>
      <div v-else class="calc-input-row">
        <p class="now-info">Si te duermes ahora ({{ nowFormatted }}), considera tardar unos {{ FALL_ASLEEP_MIN }} min en quedarte dormido.</p>
      </div>

      <div class="options">
        <article
          v-for="(opt, idx) in cycleOptions"
          :key="opt.cycles"
          class="option"
          :class="{ recommended: idx === 0 }"
        >
          <div class="opt-rank">
            <span class="opt-medal">{{ ['🥇','🥈','🥉'][idx] }}</span>
            <span class="opt-label" v-if="idx === 0">Mejor opción</span>
          </div>
          <div class="opt-time">{{ opt.time }}</div>
          <div class="opt-meta">
            <span>{{ opt.cycles }} ciclos</span>
            <span class="dot">·</span>
            <span>{{ opt.hoursLabel }} de sueño</span>
          </div>
          <p class="opt-tip">{{ opt.tip }}</p>
        </article>
      </div>
    </section>

    <h2 class="section-title">Registro de sueño</h2>

    <form class="card sleep-form" @submit.prevent="save">
      <div class="grid">
        <div class="field">
          <label>Fecha</label>
          <input type="date" v-model="form.sleepDate" :max="today" required />
        </div>
        <div class="field">
          <label>Horas dormidas</label>
          <input type="number" v-model.number="hours" min="0" max="24" step="0.25" placeholder="7.5" required />
        </div>
        <div class="field">
          <label>Calidad</label>
          <select v-model.number="form.quality">
            <option :value="null">— Sin valorar —</option>
            <option :value="1">😫 Muy mala</option>
            <option :value="2">😕 Mala</option>
            <option :value="3">😐 Normal</option>
            <option :value="4">🙂 Buena</option>
            <option :value="5">😴 Excelente</option>
          </select>
        </div>
      </div>
      <div class="field">
        <label>Notas (opcional)</label>
        <input v-model="form.notes" placeholder="Me desperté varias veces…" maxlength="1000" />
      </div>
      <div class="actions">
        <button class="btn-primary" type="submit" :disabled="saving">
          {{ saving ? 'Guardando…' : 'Guardar registro' }}
        </button>
        <span v-if="msg" class="saved">{{ msg }}</span>
        <span v-if="error" class="error">{{ error }}</span>
      </div>
    </form>

    <h2 class="section-title">Historial</h2>
    <div v-if="loading" class="loading">Cargando…</div>
    <div v-else-if="logs.length === 0" class="empty">Sin registros todavía.</div>
    <div v-else class="log-list">
      <div v-for="l in logs" :key="l.id" class="log-card">
        <div class="log-date">{{ formatDate(l.sleepDate) }}</div>
        <div class="log-dur">{{ (l.durationMinutes / 60).toFixed(1) }} h</div>
        <div class="log-q">{{ qualityEmoji(l.quality) }}</div>
        <div class="log-notes">{{ l.notes || '—' }}</div>
        <button class="del" @click="remove(l)" title="Eliminar">🗑</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { sleepService } from '../services/sleepService'

const today = computed(() => new Date().toISOString().slice(0, 10))
const logs = ref([])
const loading = ref(true)
const saving = ref(false)
const msg = ref('')
const error = ref('')
const hours = ref(7.5)
const form = reactive({ sleepDate: today.value, quality: 3, notes: '' })

// ===== Calculadora de sueño =====
// Modelo: ciclos de 90 min + tiempo medio en quedarse dormido (~14 min).
// La OMS recomienda 7-9 h para adultos -> 5 a 6 ciclos. Mostramos las 3 mejores
// opciones (6, 5 y 4 ciclos) priorizando el rango recomendado.
const SLEEP_CYCLE_MIN = 90
const FALL_ASLEEP_MIN = 14
const PREFERRED_CYCLES = [6, 5, 4] // de mejor a peor en orden recomendado

const mode = ref('wake')              // 'wake' | 'now'
const wakeTime = ref('07:00')         // HH:MM en modo "despertarme a"

const STORAGE_KEY = 'zenfit.sleep.wakeTime'
const savedWake = localStorage.getItem(STORAGE_KEY)
if (savedWake) wakeTime.value = savedWake

const pad2 = (n) => String(n).padStart(2, '0')
const formatHHMM = (d) => `${pad2(d.getHours())}:${pad2(d.getMinutes())}`
const minutesToLabel = (m) => {
  const h = Math.floor(m / 60)
  const r = m % 60
  return r === 0 ? `${h} h` : `${h} h ${r} min`
}

const nowFormatted = computed(() => formatHHMM(new Date()))

const parseHHMM = (str) => {
  const [h, m] = (str || '00:00').split(':').map(Number)
  return { h: h || 0, m: m || 0 }
}

const cycleOptions = computed(() => {
  // Persiste la hora preferida en localStorage cuando se calcula con modo wake
  if (mode.value === 'wake' && wakeTime.value) {
    localStorage.setItem(STORAGE_KEY, wakeTime.value)
  }

  return PREFERRED_CYCLES.map((cycles, idx) => {
    const totalMin = cycles * SLEEP_CYCLE_MIN
    let date
    if (mode.value === 'wake') {
      const { h, m } = parseHHMM(wakeTime.value)
      // Punto de partida: hora deseada de despertar (hoy o mañana, da igual,
      // solo nos importa la hora). Restamos los ciclos + tiempo en dormirse.
      date = new Date()
      date.setHours(h, m, 0, 0)
      date.setMinutes(date.getMinutes() - totalMin - FALL_ASLEEP_MIN)
    } else {
      // Modo "ahora": me duermo ahora, ¿cuándo me despierto?
      date = new Date()
      date.setMinutes(date.getMinutes() + totalMin + FALL_ASLEEP_MIN)
    }
    return {
      cycles,
      time: formatHHMM(date),
      hoursLabel: minutesToLabel(totalMin),
      tip: idx === 0
        ? 'Te despertarás descansado y con energía.'
        : idx === 1
          ? 'Buena opción si te has acostado tarde.'
          : 'Suficiente para una jornada corta, pero no a diario.',
    }
  })
})

const load = async () => { logs.value = await sleepService.list() }

onMounted(async () => {
  try { await load() } finally { loading.value = false }
})

const save = async () => {
  error.value = ''; msg.value = ''; saving.value = true
  try {
    await sleepService.save({
      sleepDate: form.sleepDate,
      durationMinutes: Math.round(hours.value * 60),
      quality: form.quality,
      notes: form.notes,
    })
    msg.value = '✓ Guardado'
    form.notes = ''
    setTimeout(() => (msg.value = ''), 3000)
    await load()
  } catch (e) {
    error.value = e?.response?.data?.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}

const remove = async (l) => {
  if (!confirm('¿Eliminar este registro?')) return
  await sleepService.remove(l.id)
  await load()
}

const formatDate = (d) => new Date(d).toLocaleDateString('es-ES', { weekday: 'short', day: 'numeric', month: 'short' })
const qualityEmoji = (q) => ['—', '😫', '😕', '😐', '🙂', '😴'][q || 0]
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 880px; margin: 0 auto; }
.page-head { margin-bottom: 28px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }
.loading, .empty { color: var(--gray); padding: 30px 0; text-align: center; }

.card { background: var(--white); border: 1px solid var(--gray-light); border-radius: 20px; padding: 28px; box-shadow: 0 2px 8px rgba(30,58,138,0.05); }
.sleep-form { display: flex; flex-direction: column; gap: 18px; margin-bottom: 36px; }
.grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; }
.field { display: flex; flex-direction: column; gap: 7px; }
.field label { font-size: 13px; font-weight: 500; color: var(--dark); }
.field input, .field select {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 12px 14px; border-radius: 10px; font-size: 15px; font-family: var(--font-body); outline: none;
}
.field input:focus, .field select:focus { border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.actions { display: flex; align-items: center; gap: 16px; }
.btn-primary {
  background: var(--yellow); color: #1E3A8A; border: none; padding: 13px 28px; border-radius: 10px;
  font-size: 15px; font-weight: 700; cursor: pointer; box-shadow: 0 4px 16px rgba(242,230,56,0.3);
  transition: opacity 0.2s, transform 0.2s;
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }
.saved { color: #2563EB; font-weight: 600; font-size: 14px; }
.error { color: #DC2626; font-size: 14px; }

/* ===== Calculadora ===== */
.calc-card { margin-bottom: 36px; padding: 28px; }
.calc-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; margin-bottom: 18px; flex-wrap: wrap; }
.calc-title { font-family: var(--font-display); font-size: 22px; letter-spacing: 0.5px; color: var(--dark); margin-bottom: 4px; }
.calc-sub { font-size: 13px; color: var(--gray); max-width: 480px; line-height: 1.5; }
.mode-toggle { display: inline-flex; background: var(--off-white); border: 1px solid var(--gray-light); border-radius: 100px; padding: 4px; }
.mode-toggle button {
  background: transparent; border: none; padding: 8px 16px;
  font-size: 13px; font-weight: 600; color: var(--gray);
  border-radius: 100px; cursor: pointer; font-family: var(--font-body);
  transition: background 0.2s, color 0.2s;
}
.mode-toggle button.active { background: #1E3A8A; color: #FFFFFF; }
.mode-toggle button:hover:not(.active) { color: var(--dark); }

.calc-input-row { display: flex; align-items: center; gap: 14px; margin-bottom: 20px; }
.calc-input-row label { font-size: 13px; font-weight: 600; color: var(--dark); }
.calc-input-row input[type="time"] {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 10px 14px; border-radius: 10px; font-size: 16px; font-weight: 600;
  font-family: var(--font-body); outline: none;
}
.calc-input-row input[type="time"]:focus { border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1); }
.now-info { font-size: 13px; color: var(--gray); line-height: 1.5; }

.options { display: grid; grid-template-columns: repeat(3, 1fr); gap: 14px; }
.option {
  background: var(--off-white); border: 1px solid var(--gray-light);
  border-radius: 14px; padding: 18px; display: flex; flex-direction: column; gap: 6px;
  transition: transform 0.2s, box-shadow 0.2s;
}
.option:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(30,58,138,0.08); }
.option.recommended {
  border-color: #F2E638;
  background: linear-gradient(160deg, rgba(242,230,56,0.08), var(--off-white));
  box-shadow: 0 6px 20px rgba(242,230,56,0.2);
}
.opt-rank { display: flex; align-items: center; gap: 8px; font-size: 12px; font-weight: 700; color: var(--gray); }
.opt-medal { font-size: 18px; }
.opt-label { letter-spacing: 1px; text-transform: uppercase; color: #1E3A8A; }
.option.recommended .opt-label { color: #1E3A8A; }
.opt-time { font-family: var(--font-display); font-size: 38px; letter-spacing: 1px; color: var(--dark); line-height: 1; margin-top: 4px; }
.opt-meta { font-size: 13px; color: var(--blue-mid); font-weight: 600; }
.opt-meta .dot { margin: 0 4px; color: var(--gray); }
.opt-tip { font-size: 12px; color: var(--gray); line-height: 1.5; margin-top: 4px; }

.section-title { font-family: var(--font-display); font-size: 24px; color: var(--dark); margin-bottom: 16px; }
.log-list { display: flex; flex-direction: column; gap: 10px; }
.log-card {
  display: grid; grid-template-columns: 130px 70px 40px 1fr 30px; align-items: center; gap: 12px;
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 12px; padding: 14px 18px;
}
.log-date { font-size: 13px; font-weight: 600; color: var(--dark); text-transform: capitalize; }
.log-dur { font-size: 15px; font-weight: 700; color: var(--blue-mid); }
.log-q { font-size: 18px; }
.log-notes { font-size: 13px; color: var(--gray); overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
.del { background: none; border: none; cursor: pointer; font-size: 15px; opacity: 0.5; }
.del:hover { opacity: 1; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .grid { grid-template-columns: 1fr; }
  .options { grid-template-columns: 1fr; }
  .mode-toggle { width: 100%; }
  .mode-toggle button { flex: 1; }
  .log-card { grid-template-columns: 1fr auto auto; }
  .log-notes { display: none; }
}
</style>
