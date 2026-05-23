<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Descanso</p>
        <h1 class="page-title">Registro de sueño</h1>
        <p class="page-sub">Anota cómo duermes para entender tu recuperación 😴</p>
      </div>
    </header>

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
  .log-card { grid-template-columns: 1fr auto auto; }
  .log-notes { display: none; }
}
</style>
