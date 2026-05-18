<template>
  <div class="post-page">
    <div class="post-inner" v-if="post">
      <router-link to="/blog" class="back-link">← Volver al blog</router-link>
      <div class="post-tag">{{ post.tag }}</div>
      <h1 class="post-title">{{ post.title }}</h1>
      <p class="post-date">ZenFit · {{ post.readTime }} de lectura</p>
      <p class="post-lead">{{ post.excerpt }}</p>
      <div class="post-divider"></div>

      <article class="post-content">
        <section v-for="(s, i) in post.sections" :key="i">
          <h2>{{ s.heading }}</h2>
          <p v-for="(p, j) in s.paragraphs" :key="j">{{ p }}</p>
        </section>
      </article>

      <nav class="post-nav" v-if="related.length">
        <span class="post-nav-label">Sigue leyendo</span>
        <router-link
          v-for="r in related"
          :key="r.slug"
          :to="'/blog/' + r.slug"
          class="post-nav-link"
        >
          {{ r.title }} →
        </router-link>
      </nav>

      <div class="post-cta">
        <div class="post-cta-text">
          <div class="cta-icon">🚀</div>
          <p>¿Listo para ponerlo en práctica?</p>
          <span class="cta-sub">Crea tu cuenta gratis y empieza a usar ZenFit ahora mismo.</span>
        </div>
        <router-link to="/register" class="cta-btn">Únete gratis →</router-link>
      </div>
    </div>

    <div class="post-inner not-found" v-else>
      <h1>Artículo no encontrado</h1>
      <p>Puede que el enlace haya cambiado.</p>
      <router-link to="/blog" class="back-link">← Volver al blog</router-link>
    </div>
  </div>
</template>

<script setup>
import { computed, watch } from 'vue'
import { useRoute } from 'vue-router'
import { blogPosts, findPost } from '../data/blogPosts'

const route = useRoute()
const post = computed(() => findPost(route.params.slug))
const related = computed(() =>
  blogPosts.filter((p) => p.slug !== route.params.slug).slice(0, 2)
)

// Al cambiar de artículo, sube al inicio
watch(() => route.params.slug, () => window.scrollTo({ top: 0 }))
</script>

<style scoped>
.post-page { min-height: 100vh; padding: 120px 48px 80px; background: var(--white); }
.post-inner { max-width: 720px; margin: 0 auto; display: flex; flex-direction: column; gap: 18px; }
.back-link { color: var(--gray); font-size: 14px; font-weight: 500; transition: color 0.2s; display: inline-flex; align-items: center; width: fit-content; }
.back-link:hover { color: var(--blue-mid); }
.post-tag {
  display: inline-block; background: var(--yellow-light); border: 1px solid var(--yellow-warm);
  color: #92400E; font-size: 11px; font-weight: 700; letter-spacing: 1.5px; text-transform: uppercase;
  padding: 4px 14px; border-radius: 100px; width: fit-content;
}
.post-title { font-family: var(--font-display); font-size: clamp(36px, 5vw, 56px); line-height: 1.05; letter-spacing: 1px; color: var(--dark); }
.post-date { font-size: 13px; color: var(--gray); }
.post-lead { font-size: 19px; line-height: 1.6; color: var(--dark); font-weight: 500; }
.post-divider { height: 1px; background: var(--gray-light); margin: 4px 0; }

.post-content { display: flex; flex-direction: column; gap: 28px; }
.post-content section { display: flex; flex-direction: column; gap: 12px; }
.post-content h2 { font-size: 22px; font-weight: 700; color: var(--dark); letter-spacing: 0.3px; }
.post-content p { font-size: 17px; line-height: 1.8; color: var(--dark); opacity: 0.82; }

.post-nav { display: flex; flex-direction: column; gap: 8px; padding: 24px; background: var(--off-white); border-radius: 16px; margin-top: 12px; }
.post-nav-label { font-size: 12px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--gray); margin-bottom: 4px; }
.post-nav-link { color: var(--blue-mid); font-size: 15px; font-weight: 600; text-decoration: none; transition: opacity 0.2s; }
.post-nav-link:hover { opacity: 0.7; }

.post-cta {
  margin-top: 20px; background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 100%);
  border-radius: 20px; padding: 36px; display: flex; align-items: center;
  justify-content: space-between; gap: 24px; flex-wrap: wrap; box-shadow: 0 8px 32px rgba(30,58,138,0.2);
}
.post-cta-text { display: flex; flex-direction: column; gap: 6px; }
.cta-icon { font-size: 28px; margin-bottom: 4px; }
.post-cta-text p { font-size: 20px; font-weight: 700; color: var(--white); line-height: 1.3; }
.cta-sub { font-size: 14px; color: rgba(255,255,255,0.65); max-width: 360px; line-height: 1.5; }
.cta-btn {
  background: var(--yellow); color: var(--dark); padding: 13px 26px; border-radius: 100px;
  font-weight: 700; font-size: 14px; white-space: nowrap; transition: opacity 0.2s, transform 0.2s;
  flex-shrink: 0; box-shadow: 0 4px 16px rgba(245,158,11,0.35);
}
.cta-btn:hover { opacity: 0.9; transform: translateY(-1px); }

.not-found { align-items: flex-start; gap: 12px; }
.not-found h1 { font-family: var(--font-display); font-size: 40px; color: var(--dark); }

@media (max-width: 768px) {
  .post-page { padding: 100px 20px 60px; }
  .post-cta { flex-direction: column; align-items: flex-start; }
}
</style>
