<template>
  <div class="post-page" v-if="post">
    <!-- Cabecera del artículo -->
    <header class="post-hero">
      <div class="post-hero-inner">
        <router-link to="/blog" class="back-link">
          <i class="fas fa-arrow-left"></i> Volver al blog
        </router-link>
        <span class="tag">{{ post.tag }}</span>
        <h1>{{ post.title }}</h1>
        <p class="meta"><i class="fas fa-clock"></i> {{ post.readTime }} de lectura · ZenFit</p>
      </div>
    </header>

    <article class="post-body">
      <div class="container">
        <p class="lead">{{ post.excerpt }}</p>

        <section v-for="(s, i) in post.sections" :key="i" class="post-section">
          <h2><span class="acento"></span>{{ s.heading }}</h2>
          <p v-for="(p, j) in s.paragraphs" :key="j">{{ p }}</p>
        </section>

        <!-- Sigue leyendo -->
        <div class="related" v-if="related.length">
          <h3><i class="fas fa-book-open"></i> Sigue leyendo</h3>
          <div class="related-grid">
            <router-link
              v-for="r in related"
              :key="r.slug"
              :to="'/blog/' + r.slug"
              class="related-card"
            >
              <span class="tag">{{ r.tag }}</span>
              <span class="related-title">{{ r.title }}</span>
              <span class="related-leer">Leer <i class="fas fa-arrow-right"></i></span>
            </router-link>
          </div>
        </div>
      </div>
    </article>

    <!-- CTA final -->
    <section class="cta-final">
      <div class="container">
        <h2><i class="fas fa-rocket"></i> ¿Listo para ponerlo en práctica?</h2>
        <p>Crea tu cuenta gratis y empieza a usar ZenFit ahora mismo.</p>
        <router-link to="/register" class="btn-cta">
          <i class="fas fa-user-plus"></i> Únete gratis
        </router-link>
      </div>
    </section>
  </div>

  <div class="post-page not-found" v-else>
    <div class="container">
      <i class="fas fa-compass nf-icon"></i>
      <h1>Artículo no encontrado</h1>
      <p>Puede que el enlace haya cambiado.</p>
      <router-link to="/blog" class="btn-cta dark">
        <i class="fas fa-arrow-left"></i> Volver al blog
      </router-link>
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

watch(() => route.params.slug, () => window.scrollTo({ top: 0 }))
</script>

<style scoped>
.post-page { background: white; }
.container { max-width: 760px; margin: 0 auto; }

/* ===== HERO ===== */
.post-hero {
  background: linear-gradient(135deg, #F2E638, #e0d422);
  padding: 50px 50px 60px;
}
.post-hero-inner { max-width: 760px; margin: 0 auto; }
.back-link {
  display: inline-flex; align-items: center; gap: 8px;
  color: #333; font-weight: 600; font-size: 14px; text-decoration: none;
  margin-bottom: 24px; opacity: 0.8; transition: opacity 0.2s;
}
.back-link:hover { opacity: 1; }
.tag {
  display: inline-block; background: #333; color: #F2E638;
  font-size: 11px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase;
  padding: 5px 14px; border-radius: 100px; margin-bottom: 16px;
}
.post-hero h1 { font-size: 40px; color: #333; line-height: 1.15; margin-bottom: 14px; }
.meta { font-size: 14px; color: #555; }
.meta i { margin-right: 6px; }

/* ===== CUERPO ===== */
.post-body { padding: 55px 50px 70px; }
.lead {
  font-size: 20px; line-height: 1.6; color: #333; font-weight: 500;
  padding-bottom: 28px; margin-bottom: 28px; border-bottom: 2px solid #f0f0f0;
}
.post-section { margin-bottom: 36px; }
.post-section h2 {
  display: flex; align-items: center; gap: 12px;
  font-size: 24px; color: #333; margin-bottom: 16px;
}
.acento { width: 6px; height: 26px; background: #F2E638; border-radius: 4px; display: inline-block; }
.post-section p { font-size: 17px; line-height: 1.8; color: #555; margin-bottom: 14px; }

/* ===== SIGUE LEYENDO ===== */
.related { margin-top: 50px; padding-top: 36px; border-top: 2px solid #f0f0f0; }
.related h3 { font-size: 20px; color: #333; margin-bottom: 20px; }
.related h3 i { color: #F2E638; margin-right: 8px; }
.related-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; }
.related-card {
  background: #f8f9fa; border: 1px solid #eee; border-radius: 16px; padding: 22px;
  text-decoration: none; display: flex; flex-direction: column; gap: 10px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.related-card:hover { transform: translateY(-4px); border-color: #F2E638; box-shadow: 0 12px 28px rgba(242, 230, 56, 0.25); }
.related-title { font-size: 16px; font-weight: 600; color: #333; line-height: 1.35; }
.related-leer { font-size: 13px; font-weight: 700; color: #333; }
.related-leer i { color: #F2E638; }

/* ===== CTA ===== */
.cta-final { background: #1f2937; padding: 60px 50px; text-align: center; }
.cta-final .container { display: flex; flex-direction: column; align-items: center; gap: 14px; }
.cta-final h2 { font-size: 28px; color: white; }
.cta-final h2 i { color: #F2E638; margin-right: 8px; }
.cta-final p { font-size: 16px; color: rgba(255, 255, 255, 0.7); }
.btn-cta {
  display: inline-flex; align-items: center; gap: 10px; padding: 14px 32px;
  background: #F2E638; color: #333; text-decoration: none; border-radius: 50px;
  font-weight: bold; font-size: 16px; transition: all 0.3s; margin-top: 8px;
}
.btn-cta:hover { background: #e0d422; transform: translateY(-2px); box-shadow: 0 10px 22px rgba(242, 230, 56, 0.4); }
.btn-cta.dark { background: #333; color: #F2E638; }
.btn-cta.dark:hover { background: #555; }

/* ===== NOT FOUND ===== */
.not-found .container { text-align: center; padding: 100px 20px; display: flex; flex-direction: column; align-items: center; gap: 14px; }
.nf-icon { font-size: 64px; color: #F2E638; margin-bottom: 10px; }
.not-found h1 { font-size: 32px; color: #333; }
.not-found p { color: #777; }

@media (max-width: 768px) {
  .post-hero { padding: 40px 20px 50px; }
  .post-hero h1 { font-size: 30px; }
  .post-body { padding: 40px 20px 50px; }
  .cta-final { padding: 50px 20px; }
  .related-grid { grid-template-columns: 1fr; }
}
</style>
