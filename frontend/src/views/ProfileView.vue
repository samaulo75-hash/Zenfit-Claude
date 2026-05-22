<template>
  <div class="page">
    <header class="page-head">
      <div>
        <p class="page-label">Mi cuenta</p>
        <h1 class="page-title">Perfil de bienestar</h1>
        <p class="page-sub">Completa tus datos para personalizar tu experiencia</p>
      </div>
    </header>

    <div v-if="loading" class="loading">Cargando perfil…</div>

    <form v-else class="card form" @submit.prevent="save">
      <div class="grid">
        <div class="field">
          <label>Fecha de nacimiento</label>
          <input type="date" v-model="form.dateOfBirth" :max="today" />
        </div>

        <div class="field">
          <label>Género</label>
          <select v-model="form.gender">
            <option :value="null">— Sin especificar —</option>
            <option value="MALE">Hombre</option>
            <option value="FEMALE">Mujer</option>
            <option value="OTHER">Otro</option>
            <option value="PREFER_NOT_TO_SAY">Prefiero no decirlo</option>
          </select>
        </div>

        <div class="field">
          <label>Altura (cm)</label>
          <input type="number" v-model.number="form.heightCm" min="0" max="300" step="0.1" placeholder="175" />
        </div>

        <div class="field">
          <label>Peso (kg)</label>
          <input type="number" v-model.number="form.weightKg" min="0" max="500" step="0.1" placeholder="70" />
        </div>

        <div class="field field-wide">
          <label>Objetivo fitness</label>
          <select v-model="form.fitnessGoal">
            <option :value="null">— Sin especificar —</option>
            <option value="LOSE_WEIGHT">Perder peso</option>
            <option value="GAIN_MUSCLE">Ganar músculo</option>
            <option value="INCREASE_STRENGTH">Aumentar fuerza</option>
            <option value="TONE_BODY">Tonificar el cuerpo</option>
            <option value="IMPROVE_ENDURANCE">Mejorar resistencia</option>
            <option value="INCREASE_FLEXIBILITY">Ganar flexibilidad</option>
            <option value="IMPROVE_POSTURE">Mejorar la postura</option>
            <option value="MAINTAIN">Mantenerme</option>
            <option value="INCREASE_ENERGY">Tener más energía</option>
            <option value="REDUCE_STRESS">Reducir estrés</option>
            <option value="BETTER_SLEEP">Dormir mejor</option>
            <option value="BUILD_HABITS">Construir hábitos saludables</option>
          </select>
        </div>

        <div class="field">
          <label>Nivel de actividad</label>
          <select v-model="form.activityLevel">
            <option value="SEDENTARY">Sedentario</option>
            <option value="LIGHT">Ligero</option>
            <option value="MODERATE">Moderado</option>
            <option value="ACTIVE">Activo</option>
            <option value="VERY_ACTIVE">Muy activo</option>
          </select>
        </div>
      </div>

      <div class="field">
        <label>Notas médicas (opcional)</label>
        <textarea v-model="form.medicalNotes" rows="3" placeholder="Lesiones, alergias, condiciones…"></textarea>
      </div>

      <div class="actions">
        <button class="btn-primary" type="submit" :disabled="saving">
          {{ saving ? 'Guardando…' : 'Guardar cambios' }}
        </button>
        <span v-if="savedMsg" class="saved">{{ savedMsg }}</span>
        <span v-if="error" class="error">{{ error }}</span>
      </div>
    </form>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from 'vue'
import { profileService } from '../services/profileService'

const loading = ref(true)
const saving = ref(false)
const error = ref('')
const savedMsg = ref('')
const today = computed(() => new Date().toISOString().slice(0, 10))

const form = reactive({
  dateOfBirth: null,
  gender: null,
  heightCm: null,
  weightKg: null,
  fitnessGoal: null,
  activityLevel: 'MODERATE',
  medicalNotes: '',
})

onMounted(async () => {
  try {
    const p = await profileService.get()
    Object.assign(form, {
      dateOfBirth: p.dateOfBirth,
      gender: p.gender,
      heightCm: p.heightCm,
      weightKg: p.weightKg,
      fitnessGoal: p.fitnessGoal,
      activityLevel: p.activityLevel || 'MODERATE',
      medicalNotes: p.medicalNotes || '',
    })
  } catch (e) {
    error.value = 'No se pudo cargar el perfil'
  } finally {
    loading.value = false
  }
})

const save = async () => {
  error.value = ''
  savedMsg.value = ''
  saving.value = true
  try {
    await profileService.update({ ...form })
    savedMsg.value = '✓ Perfil guardado'
    setTimeout(() => (savedMsg.value = ''), 3000)
  } catch (e) {
    error.value = e?.response?.data?.message || 'Error al guardar'
  } finally {
    saving.value = false
  }
}
</script>

<style scoped>
.page { padding: 40px 48px 60px; max-width: 880px; margin: 0 auto; }
.page-head { margin-bottom: 28px; }
.page-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 6px; }
.page-title { font-family: var(--font-display); font-size: 40px; letter-spacing: 1px; color: var(--dark); }
.page-sub { font-size: 14px; color: var(--gray); }
.loading { color: var(--gray); padding: 40px 0; }

.card { background: var(--white); border: 1px solid var(--gray-light); border-radius: 20px; padding: 32px; box-shadow: 0 2px 8px rgba(30,58,138,0.05); }
.form { display: flex; flex-direction: column; gap: 20px; }
.grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
.field { display: flex; flex-direction: column; gap: 7px; }
.field-wide { grid-column: 1 / -1; }
.field label { font-size: 13px; font-weight: 500; color: var(--dark); }
.field input, .field select, .field textarea {
  background: var(--off-white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 12px 14px; border-radius: 10px; font-size: 15px; font-family: var(--font-body); outline: none;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.field input:focus, .field select:focus, .field textarea:focus {
  border-color: var(--blue-mid); box-shadow: 0 0 0 3px rgba(37,99,235,0.1);
}
.actions { display: flex; align-items: center; gap: 16px; }
.btn-primary {
  background: var(--yellow); color: var(--dark); border: none; padding: 13px 28px; border-radius: 10px;
  font-size: 15px; font-weight: 700; font-family: var(--font-body); cursor: pointer;
  box-shadow: 0 4px 16px rgba(242,230,56,0.3); transition: opacity 0.2s, transform 0.2s;
}
.btn-primary:hover:not(:disabled) { opacity: 0.9; transform: translateY(-1px); }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }
.saved { color: #2563EB; font-size: 14px; font-weight: 600; }
.error { color: #DC2626; font-size: 14px; }

@media (max-width: 768px) {
  .page { padding: 32px 20px 40px; }
  .grid { grid-template-columns: 1fr; }
}
</style>
