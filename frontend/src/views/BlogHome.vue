<template>
  <div class="blog">
    <!-- HERO con imagen de fondo (estilo landing) -->
    <section class="blog-hero">
      <div class="hero-content animate-fadeInUp">
        <i class="fas fa-book-open hero-icon animate-bounce"></i>
        <h2>Blog ZenFit</h2>
        <p>Aprende a sacarle el máximo a la app y a tu bienestar</p>
      </div>
    </section>

    <!-- ARTÍCULO DESTACADO -->
    <section class="destacado-section">
      <div class="container">
        <router-link
          v-if="featured"
          :to="'/blog/' + featured.slug"
          class="destacado-card"
        >
          <div class="destacado-img">
            <i class="fas fa-star"></i>
          </div>
          <div class="destacado-body">
            <span class="tag">{{ featured.tag }}</span>
            <h3>{{ featured.title }}</h3>
            <p>{{ featured.excerpt }}</p>
            <span class="leer">
              <i class="fas fa-arrow-right"></i> {{ featured.readTime }} de lectura · Leer artículo
            </span>
          </div>
        </router-link>
      </div>
    </section>

    <!-- LISTA DE ARTÍCULOS -->
    <section class="articulos-section">
      <div class="container">
        <h2 class="section-title"><i class="fas fa-newspaper"></i> Todas las guías</h2>
        <p class="subtitulo">Consejos prácticos para entrenar, descansar y comer mejor</p>

        <div class="articulos-grid">
          <router-link
            v-for="p in rest"
            :key="p.slug"
            :to="'/blog/' + p.slug"
            class="articulo-card"
          >
            <div class="articulo-icon">
              <i :class="iconFor(p.tag)"></i>
            </div>
            <span class="tag">{{ p.tag }}</span>
            <h3>{{ p.title }}</h3>
            <p>{{ p.excerpt }}</p>
            <span class="leer-mini">{{ p.readTime }} · Leer →</span>
          </router-link>
        </div>
      </div>
    </section>

    <!-- CTA FINAL (estilo landing) -->
    <section class="cta-final">
      <div class="container">
        <h2><i class="fas fa-rocket"></i> Deja de leer. Empieza a hacer.</h2>
        <p>Crea tu cuenta gratis y pon en práctica todo lo que cuentan estas guías.</p>
        <router-link to="/register" class="btn-cta">
          <i class="fas fa-user-plus"></i> Crear cuenta gratis
        </router-link>
      </div>
    </section>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { blogPosts } from '../data/blogPosts'

const featured = computed(() => blogPosts.find((p) => p.featured) || blogPosts[0])
const rest = computed(() => blogPosts.filter((p) => p.slug !== featured.value.slug))

const iconFor = (tag) => ({
  'Guía': 'fas fa-compass',
  'Hábitos': 'fas fa-check-circle',
  'Descanso': 'fas fa-moon',
  'Fitness': 'fas fa-dumbbell',
  'Seguimiento': 'fas fa-chart-line',
  'Concepto': 'fas fa-lightbulb',
}[tag] || 'fas fa-book')
</script>

<style scoped>
.blog { background: white; }

/* ===== HERO ===== */
.blog-hero {
  height: 55vh;
  background: linear-gradient(rgba(0, 0, 0, 0.55), rgba(0, 0, 0, 0.55)),
      url("@/assets/ejercicio.jpg") center/cover no-repeat;
  display: flex; flex-direction: column; justify-content: center; align-items: center;
  text-align: center; padding: 20px;
}
.hero-content { color: white; }
.hero-icon { font-size: 56px; margin-bottom: 18px; color: #F2E638; display: inline-block; }
.blog-hero h2 { font-size: 44px; margin-bottom: 14px; }
.blog-hero p { font-size: 19px; opacity: 0.9; }

.container { max-width: 1100px; margin: 0 auto; }

/* ===== DESTACADO ===== */
.destacado-section { padding: 60px 50px 20px; background: white; }
.destacado-card {
  display: flex; background: white; border-radius: 24px; overflow: hidden;
  text-decoration: none; box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.destacado-card:hover { transform: translateY(-6px); box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15); }
.destacado-img {
  flex: 0 0 38%;
  background: linear-gradient(135deg, #F2E638, #e0d422);
  display: flex; align-items: center; justify-content: center;
}
.destacado-img i { font-size: 90px; color: #333; opacity: 0.85; }
.destacado-body { padding: 40px; display: flex; flex-direction: column; gap: 14px; justify-content: center; }
.destacado-body h3 { font-size: 30px; color: #333; line-height: 1.2; }
.destacado-body p { font-size: 16px; color: #555; line-height: 1.6; }
.leer { color: #333; font-weight: bold; font-size: 15px; }
.leer i { color: #F2E638; margin-right: 6px; }

/* ===== ARTÍCULOS ===== */
.articulos-section { padding: 60px 50px 80px; background: white; }
.section-title { text-align: center; color: #333; font-size: 34px; margin-bottom: 12px; }
.section-title i { color: #F2E638; margin-right: 10px; }
.subtitulo { text-align: center; color: #777; font-size: 17px; margin-bottom: 45px; }
.articulos-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 28px; }
.articulo-card {
  background: white; border: 1px solid #eee; border-radius: 20px; padding: 30px;
  text-decoration: none; display: flex; flex-direction: column; gap: 12px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 5px 20px rgba(0, 0, 0, 0.06);
}
.articulo-card:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(242, 230, 56, 0.25); border-color: #F2E638; }
.articulo-icon {
  width: 64px; height: 64px; background: #F2E638; border-radius: 50%;
  display: flex; align-items: center; justify-content: center; margin-bottom: 6px;
  transition: transform 0.3s;
}
.articulo-card:hover .articulo-icon { transform: scale(1.1) rotate(360deg); }
.articulo-icon i { font-size: 28px; color: #333; }
.tag {
  align-self: flex-start; background: #fdf9c4; color: #8a7a00;
  font-size: 11px; font-weight: 700; letter-spacing: 0.5px; text-transform: uppercase;
  padding: 4px 12px; border-radius: 100px;
}
.articulo-card h3 { color: #333; font-size: 19px; line-height: 1.3; }
.articulo-card p { color: #666; font-size: 14px; line-height: 1.6; flex: 1; }
.leer-mini { color: #333; font-weight: 700; font-size: 13px; }

/* ===== CTA FINAL ===== */
.cta-final { background: linear-gradient(135deg, #F2E638, #e0d422); padding: 70px 50px; text-align: center; }
.cta-final h2 { font-size: 34px; margin-bottom: 14px; color: #333; }
.cta-final h2 i { margin-right: 10px; }
.cta-final p { font-size: 17px; color: #555; margin-bottom: 28px; }
.btn-cta {
  display: inline-flex; align-items: center; gap: 10px; padding: 15px 35px;
  background: #333; color: #F2E638; text-decoration: none; border-radius: 50px;
  font-weight: bold; font-size: 16px; transition: all 0.3s;
}
.btn-cta:hover { background: #555; transform: translateY(-2px); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2); }

@media (max-width: 768px) {
  .blog-hero { height: 42vh; }
  .blog-hero h2 { font-size: 32px; }
  .destacado-section, .articulos-section, .cta-final { padding-left: 20px; padding-right: 20px; }
  .destacado-card { flex-direction: column; }
  .destacado-img { flex: none; min-height: 160px; }
  .destacado-body { padding: 28px; }
  .destacado-body h3 { font-size: 24px; }
  .section-title { font-size: 26px; }
}
</style>
