<template>
  <div class="stat-card">
    <div class="stat-top">
      <div class="stat-icon-wrap">{{ icon }}</div>
      <span class="stat-title">{{ title }}</span>
    </div>
    <div class="stat-value">
      {{ value }}<span class="stat-unit">{{ unit }}</span>
    </div>
    <div class="stat-bar-wrap">
      <div class="stat-bar" :style="{ width: progress + '%' }"></div>
    </div>
    <div class="stat-sub">{{ subtitle }}</div>
  </div>
</template>

<script setup>
defineProps({
  title: String,
  value: String,
  unit: String,
  subtitle: String,
  icon: String,
  progress: { type: [String, Number], default: 0 }
})
</script>

<style scoped>
.stat-card {
  background: var(--white);
  border: 1px solid var(--gray-light);
  border-radius: 20px;
  padding: 22px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  transition: box-shadow 0.3s, transform 0.3s, border-color 0.3s;
  box-shadow: 0 2px 8px rgba(30,58,138,0.05);
}
.stat-card:hover {
  border-color: var(--blue-pale);
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(30,58,138,0.1);
}
.stat-top { display: flex; align-items: center; gap: 10px; }
.stat-icon-wrap {
  width: 36px; height: 36px;
  background: var(--blue-light);
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 18px;
  flex-shrink: 0;
}
.stat-title { font-size: 12px; color: var(--gray); font-weight: 500; text-transform: uppercase; letter-spacing: 0.8px; }
.stat-value { font-family: var(--font-display); font-size: 36px; color: var(--dark); line-height: 1; letter-spacing: 1px; }
.stat-unit { font-family: var(--font-body); font-size: 13px; color: var(--gray); margin-left: 4px; letter-spacing: 0; }
.stat-bar-wrap { height: 5px; background: var(--blue-pale); border-radius: 3px; overflow: hidden; }
.stat-bar { height: 100%; background: linear-gradient(90deg, var(--blue-mid), var(--yellow)); border-radius: 3px; transition: width 0.8s ease; }
.stat-sub { font-size: 11px; color: var(--gray); }
</style>
