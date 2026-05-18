<template>
  <div class="post-page">
    <div class="post-inner">
      <router-link to="/blog" class="back-link">← Volver al blog</router-link>
      <div class="post-tag">{{ post.tag }}</div>
      <h1 class="post-title">{{ post.title }}</h1>
      <p class="post-date">ZenFit · Mayo 2026 · 5 min de lectura</p>
      <div class="post-divider"></div>
      <div class="post-content">
        <p>{{ post.content }}</p>
        <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Llevar una vida saludable no tiene que ser complicado — con los hábitos correctos y la constancia adecuada, cualquier persona puede alcanzar sus metas de bienestar.</p>
        <p>La clave está en la consistencia. Los pequeños cambios sostenidos en el tiempo tienen un impacto mucho mayor que los esfuerzos intensos y temporales. ZenFit está diseñado para acompañarte en ese proceso, paso a paso.</p>
      </div>
      <div class="post-cta">
        <div class="post-cta-text">
          <div class="cta-icon">🚀</div>
          <p>¿Listo para empezar tu transformación?</p>
          <span class="cta-sub">Únete a más de 50.000 personas que ya mejoran su salud con ZenFit.</span>
        </div>
        <router-link to="/register" class="cta-btn">Únete gratis →</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const postId = Number(route.params.id)

const allPosts = {
  1: { tag: 'Fitness', title: 'Cómo empezar en el fitness sin morir en el intento', content: 'Los primeros pasos para mejorar tu salud no tienen que ser radicales. Pequeños cambios sostenidos marcan la diferencia a largo plazo.' },
  2: { tag: 'Nutrición', title: 'Alimentación saludable: mitos y realidades', content: 'Desmontamos los 5 mitos más comunes sobre la dieta sana y te contamos qué dice la ciencia de verdad.' },
  3: { tag: 'Sueño', title: 'Por qué dormir bien cambia todo', content: 'El sueño es el pilar más infravalorado de la salud. Descubre cómo optimizarlo con pequeños hábitos nocturnos.' },
}

const post = ref(allPosts[postId] || { tag: 'Blog', title: 'Artículo #' + postId, content: 'Contenido próximamente...' })
</script>

<style scoped>
.post-page {
  min-height: 100vh;
  padding: 120px 48px 80px;
  background: var(--white);
}
.post-inner {
  max-width: 720px;
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  gap: 20px;
}
.back-link {
  color: var(--gray);
  font-size: 14px;
  font-weight: 500;
  transition: color 0.2s;
  display: inline-flex;
  align-items: center;
}
.back-link:hover { color: var(--blue-mid); }

.post-tag {
  display: inline-block;
  background: var(--yellow-light);
  border: 1px solid var(--yellow-warm);
  color: #92400E;
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  padding: 4px 14px;
  border-radius: 100px;
  width: fit-content;
}
.post-title {
  font-family: var(--font-display);
  font-size: clamp(36px, 5vw, 56px);
  line-height: 1.05;
  letter-spacing: 1px;
  color: var(--dark);
}
.post-date { font-size: 13px; color: var(--gray); }
.post-divider { height: 1px; background: var(--gray-light); }
.post-content { display: flex; flex-direction: column; gap: 20px; }
.post-content p { font-size: 17px; line-height: 1.8; color: var(--dark); opacity: 0.85; }

.post-cta {
  margin-top: 20px;
  background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 100%);
  border-radius: 20px;
  padding: 36px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  flex-wrap: wrap;
  box-shadow: 0 8px 32px rgba(30,58,138,0.2);
}
.post-cta-text { display: flex; flex-direction: column; gap: 6px; }
.cta-icon { font-size: 28px; margin-bottom: 4px; }
.post-cta-text p { font-size: 20px; font-weight: 700; color: var(--white); line-height: 1.3; }
.cta-sub { font-size: 14px; color: rgba(255,255,255,0.65); max-width: 360px; line-height: 1.5; }
.cta-btn {
  background: var(--yellow);
  color: var(--dark);
  padding: 13px 26px;
  border-radius: 100px;
  font-weight: 700;
  font-size: 14px;
  white-space: nowrap;
  transition: opacity 0.2s, transform 0.2s;
  flex-shrink: 0;
  box-shadow: 0 4px 16px rgba(245,158,11,0.35);
}
.cta-btn:hover { opacity: 0.9; transform: translateY(-1px); }

@media (max-width: 768px) {
  .post-page { padding: 100px 20px 60px; }
  .post-cta { flex-direction: column; align-items: flex-start; }
}
</style>
