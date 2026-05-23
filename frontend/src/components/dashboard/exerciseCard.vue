<template>
  <div class="exercise">
    <div class="exercise-info">
      <div class="exercise-badge">Ejercicio del día</div>
      <h2 class="exercise-title">{{ title }}</h2>
      <div class="exercise-meta">
        <span class="meta-item"><span class="meta-icon">⏱</span> {{ time }}</span>
        <span class="meta-item"><span class="meta-icon">🔁</span> {{ sets }}</span>
      </div>
      <button class="start-btn">▶ Iniciar sesión</button>
    </div>
    <div class="exercise-img-wrap">
      <img :src="image" alt="exercise" />
    </div>
  </div>
</template>

<script setup>
defineProps({ title: String, time: String, sets: String, image: String })
</script>

<style scoped>
.exercise {
  background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
  border-radius: 20px;
  padding: 32px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 20px;
  min-height: 220px;
  box-shadow: 0 8px 32px rgba(30,58,138,0.2);
  overflow: hidden;
  position: relative;
}
.exercise::before {
  content: '';
  position: absolute;
  top: -60px; right: -60px;
  width: 200px; height: 200px;
  border-radius: 50%;
  background: rgba(255,255,255,0.04);
}
.exercise-badge {
  display: inline-block;
  background: rgba(242,230,56,0.2);
  border: 1px solid rgba(242,230,56,0.4);
  color: var(--yellow-warm);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  padding: 4px 12px;
  border-radius: 100px;
  margin-bottom: 12px;
}
.exercise-title {
  font-family: var(--font-display);
  font-size: 36px;
  color: var(--white);
  letter-spacing: 1px;
  margin-bottom: 12px;
}
.exercise-meta { display: flex; gap: 16px; margin-bottom: 20px; }
.meta-item {
  font-size: 13px;
  color: rgba(255,255,255,0.7);
  display: flex;
  align-items: center;
  gap: 5px;
}
.meta-icon { font-size: 14px; }
.start-btn {
  background: var(--yellow);
  color: #1E3A8A;
  border: none;
  padding: 10px 22px;
  border-radius: 100px;
  font-size: 13px;
  font-weight: 700;
  cursor: pointer;
  transition: opacity 0.2s, transform 0.2s;
  box-shadow: 0 4px 16px rgba(242,230,56,0.35);
}
.start-btn:hover { opacity: 0.9; transform: scale(1.03); }
.exercise-info { position: relative; z-index: 1; }
.exercise-img-wrap { flex-shrink: 0; position: relative; z-index: 1; }
.exercise-img-wrap img { height: 160px; object-fit: contain; filter: drop-shadow(0 8px 24px rgba(0,0,0,0.3)); }
</style>
