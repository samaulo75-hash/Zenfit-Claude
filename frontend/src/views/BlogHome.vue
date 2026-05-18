<template>
  <div class="blog">
    <header class="blog-hero">
      <div class="blog-hero-inner">
        <div class="section-label">Blog ZenFit</div>
        <h1 class="blog-title">Aprende a sacarle<br/><span class="accent">el máximo a ZenFit</span></h1>
        <p class="blog-sub">
          Guías claras sobre cómo usar la app, para qué sirve cada módulo y cómo
          puede ayudarte a construir hábitos y mejorar tu bienestar.
        </p>
      </div>
    </header>

    <section class="blog-body">
      <div class="blog-inner">
        <!-- Artículo destacado -->
        <router-link
          v-if="featured"
          :to="'/blog/' + featured.slug"
          class="post-card featured"
        >
          <div class="post-img featured-img">
            <div class="img-overlay"></div>
            <span class="post-tag">{{ featured.tag }}</span>
          </div>
          <div class="post-body">
            <h2>{{ featured.title }}</h2>
            <p>{{ featured.excerpt }}</p>
            <span class="post-meta">{{ featured.readTime }} de lectura · Leer artículo →</span>
          </div>
        </router-link>

        <!-- Resto de artículos -->
        <div class="posts-grid">
          <router-link
            v-for="p in rest"
            :key="p.slug"
            :to="'/blog/' + p.slug"
            class="post-card"
          >
            <div class="post-img">
              <div class="img-overlay"></div>
              <span class="post-tag">{{ p.tag }}</span>
            </div>
            <div class="post-body">
              <h3>{{ p.title }}</h3>
              <p>{{ p.excerpt }}</p>
              <span class="post-meta">{{ p.readTime }} · Leer →</span>
            </div>
          </router-link>
        </div>
      </div>
    </section>

    <section class="blog-cta">
      <div class="cta-inner">
        <h2 class="cta-title">Deja de leer. Empieza a hacer.</h2>
        <p class="cta-desc">Crea tu cuenta gratis y pon en práctica todo lo que cuentan estas guías.</p>
        <router-link to="/register" class="cta-btn">Crear cuenta gratis →</router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { blogPosts } from '../data/blogPosts'

const featured = computed(() => blogPosts.find((p) => p.featured) || blogPosts[0])
const rest = computed(() => blogPosts.filter((p) => p.slug !== featured.value.slug))
</script>

<style scoped>
.blog { background: var(--white); }

.blog-hero {
  padding: 140px 48px 70px;
  background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 50%, #EFF6FF 100%);
}
.blog-hero-inner { max-width: 1100px; margin: 0 auto; }
.section-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 16px; }
.blog-title { font-family: var(--font-display); font-size: clamp(40px, 6vw, 68px); line-height: 1.02; letter-spacing: 1px; color: var(--blue); margin-bottom: 20px; }
.accent { color: var(--yellow); }
.blog-sub { font-size: 17px; line-height: 1.7; color: var(--gray); max-width: 540px; }

.blog-body { padding: 70px 48px 100px; }
.blog-inner { max-width: 1100px; margin: 0 auto; display: flex; flex-direction: column; gap: 28px; }

.post-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 20px;
  overflow: hidden; text-decoration: none; display: flex; flex-direction: column;
  transition: box-shadow 0.3s, transform 0.3s, border-color 0.3s;
}
.post-card:hover { box-shadow: 0 12px 32px rgba(30,58,138,0.1); transform: translateY(-3px); border-color: var(--blue-pale); }

.post-card.featured { flex-direction: row; }
.post-img { position: relative; overflow: hidden; background: linear-gradient(135deg, #DBEAFE 0%, #EFF6FF 100%); height: 160px; }
.featured-img { height: auto; min-height: 260px; flex: 0 0 45%; background: linear-gradient(135deg, #1E3A8A 0%, #2563EB 50%, #1D4ED8 100%); }
.img-overlay { position: absolute; inset: 0; background: linear-gradient(to top, rgba(30,58,138,0.15) 0%, transparent 60%); }
.post-tag {
  position: absolute; top: 16px; left: 16px; background: var(--yellow); color: var(--dark);
  font-size: 10px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase;
  padding: 4px 12px; border-radius: 100px;
}
.post-body { padding: 24px; display: flex; flex-direction: column; gap: 10px; flex: 1; }
.post-card.featured .post-body { padding: 36px; justify-content: center; }
.post-card.featured h2 { font-family: var(--font-display); font-size: 32px; letter-spacing: 0.5px; color: var(--dark); line-height: 1.1; }
.post-card h3 { font-size: 18px; font-weight: 600; color: var(--dark); line-height: 1.3; }
.post-card p { font-size: 14px; color: var(--gray); line-height: 1.6; flex: 1; }
.post-meta { font-size: 13px; color: var(--blue-mid); font-weight: 600; margin-top: auto; }

.posts-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }

.blog-cta { padding: 90px 48px; background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%); }
.cta-inner { max-width: 600px; margin: 0 auto; text-align: center; display: flex; flex-direction: column; align-items: center; gap: 18px; }
.cta-title { font-family: var(--font-display); font-size: clamp(36px, 5vw, 54px); letter-spacing: 1px; line-height: 1; color: var(--white); }
.cta-desc { font-size: 16px; color: rgba(255,255,255,0.7); line-height: 1.6; }
.cta-btn { background: var(--yellow); color: var(--dark); padding: 15px 32px; border-radius: 100px; font-weight: 700; font-size: 15px; text-decoration: none; transition: transform 0.2s, opacity 0.2s; box-shadow: 0 4px 20px rgba(245,158,11,0.35); }
.cta-btn:hover { transform: translateY(-2px); opacity: 0.92; }

@media (max-width: 1024px) {
  .posts-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .blog-hero { padding: 110px 20px 50px; }
  .blog-body { padding: 50px 20px 70px; }
  .blog-cta { padding: 60px 20px; }
  .post-card.featured { flex-direction: column; }
  .featured-img { flex: none; min-height: 180px; }
  .posts-grid { grid-template-columns: 1fr; }
}
</style>
