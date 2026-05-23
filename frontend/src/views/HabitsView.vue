<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Constancia</p>
        <h1 class="page-title">Mis hábitos</h1>
        <p class="page-sub">Marca cada día lo que completes y construye tu racha 🔥</p>
      </div>
      <button class="btn-primary" @click="showForm = !showForm">
        {{ showForm ? 'Cancelar' : '+ Nuevo hábito' }}
      </button>
    </header>

    <form v-if="showForm" class="card create-form" @submit.prevent="create">
      <div class="row">
        <input v-model="newHabit.name" placeholder="Nombre (ej. Beber 2L de agua)" required maxlength="150" />
        <input v-model="newHabit.icon" placeholder="Emoji (💧)" maxlength="4" class="icon-input" />
        <input type="color" v-model="newHabit.color" class="color-input" />
        <button class="btn-primary" type="submit" :disabled="creating">
          {{ creating ? '…' : 'Crear' }}
        </button>
      </div>
      <input v-model="newHabit.description" placeholder="Descripción (opcional)" maxlength="1000" />
    </form>

    <div v-if="loading" class="loading">Cargando hábitos…</div>
    <div v-else-if="habits.length === 0" class="empty">
      Aún no tienes hábitos. ¡Crea el primero para empezar a construir constancia!
    </div>

    <div v-else class="habit-list">
      <div v-for="h in habits" :key="h.id" class="habit-card" :style="{ borderLeftColor: h.color || '#F2E638' }">
        <button
          class="check"
          :class="{ done: h.completedToday }"
          @click="toggle(h)"
          :title="h.completedToday ? 'Marcar como no hecho hoy' : 'Marcar como hecho hoy'"
        >
          {{ h.completedToday ? '✓' : '' }}
        </button>
        <div class="habit-main">
          <span class="habit-name">{{ h.icon }} {{ h.name }}</span>
          <span class="habit-desc" v-if="h.description">{{ h.description }}</span>
        </div>
        <div class="habit-stats">
          <span class="streak">🔥 {{ h.currentStreak }}</span>
          <span class="total">{{ h.totalCompletions }} veces</span>
        </div>
        <button class="del" @click="remove(h)" title="Eliminar hábito">🗑</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { habitService } from '../services/habitService'
import { confirmDestructive } from '../lib/preferences'

const habits = ref([])
const loading = ref(true)
const showForm = ref(false)
const creating = ref(false)
const newHabit = reactive({ name: '', description: '', icon: '✅', color: '#F2E638' })

const load = async () => {
  habits.value = await habitService.list()
}

onMounted(async () => {
  try { await load() } finally { loading.value = false }
})

const create = async () => {
  creating.value = true
  try {
    await habitService.create({ ...newHabit })
    Object.assign(newHabit, { name: '', description: '', icon: '✅', color: '#F2E638' })
    showForm.value = false
    await load()
  } finally {
    creating.value = false
  }
}

const toggle = async (h) => {
  const updated = await habitService.toggle(h.id)
  const idx = habits.value.findIndex((x) => x.id === h.id)
  if (idx !== -1) habits.value[idx] = updated
}

const remove = async (h) => {
  if (!confirmDestructive(`¿Eliminar el hábito "${h.name}"?`)) return
  await habitService.remove(h.id)
  await load()
}
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 880px; margin: 0 auto; }
.page-head { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; gap: 16px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }
.loading, .empty { color: var(--gray); padding: 40px 0; text-align: center; }

.card { background: var(--white); border: 1px solid var(--gray-light); border-radius: 16px; padding: 20px; box-shadow: 0 2px 8px rgba(30,58,138,0.05); }
.create-form { display: flex; flex-direction: column; gap: 12px; margin-bottom: 20px; }
.create-form .row { display: flex; gap: 10px; }
.create-form input {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 11px 14px; border-radius: 10px; font-size: 14px; font-family: var(--font-body); outline: none; flex: 1;
}
.create-form input:focus { border-color: var(--blue-mid); }
.icon-input { max-width: 90px; text-align: center; flex: 0 0 auto !important; }
.color-input { max-width: 50px; padding: 4px !important; flex: 0 0 auto !important; cursor: pointer; }

.btn-primary {
  background: var(--yellow); color: #1E3A8A; border: none; padding: 11px 22px; border-radius: 10px;
  font-size: 14px; font-weight: 700; font-family: var(--font-body); cursor: pointer; white-space: nowrap;
  transition: opacity 0.2s, transform 0.2s;
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.habit-list { display: flex; flex-direction: column; gap: 12px; }
.habit-card {
  display: flex; align-items: center; gap: 16px; background: var(--white);
  border: 1px solid var(--gray-light); border-left: 4px solid var(--yellow);
  border-radius: 14px; padding: 16px 20px; box-shadow: 0 1px 4px rgba(30,58,138,0.04);
}
.check {
  width: 40px; height: 40px; border-radius: 50%; border: 2px solid var(--gray-light);
  background: var(--white); cursor: pointer; font-size: 18px; font-weight: 800; color: var(--white);
  flex-shrink: 0; transition: all 0.2s;
}
.check.done { background: #2563EB; border-color: #2563EB; }
.check:hover { border-color: #2563EB; }
.habit-main { flex: 1; display: flex; flex-direction: column; gap: 2px; }
.habit-name { font-size: 15px; font-weight: 600; color: var(--dark); }
.habit-desc { font-size: 12px; color: var(--gray); }
.habit-stats { display: flex; flex-direction: column; align-items: flex-end; gap: 2px; }
.streak { font-size: 15px; font-weight: 700; color: var(--yellow); }
.total { font-size: 11px; color: var(--gray); }
.del { background: none; border: none; cursor: pointer; font-size: 16px; opacity: 0.5; transition: opacity 0.2s; }
.del:hover { opacity: 1; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .page-head { flex-direction: column; }
  .create-form .row { flex-wrap: wrap; }
}
</style>
