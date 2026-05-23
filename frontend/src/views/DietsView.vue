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
      <button class="chip" :class="{ active: activeFilter === 'recommended' }" @click="loadRecommended">★ Recomendadas para mí</button>
      <button class="chip" :class="{ active: activeFilter === 'saved' }" @click="loadSaved">♥ Guardadas</button>
      <button class="chip" :class="{ active: activeFilter === 'mine' }" @click="loadMine">📝 Mis dietas</button>
      <button
        v-for="f in filters"
        :key="f.value"
        class="chip"
        :class="{ active: activeFilter === f.value }"
        @click="loadByGoal(f.value)"
      >{{ f.label }}</button>
    </div>

    <!-- ===== Mis dietas personalizadas ===== -->
    <section v-if="activeFilter === 'mine'" class="mine-section">
      <!-- Editor de dieta (creando o editando) -->
      <div v-if="editor.open" class="card editor">
        <div class="ed-header">
          <h2 class="ed-title">{{ editor.id ? 'Editar dieta' : 'Crear dieta personalizada' }}</h2>
          <button class="icon-btn" @click="cancelEdit" title="Cancelar">✕</button>
        </div>

        <div class="ed-fields">
          <div class="field">
            <label>Nombre</label>
            <input v-model="editor.name" placeholder="P. ej. Mi día alto en proteína" maxlength="120" />
          </div>
          <div class="field">
            <label>Descripción (opcional)</label>
            <textarea v-model="editor.description" rows="2" placeholder="Qué incluye, para qué la usas…" maxlength="1000"></textarea>
          </div>
        </div>

        <h3 class="ed-sub">Alimentos</h3>
        <div class="items-list">
          <div v-for="(item, idx) in editor.items" :key="idx" class="item-row">
            <div class="ir-food">
              <select v-model="item.foodId" @change="onFoodChanged(item)">
                <option :value="null">— Alimento libre —</option>
                <optgroup v-for="cat in foodGroups" :key="cat.key" :label="cat.label">
                  <option v-for="f in cat.foods" :key="f.id" :value="f.id">
                    {{ f.name }} · {{ Number(f.kcalPer100g) }} kcal/100g
                  </option>
                </optgroup>
              </select>
              <input
                v-if="!item.foodId"
                v-model="item.foodNameFreetext"
                placeholder="Nombre del alimento"
                class="freetext"
              />
            </div>
            <input
              type="number"
              v-model.number="item.grams"
              min="0"
              step="1"
              class="ir-grams"
              placeholder="g"
              @input="recalcItem(item)"
            />
            <span class="ir-unit">g</span>
            <input
              v-if="!item.foodId"
              type="number"
              v-model.number="item.kcal"
              min="0"
              step="1"
              class="ir-kcal-input"
              placeholder="kcal"
            />
            <span v-else class="ir-kcal">{{ formatKcal(item.kcal) }} kcal</span>
            <button class="icon-btn danger" @click="removeItem(idx)" title="Quitar alimento">✕</button>
          </div>
          <button class="add-item-btn" @click="addItem">+ Añadir alimento</button>
        </div>

        <div class="ed-footer">
          <div class="total-row">
            <span class="total-label">Total calculado</span>
            <span class="total-kcal">{{ formatKcal(totalKcal) }} kcal</span>
          </div>
          <div class="ed-actions">
            <button type="button" class="btn-ghost" @click="cancelEdit">Cancelar</button>
            <button type="button" class="btn-primary" :disabled="!canSave || editor.saving" @click="saveEditor">
              {{ editor.saving ? 'Guardando…' : 'Guardar dieta' }}
            </button>
          </div>
        </div>
      </div>

      <!-- Listado de mis dietas + botón crear -->
      <div v-else>
        <div class="mine-toolbar">
          <p class="mine-hint">Crea tus propias dietas eligiendo alimentos del catálogo o añadiendo los tuyos. Las calorías se calculan automáticamente.</p>
          <button class="btn-primary" @click="startCreate">+ Crear nueva dieta</button>
        </div>

        <div v-if="loading" class="loading">Cargando…</div>
        <div v-else-if="myDiets.length === 0" class="empty">Aún no has creado ninguna dieta. Pulsa "Crear nueva dieta" para empezar.</div>

        <div v-else class="mine-grid">
          <article v-for="d in myDiets" :key="d.id" class="mine-card">
            <header class="mc-head">
              <h3 class="mc-name">{{ d.name }}</h3>
              <span class="mc-kcal">{{ formatKcal(d.totalKcal) }} kcal</span>
            </header>
            <p class="mc-desc" v-if="d.description">{{ d.description }}</p>
            <ul class="mc-items">
              <li v-for="i in d.items" :key="i.id">
                <span class="mc-item-name">{{ i.foodName }}</span>
                <span class="mc-item-meta">{{ Number(i.grams) }} g · {{ formatKcal(i.kcal) }} kcal</span>
              </li>
            </ul>
            <div class="mc-actions">
              <button class="btn-ghost-sm" @click="startEdit(d)">Editar</button>
              <button class="btn-ghost-sm danger" @click="removeMine(d)">Eliminar</button>
            </div>
          </article>
        </div>
      </div>
    </section>

    <!-- ===== Resto de filtros (planes pre-hechos) ===== -->
    <template v-else>
    <div v-if="loading" class="loading">Cargando dietas…</div>
    <div v-else-if="plans.length === 0" class="empty">
      {{ activeFilter === 'saved' ? 'Aún no has guardado ninguna dieta. Pulsa la estrella en una tarjeta.' : 'No hay dietas para este filtro.' }}
    </div>

    <div v-else class="diet-grid">
      <div
        v-for="p in plans"
        :key="p.id"
        class="diet-card"
        :class="{ clickable: p.recipeUrl }"
        @click="openRecipe(p)"
      >
        <div class="dc-head">
          <span class="dc-goal" :class="p.goal.toLowerCase()">{{ goalLabel(p.goal) }}</span>
          <div class="dc-head-right">
            <span class="dc-kcal" v-if="p.caloriesPerDay">{{ p.caloriesPerDay }} kcal/día</span>
            <button
              class="save-btn"
              :class="{ saved: p.saved }"
              @click.stop="toggleSave(p)"
              :title="p.saved ? 'Quitar de guardadas' : 'Guardar dieta'"
            >{{ p.saved ? '★' : '☆' }}</button>
          </div>
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
        <span class="dc-recipe" v-if="p.recipeUrl">🎬 Ver recetas de preparación →</span>
      </div>
    </div>
    </template>

    <transition name="fade">
      <div v-if="toast" class="toast">{{ toast }}</div>
    </transition>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { dietService } from '../services/dietService'

const plans = ref([])
const loading = ref(true)
const activeFilter = ref('recommended')
const toast = ref('')

// ===== Mis dietas personalizadas =====
const myDiets = ref([])
const foods = ref([])
const editor = reactive({
  open: false,
  id: null,            // null = creando, UUID = editando
  name: '',
  description: '',
  items: [],           // [{ foodId, foodNameFreetext, grams, kcal }]
  saving: false,
})

const CATEGORY_LABELS = {
  proteinas: '🥩 Proteínas',
  carbohidratos: '🍚 Carbohidratos',
  verduras: '🥦 Verduras',
  frutas: '🍎 Frutas',
  lacteos: '🥛 Lácteos',
  grasas: '🥑 Grasas / frutos secos',
  otros: '🍫 Otros',
}

/** Agrupa los alimentos por categoría para el <optgroup> del <select>. */
const foodGroups = computed(() => {
  const groups = {}
  for (const f of foods.value) {
    const k = f.category || 'otros'
    if (!groups[k]) groups[k] = []
    groups[k].push(f)
  }
  // Orden de categorías
  const order = ['proteinas', 'carbohidratos', 'verduras', 'frutas', 'lacteos', 'grasas', 'otros']
  return order
    .filter((k) => groups[k]?.length)
    .map((k) => ({ key: k, label: CATEGORY_LABELS[k] || k, foods: groups[k] }))
})

const totalKcal = computed(() =>
  editor.items.reduce((sum, i) => sum + (Number(i.kcal) || 0), 0)
)

const canSave = computed(() =>
  editor.name.trim().length > 0
  && editor.items.length > 0
  && editor.items.every((i) => Number(i.grams) >= 0 && (i.foodId || (i.foodNameFreetext || '').trim().length > 0))
)

const formatKcal = (n) => {
  const v = Number(n) || 0
  return v.toFixed(v % 1 === 0 ? 0 : 1)
}

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

const loadSaved = async () => {
  loading.value = true
  activeFilter.value = 'saved'
  try { plans.value = await dietService.saved() }
  finally { loading.value = false }
}

const loadByGoal = async (goal) => {
  loading.value = true
  activeFilter.value = goal
  try { plans.value = await dietService.list(goal) }
  finally { loading.value = false }
}

const loadMine = async () => {
  loading.value = true
  activeFilter.value = 'mine'
  try {
    // Cargamos las dietas + el catálogo de alimentos solo si no estaba ya
    const [diets, allFoods] = await Promise.all([
      dietService.myDiets(),
      foods.value.length === 0 ? dietService.foods() : Promise.resolve(foods.value),
    ])
    myDiets.value = diets
    if (foods.value.length === 0) foods.value = allFoods
  } finally {
    loading.value = false
  }
}

onMounted(loadRecommended)

// ===== Acciones del editor =====
const blankItem = () => ({ foodId: null, foodNameFreetext: '', grams: 100, kcal: 0 })

const startCreate = () => {
  editor.open = true
  editor.id = null
  editor.name = ''
  editor.description = ''
  editor.items = [blankItem()]
}

const startEdit = (d) => {
  editor.open = true
  editor.id = d.id
  editor.name = d.name
  editor.description = d.description || ''
  editor.items = d.items.map((i) => ({
    foodId: i.foodId,
    foodNameFreetext: i.foodId ? '' : (i.foodName || ''),
    grams: Number(i.grams),
    kcal: Number(i.kcal),
  }))
}

const cancelEdit = () => {
  editor.open = false
  editor.id = null
  editor.items = []
}

const addItem = () => { editor.items.push(blankItem()) }
const removeItem = (idx) => { editor.items.splice(idx, 1) }

const findFood = (id) => foods.value.find((f) => f.id === id)

/** Recalcula kcal de un item a partir del alimento del catálogo y los gramos. */
const recalcItem = (item) => {
  if (!item.foodId) return
  const f = findFood(item.foodId)
  if (!f) return
  const g = Number(item.grams) || 0
  const kPer100 = Number(f.kcalPer100g) || 0
  item.kcal = Math.round((g * kPer100 / 100) * 10) / 10
}

const onFoodChanged = (item) => {
  if (item.foodId) {
    item.foodNameFreetext = ''
    recalcItem(item)
  } else {
    // Alimento libre: dejamos kcal a que el usuario lo edite
    item.kcal = 0
  }
}

const saveEditor = async () => {
  if (!canSave.value) return
  editor.saving = true
  try {
    const payload = {
      name: editor.name.trim(),
      description: editor.description.trim() || null,
      items: editor.items.map((i) => ({
        foodId: i.foodId,
        foodNameFreetext: i.foodId ? null : (i.foodNameFreetext || '').trim(),
        grams: Number(i.grams) || 0,
        kcal: i.foodId ? null : (Number(i.kcal) || 0),
      })),
    }
    if (editor.id) {
      await dietService.updateMyDiet(editor.id, payload)
      showToast(`"${editor.name}" actualizada ✓`)
    } else {
      await dietService.createMyDiet(payload)
      showToast(`"${editor.name}" creada ✓`)
    }
    cancelEdit()
    myDiets.value = await dietService.myDiets()
  } catch (e) {
    showToast(e?.response?.data?.message || 'No se pudo guardar')
  } finally {
    editor.saving = false
  }
}

const removeMine = async (d) => {
  if (!confirm(`¿Eliminar "${d.name}"?`)) return
  try {
    await dietService.deleteMyDiet(d.id)
    myDiets.value = myDiets.value.filter((x) => x.id !== d.id)
    showToast(`"${d.name}" eliminada`)
  } catch {
    showToast('No se pudo eliminar')
  }
}

const openRecipe = (p) => {
  if (p.recipeUrl) window.open(p.recipeUrl, '_blank', 'noopener')
}

const showToast = (msg) => {
  toast.value = msg
  setTimeout(() => (toast.value = ''), 2500)
}

const toggleSave = async (p) => {
  try {
    if (p.saved) {
      await dietService.unsave(p.id)
      p.saved = false
      showToast(`"${p.name}" quitada de guardadas`)
      if (activeFilter.value === 'saved') {
        plans.value = plans.value.filter((x) => x.id !== p.id)
      }
    } else {
      await dietService.save(p.id)
      p.saved = true
      showToast(`"${p.name}" guardada ★`)
    }
  } catch {
    showToast('No se pudo actualizar')
  }
}

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
  transition: transform 0.2s, box-shadow 0.2s, border-color 0.2s;
}
.diet-card.clickable { cursor: pointer; }
.diet-card.clickable:hover { transform: translateY(-4px); box-shadow: 0 14px 30px rgba(30,58,138,0.12); border-color: var(--blue-pale); }
.dc-head { display: flex; justify-content: space-between; align-items: center; }
.dc-head-right { display: flex; align-items: center; gap: 10px; }
/* Badges con colores hardcodeados (no usan vars que cambian en modo oscuro)
   para que siempre tengan contraste en ambos temas. */
.dc-goal {
  font-size: 11px; font-weight: 700; padding: 4px 12px; border-radius: 100px;
  background: #1E3A8A; color: #FFFFFF; text-transform: uppercase; letter-spacing: 0.5px;
}
.dc-goal.lose_weight { background: #F2E638; color: #1E3A8A; }
.dc-goal.gain_muscle { background: #1E3A8A; color: #FFFFFF; }
.dc-goal.vegetarian, .dc-goal.vegan { background: #2563EB; color: #FFFFFF; }
.dc-kcal { font-size: 12px; font-weight: 700; color: var(--gray); }
.save-btn {
  background: none; border: none; cursor: pointer; font-size: 22px; line-height: 1;
  color: var(--gray-light); padding: 0; transition: transform 0.15s, color 0.15s;
}
.save-btn:hover { transform: scale(1.2); color: var(--yellow); }
.save-btn.saved { color: var(--yellow); }
.dc-name { font-size: 20px; font-weight: 700; color: var(--dark); }
.dc-desc { font-size: 13px; color: var(--gray); line-height: 1.6; }
.dc-meals { list-style: none; display: flex; flex-direction: column; gap: 12px; padding-top: 12px; border-top: 1px solid var(--gray-light); }
.dc-meals li { display: flex; flex-direction: column; gap: 3px; }
.meal-type { font-size: 10px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--yellow); }
.meal-info { display: flex; justify-content: space-between; align-items: baseline; gap: 8px; }
.meal-name { font-size: 14px; font-weight: 600; color: var(--dark); }
.meal-kcal { font-size: 12px; font-weight: 700; color: var(--blue-mid); white-space: nowrap; }
.meal-desc { font-size: 12px; color: var(--gray); line-height: 1.5; }
.dc-recipe { margin-top: 6px; font-size: 13px; font-weight: 700; color: var(--blue-mid); }

/* ===== Mis dietas personalizadas ===== */
.mine-section { display: flex; flex-direction: column; gap: 20px; }
.mine-toolbar {
  display: flex; align-items: center; justify-content: space-between; gap: 16px;
  flex-wrap: wrap; margin-bottom: 12px;
}
.mine-hint { font-size: 13px; color: var(--gray); max-width: 620px; line-height: 1.5; }

.mine-grid {
  display: grid; grid-template-columns: repeat(auto-fill, minmax(330px, 1fr)); gap: 20px;
}
.mine-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 18px;
  padding: 22px; display: flex; flex-direction: column; gap: 12px;
  box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.mc-head { display: flex; justify-content: space-between; align-items: center; gap: 10px; }
.mc-name { font-size: 18px; font-weight: 700; color: var(--dark); }
.mc-kcal {
  font-size: 12px; font-weight: 700; padding: 4px 12px; border-radius: 100px;
  background: #F2E638; color: #1E3A8A; white-space: nowrap;
}
.mc-desc { font-size: 13px; color: var(--gray); line-height: 1.5; }
.mc-items { list-style: none; display: flex; flex-direction: column; gap: 7px;
  padding-top: 10px; border-top: 1px solid var(--gray-light); }
.mc-items li { display: flex; justify-content: space-between; gap: 8px; font-size: 13px; }
.mc-item-name { color: var(--dark); font-weight: 500; }
.mc-item-meta { color: var(--gray); white-space: nowrap; }
.mc-actions { display: flex; gap: 8px; margin-top: auto; padding-top: 6px; }

.btn-primary {
  background: var(--yellow); color: #1E3A8A; border: none; padding: 11px 22px;
  border-radius: 10px; font-size: 14px; font-weight: 700; font-family: var(--font-body);
  cursor: pointer; transition: opacity 0.2s, transform 0.2s; box-shadow: 0 4px 16px rgba(242,230,56,0.3);
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }

.btn-ghost {
  background: transparent; border: 1px solid var(--gray-light); color: var(--dark);
  padding: 11px 22px; border-radius: 10px; font-size: 14px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: border-color 0.2s, color 0.2s;
}
.btn-ghost:hover { border-color: var(--blue-mid); color: var(--blue-mid); }

.btn-ghost-sm {
  background: transparent; border: 1px solid var(--gray-light); color: var(--dark);
  padding: 7px 14px; border-radius: 8px; font-size: 12px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: border-color 0.2s, color 0.2s;
}
.btn-ghost-sm:hover { border-color: var(--blue-mid); color: var(--blue-mid); }
.btn-ghost-sm.danger:hover { border-color: #DC2626; color: #DC2626; }

/* ----- Editor ----- */
.editor { display: flex; flex-direction: column; gap: 18px; padding: 28px; }
.ed-header { display: flex; align-items: center; justify-content: space-between; gap: 12px; }
.ed-title { font-family: var(--font-display); font-size: 26px; letter-spacing: 0.5px; color: var(--dark); }
.icon-btn {
  background: transparent; border: 1px solid var(--gray-light); color: var(--gray);
  width: 32px; height: 32px; border-radius: 50%; font-size: 14px; cursor: pointer;
  display: flex; align-items: center; justify-content: center;
  transition: border-color 0.2s, color 0.2s;
}
.icon-btn:hover { border-color: var(--blue-mid); color: var(--blue-mid); }
.icon-btn.danger:hover { border-color: #DC2626; color: #DC2626; }

.ed-fields { display: flex; flex-direction: column; gap: 14px; }
.field { display: flex; flex-direction: column; gap: 7px; }
.field label { font-size: 13px; font-weight: 600; color: var(--dark); }
.field input, .field textarea {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 11px 14px; border-radius: 10px; font-size: 14px; font-family: var(--font-body); outline: none;
  transition: border-color 0.2s, box-shadow 0.2s; resize: vertical;
}
.field input:focus, .field textarea:focus {
  border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}

.ed-sub { font-size: 14px; font-weight: 700; color: var(--dark); margin-top: 4px; letter-spacing: 0.3px; }

.items-list { display: flex; flex-direction: column; gap: 10px; }
.item-row {
  display: grid;
  grid-template-columns: 1fr 80px auto auto;
  align-items: center; gap: 10px;
  background: var(--off-white); border: 1px solid var(--gray-light);
  border-radius: 10px; padding: 10px;
}
.ir-food { display: flex; flex-direction: column; gap: 6px; min-width: 0; }
.ir-food select, .ir-food .freetext {
  background: var(--white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 9px 12px; border-radius: 8px; font-size: 13px; font-family: var(--font-body); outline: none;
  width: 100%;
}
.ir-food select:focus, .ir-food .freetext:focus {
  border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}
.ir-grams, .ir-kcal-input {
  background: var(--white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 9px 12px; border-radius: 8px; font-size: 13px; font-family: var(--font-body); outline: none;
  width: 100%; text-align: right;
}
.ir-grams:focus, .ir-kcal-input:focus {
  border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}
.ir-unit { font-size: 12px; color: var(--gray); font-weight: 600; }
.ir-kcal {
  font-size: 13px; font-weight: 700; color: var(--blue-mid);
  background: rgba(37,99,235,0.08); padding: 6px 10px; border-radius: 8px;
  white-space: nowrap;
}

.add-item-btn {
  background: transparent; border: 2px dashed var(--gray-light); color: var(--blue-mid);
  padding: 10px; border-radius: 10px; font-size: 13px; font-weight: 600;
  font-family: var(--font-body); cursor: pointer; transition: border-color 0.2s, background 0.2s;
}
.add-item-btn:hover { border-color: var(--blue-mid); background: rgba(37,99,235,0.05); }

.ed-footer {
  display: flex; justify-content: space-between; align-items: center; gap: 16px;
  border-top: 1px solid var(--gray-light); padding-top: 16px; margin-top: 4px; flex-wrap: wrap;
}
.total-row { display: flex; flex-direction: column; gap: 2px; }
.total-label { font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--gray); }
.total-kcal { font-family: var(--font-display); font-size: 28px; letter-spacing: 0.5px; color: #1E3A8A; }
.ed-actions { display: flex; gap: 10px; }

.toast {
  position: fixed; bottom: 32px; left: 50%; transform: translateX(-50%);
  background: var(--dark); color: var(--white); padding: 14px 28px; border-radius: 100px;
  font-size: 14px; font-weight: 600; box-shadow: 0 8px 24px rgba(0,0,0,0.2); z-index: 200;
}
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s; }
.fade-enter-from, .fade-leave-to { opacity: 0; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .diet-grid, .mine-grid { grid-template-columns: 1fr; }
  .item-row {
    grid-template-columns: 1fr auto;
    grid-template-areas:
      "food food"
      "grams kcal"
      "remove remove";
    gap: 8px;
  }
  .ir-food { grid-area: food; }
  .ir-grams { grid-area: grams; }
  .ir-unit { display: none; }
  .ir-kcal, .ir-kcal-input { grid-area: kcal; justify-self: end; }
  .item-row > .icon-btn { grid-area: remove; justify-self: end; }
  .mine-toolbar { flex-direction: column; align-items: flex-start; }
  .ed-footer { flex-direction: column; align-items: stretch; }
  .ed-actions { width: 100%; }
  .ed-actions button { flex: 1; }
}
</style>
