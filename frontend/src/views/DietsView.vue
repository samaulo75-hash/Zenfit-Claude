<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Nutrición</p>
        <h1 class="page-title">Dietas</h1>
        <p class="page-sub">Planes de alimentación para comer bien según tu objetivo 🥗</p>
      </div>
    </header>

    <div class="filters">
      <button
        class="chip"
        :class="{ active: activeFilter === 'recommended' }"
        @click="loadRecommended"
      >★ Recomendadas para mí</button>
      <button
        v-for="f in filters"
        :key="f.value"
        class="chip"
        :class="{ active: activeFilter === f.value }"
        @click="loadByGoal(f.value)"
      >{{ f.label }}</button>
    </div>

    <div v-if="loading" class="loading">Cargando dietas…</div>
    <div v-else-if="plans.length === 0" class="empty">No hay dietas para este filtro.</div>

    <div v-else class="diet-grid">
      <div v-for="p in plans" :key="p.id" class="diet-card">
        <div class="dc-head">
          <span class="dc-goal" :class="p.goal.toLowerCase()">{{ goalLabel(p.goal) }}</span>
          <span class="dc-kcal" v-if="p.caloriesPerDay">{{ p.caloriesPerDay }} kcal/día</span>
        </div>
        <h3 class="dc-name">{{ p.name }}</h3>
        <p class="dc-desc">{{ p.description }}</p>
        <ul class="dc-meals">
          <li v-for="m in p.meals" :key="m.position">
            <span class="meal-type">{{ mealLabel(m.mealType) }}</span>
            <span class="meal-info">
              <span class="meal-name">{{ m.name }}</span>
              <span class="meal-kcal" v-if="m.calories">{{ m.calories }} kcal</span>
            </span>
            <span class="meal-desc">{{ m.description }}</span>
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { dietService } from '../services/dietService'

const plans = ref([])
const loading = ref(true)
const activeFilter = ref('recommended')

const filters = [
  { value: null, label: 'Todas' },
  { value: 'LOSE_WEIGHT', label: 'Perder peso' },
  { value: 'GAIN_MUSCLE', label: 'Ganar músculo' },
  { value: 'MAINTAIN', label: 'Mantenimiento' },
  { value: 'BALANCED', label: 'Equilibrada' },
  { value: 'VEGETARIAN', label: 'Vegetariana' },
]

const loadRecommended = async () => {
  loading.value = true
  activeFilter.value = 'recommended'
  try { plans.value = await dietService.recommended() }
  finally { loading.value = false }
}

const loadByGoal = async (goal) => {
  loading.value = true
  activeFilter.value = goal
  try { plans.value = await dietService.list(goal) }
  finally { loading.value = false }
}

onMounted(loadRecommended)

const goalLabel = (g) => ({
  LOSE_WEIGHT: 'Perder peso', GAIN_MUSCLE: 'Ganar músculo', MAINTAIN: 'Mantenimiento',
  BALANCED: 'Equilibrada', VEGETARIAN: 'Vegetariana', VEGAN: 'Vegana',
}[g] || g)
const mealLabel = (m) => ({
  BREAKFAST: 'Desayuno', LUNCH: 'Comida', DINNER: 'Cena', SNACK: 'Snack',
}[m] || m)
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 1100px; margin: 0 auto; }
.page-head { margin-bottom: 24px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }
.loading, .empty { color: var(--gray); padding: 30px 0; text-align: center; }

.filters { display: flex; flex-wrap: wrap; gap: 10px; margin-bottom: 28px; }
.chip {
  background: var(--white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 9px 18px; border-radius: 100px; font-size: 13px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: all 0.18s;
}
.chip:hover { border-color: var(--blue-mid); color: var(--blue-mid); }
.chip.active { background: var(--blue); color: var(--white); border-color: var(--blue); }

.diet-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(330px, 1fr)); gap: 20px; }
.diet-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 18px; padding: 24px;
  display: flex; flex-direction: column; gap: 12px; box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.dc-head { display: flex; justify-content: space-between; align-items: center; }
.dc-goal {
  font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 100px;
  background: var(--blue-light); color: var(--blue-mid); text-transform: uppercase; letter-spacing: 0.5px;
}
.dc-goal.lose_weight { background: var(--yellow-light); color: #92400E; }
.dc-goal.gain_muscle { background: #EEF2FF; color: #4338CA; }
.dc-goal.vegetarian, .dc-goal.vegan { background: #ECFDF5; color: #047857; }
.dc-kcal { font-size: 12px; font-weight: 700; color: var(--gray); }
.dc-name { font-size: 20px; font-weight: 700; color: var(--dark); }
.dc-desc { font-size: 13px; color: var(--gray); line-height: 1.6; }
.dc-meals { list-style: none; display: flex; flex-direction: column; gap: 12px; padding-top: 12px; border-top: 1px solid var(--gray-light); }
.dc-meals li { display: flex; flex-direction: column; gap: 3px; }
.meal-type { font-size: 10px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--yellow); }
.meal-info { display: flex; justify-content: space-between; align-items: baseline; gap: 8px; }
.meal-name { font-size: 14px; font-weight: 600; color: var(--dark); }
.meal-kcal { font-size: 12px; font-weight: 700; color: var(--blue-mid); white-space: nowrap; }
.meal-desc { font-size: 12px; color: var(--gray); line-height: 1.5; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .diet-grid { grid-template-columns: 1fr; }
}
</style>
