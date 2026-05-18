<template>
  <!-- HERO -->
  <section class="hero">
    <div class="hero-bg">
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
    </div>
    <div class="hero-content">
      <div class="hero-badge">✦ 60 días de prueba gratuita</div>
      <h1 class="hero-title">
        SHAPE<br/>
        <span class="hero-accent">YOUR BEST</span><br/>
        SELF
      </h1>
      <p class="hero-desc">
        Sueño optimizado, nutrición inteligente y entrenamientos adaptados.<br/>
        Todo en una app. Empieza hoy, sin excusas.
      </p>
      <div class="hero-actions">
        <router-link to="/register" class="cta-primary">Empieza gratis →</router-link>
        <router-link to="/dashboard" class="cta-secondary">Ver demo</router-link>
      </div>
      <div class="hero-stats">
        <div class="stat-item">
          <span class="stat-number">50K+</span>
          <span class="stat-label">Usuarios activos</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">4.8★</span>
          <span class="stat-label">App Store</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">3M+</span>
          <span class="stat-label">Entrenamientos</span>
        </div>
      </div>
    </div>

    <!-- Phone mockup -->
    <div class="hero-visual">
      <div class="phone-frame">
        <div class="phone-screen">
          <div class="phone-topbar">
            <span class="phone-time">09:41</span>
          </div>
          <div class="phone-greeting">Buenos días, Hugo 👋</div>
          <div class="phone-card">
            <div class="phone-card-label">Objetivo del día</div>
            <div class="phone-progress-ring">
              <svg viewBox="0 0 80 80">
                <circle cx="40" cy="40" r="32" fill="none" stroke="rgba(30,58,138,0.1)" stroke-width="6"/>
                <circle cx="40" cy="40" r="32" fill="none" stroke="#F59E0B" stroke-width="6"
                  stroke-dasharray="201" stroke-dashoffset="50" stroke-linecap="round"
                  transform="rotate(-90 40 40)"/>
              </svg>
              <span>75%</span>
            </div>
          </div>
          <div class="phone-metrics">
            <div class="phone-metric"><span class="pm-val">1.840</span><span class="pm-lab">kcal</span></div>
            <div class="phone-metric"><span class="pm-val">7h 20'</span><span class="pm-lab">sueño</span></div>
            <div class="phone-metric"><span class="pm-val">8.200</span><span class="pm-lab">pasos</span></div>
          </div>
          <div class="phone-exercise">
            <div class="pe-label">Siguiente ejercicio</div>
            <div class="pe-name">Push Ups · 6×10</div>
            <div class="pe-btn">▶ Iniciar</div>
          </div>
        </div>
        <div class="phone-notch"></div>
      </div>
      <div class="phone-glow"></div>
    </div>
  </section>

  <!-- FEATURES -->
  <section class="features">
    <div class="section-inner">
      <div class="section-label">Funcionalidades</div>
      <h2 class="section-title">Todo lo que necesitas<br/><span class="accent">en un solo lugar</span></h2>

      <div class="features-grid">
        <div class="feature-card" v-for="f in features" :key="f.title">
          <div class="feature-icon-wrap">
            <span class="feature-icon">{{ f.icon }}</span>
          </div>
          <h3>{{ f.title }}</h3>
          <p>{{ f.desc }}</p>
          <a href="#" class="feature-link">Saber más →</a>
        </div>
      </div>
    </div>
  </section>

  <!-- BLOG -->
  <section class="blog-section">
    <div class="section-inner">
      <div class="section-label">Blog ZenFit</div>
      <h2 class="section-title">Aprende a vivir<br/><span class="accent">más saludable</span></h2>

      <div class="posts-grid">
        <div class="post-card featured" v-if="posts[0]">
          <div class="post-img featured-img">
            <div class="img-overlay"></div>
            <div class="post-tag">{{ posts[0].tag }}</div>
          </div>
          <div class="post-body">
            <h3>{{ posts[0].title }}</h3>
            <p>{{ posts[0].excerpt }}</p>
            <router-link :to="'/post/' + posts[0].id" class="post-link">Leer artículo →</router-link>
          </div>
        </div>
        <div class="posts-side">
          <div class="post-card small" v-for="post in posts.slice(1)" :key="post.id">
            <div class="post-img small-img">
              <div class="img-overlay"></div>
              <div class="post-tag">{{ post.tag }}</div>
            </div>
            <div class="post-body">
              <h3>{{ post.title }}</h3>
              <p>{{ post.excerpt }}</p>
              <router-link :to="'/post/' + post.id" class="post-link">Leer →</router-link>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- CTA BANNER -->
  <section class="cta-section">
    <div class="cta-inner">
      <div class="cta-badge">☀️ 60 días gratis</div>
      <h2 class="cta-title">Empieza tu transformación hoy</h2>
      <p class="cta-desc">Sin tarjeta de crédito. Sin compromisos. Solo resultados.</p>
      <router-link to="/register" class="cta-btn-yellow large">Crear cuenta gratis →</router-link>
      <div class="cta-stores">
        <span>Disponible en</span>
        <span class="store-tag">iOS</span>
        <span class="store-tag">Android</span>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'

const features = ref([
  {
    icon: '🌙',
    title: 'Sueño inteligente',
    desc: 'Analiza tus ciclos de sueño y despiértate en tu fase más ligera para empezar el día con energía.'
  },
  {
    icon: '🥗',
    title: 'Dieta personalizada',
    desc: 'Planes de nutrición adaptados a tu objetivo: perder peso, ganar músculo o mantenerte.'
  },
  {
    icon: '💪',
    title: 'Entrenos adaptados',
    desc: 'Rutinas diseñadas según tu nivel y disponibilidad. Desde 10 minutos diarios hasta sesiones completas.'
  },
  {
    icon: '📊',
    title: 'Seguimiento total',
    desc: 'Visualiza tu progreso día a día. Calorías, pasos, peso y horas de sueño en un solo dashboard.'
  },
  {
    icon: '🔔',
    title: 'Recordatorios',
    desc: 'Notificaciones inteligentes que te ayudan a mantener la constancia sin agobiarte.'
  },
  {
    icon: '🔒',
    title: 'Datos seguros',
    desc: 'Tu información personal y de salud está cifrada y nunca se comparte con terceros.'
  }
])

const posts = ref([
  {
    id: 1,
    tag: 'Fitness',
    title: 'Cómo empezar en el fitness sin morir en el intento',
    excerpt: 'Los primeros pasos para mejorar tu salud no tienen que ser radicales. Pequeños cambios sostenidos marcan la diferencia a largo plazo.'
  },
  {
    id: 2,
    tag: 'Nutrición',
    title: 'Alimentación saludable: mitos y realidades',
    excerpt: 'Desmontamos los 5 mitos más comunes sobre la dieta sana y te contamos qué dice la ciencia de verdad.'
  },
  {
    id: 3,
    tag: 'Sueño',
    title: 'Por qué dormir bien cambia todo',
    excerpt: 'El sueño es el pilar más infravalorado de la salud. Descubre cómo optimizarlo con pequeños hábitos nocturnos.'
  }
])
</script>

<style scoped>
/* ── HERO ── */
.hero {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  padding: 120px 48px 80px;
  gap: 60px;
  overflow: hidden;
  background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 50%, #EFF6FF 100%);
}

.hero-bg {
  position: absolute;
  inset: 0;
  z-index: 0;
  pointer-events: none;
}
.blob {
  position: absolute;
  border-radius: 50%;
  filter: blur(90px);
  opacity: 0.25;
}
.blob-1 {
  width: 500px; height: 500px;
  background: #DBEAFE;
  top: -150px; left: -100px;
}
.blob-2 {
  width: 400px; height: 400px;
  background: #FDE68A;
  bottom: -80px; right: 80px;
}

.hero-content {
  position: relative;
  z-index: 1;
  flex: 1;
  max-width: 560px;
}

.hero-badge {
  display: inline-block;
  background: var(--yellow-light);
  border: 1px solid #FDE68A;
  color: #92400E;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 1px;
  text-transform: uppercase;
  padding: 6px 16px;
  border-radius: 100px;
  margin-bottom: 28px;
}

.hero-title {
  font-family: var(--font-display);
  font-size: clamp(64px, 8vw, 108px);
  line-height: 0.92;
  letter-spacing: 2px;
  color: var(--blue);
  margin-bottom: 28px;
}
.hero-accent { color: var(--yellow); }

.hero-desc {
  font-size: 17px;
  line-height: 1.7;
  color: var(--gray);
  margin-bottom: 36px;
}

.hero-actions { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 48px; }

.cta-primary {
  background: var(--blue);
  color: var(--white);
  padding: 14px 28px;
  border-radius: 100px;
  font-weight: 700;
  font-size: 15px;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  transition: transform 0.2s, opacity 0.2s;
  box-shadow: 0 4px 16px rgba(30,58,138,0.25);
}
.cta-primary:hover { transform: translateY(-2px); opacity: 0.92; }

.cta-secondary {
  background: var(--white);
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 14px 28px;
  border-radius: 100px;
  font-weight: 500;
  font-size: 15px;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.cta-secondary:hover { border-color: var(--blue-mid); box-shadow: 0 2px 8px rgba(30,58,138,0.1); }

.hero-stats { display: flex; align-items: center; gap: 28px; }
.stat-item { display: flex; flex-direction: column; gap: 2px; }
.stat-number { font-family: var(--font-display); font-size: 28px; color: var(--blue); letter-spacing: 1px; }
.stat-label { font-size: 11px; color: var(--gray); letter-spacing: 0.5px; text-transform: uppercase; }
.stat-divider { width: 1px; height: 36px; background: var(--gray-light); }

/* Phone mockup */
.hero-visual {
  position: relative;
  z-index: 1;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
}
.phone-frame {
  width: 280px;
  height: 560px;
  background: var(--white);
  border-radius: 40px;
  border: 2px solid var(--blue-pale);
  overflow: hidden;
  position: relative;
  box-shadow: 0 40px 80px rgba(30,58,138,0.18), 0 8px 24px rgba(30,58,138,0.1);
}
.phone-notch {
  position: absolute;
  top: 12px;
  left: 50%;
  transform: translateX(-50%);
  width: 80px; height: 22px;
  background: var(--off-white);
  border-radius: 20px;
  z-index: 10;
}
.phone-screen {
  padding: 48px 20px 20px;
  height: 100%;
  display: flex;
  flex-direction: column;
  gap: 14px;
  background: var(--off-white);
}
.phone-topbar { text-align: right; }
.phone-time { font-size: 11px; color: var(--gray); }
.phone-greeting { font-size: 14px; font-weight: 600; color: var(--dark); }
.phone-card {
  background: var(--white);
  border-radius: 16px;
  padding: 16px;
  border: 1px solid var(--blue-pale);
  display: flex;
  align-items: center;
  gap: 16px;
  box-shadow: 0 2px 8px rgba(30,58,138,0.06);
}
.phone-card-label { font-size: 11px; color: var(--gray); flex: 1; }
.phone-progress-ring {
  position: relative;
  width: 56px; height: 56px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.phone-progress-ring svg { position: absolute; inset: 0; width: 100%; height: 100%; }
.phone-progress-ring span { font-size: 13px; font-weight: 700; color: var(--yellow); position: relative; z-index: 1; }
.phone-metrics {
  display: flex;
  justify-content: space-between;
  background: var(--white);
  border-radius: 12px;
  padding: 12px;
  border: 1px solid var(--gray-light);
}
.phone-metric { display: flex; flex-direction: column; align-items: center; gap: 2px; }
.pm-val { font-size: 13px; font-weight: 700; color: var(--dark); }
.pm-lab { font-size: 9px; color: var(--gray); text-transform: uppercase; letter-spacing: 0.5px; }
.phone-exercise {
  background: var(--blue);
  border-radius: 14px;
  padding: 14px;
  color: var(--white);
}
.pe-label { font-size: 10px; font-weight: 600; letter-spacing: 0.8px; text-transform: uppercase; opacity: 0.7; }
.pe-name { font-size: 14px; font-weight: 700; margin: 4px 0 10px; }
.pe-btn {
  display: inline-block;
  background: var(--yellow);
  color: var(--dark);
  font-size: 11px;
  font-weight: 700;
  padding: 6px 14px;
  border-radius: 100px;
}
.phone-glow {
  position: absolute;
  width: 300px; height: 300px;
  background: radial-gradient(circle, rgba(245,158,11,0.2) 0%, transparent 70%);
  border-radius: 50%;
  bottom: -80px;
  left: 50%;
  transform: translateX(-50%);
  pointer-events: none;
}

/* ── FEATURES ── */
.features {
  padding: 100px 48px;
  background: var(--white);
}
.section-inner { max-width: 1200px; margin: 0 auto; }
.section-label {
  font-size: 11px;
  font-weight: 700;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: var(--yellow);
  margin-bottom: 16px;
}
.section-title {
  font-family: var(--font-display);
  font-size: clamp(36px, 5vw, 56px);
  line-height: 1.05;
  letter-spacing: 1px;
  color: var(--dark);
  margin-bottom: 56px;
}
.accent { color: var(--blue); }

.features-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
}
.feature-card {
  background: var(--white);
  border: 1px solid var(--gray-light);
  border-radius: 20px;
  padding: 32px 28px;
  transition: border-color 0.3s, transform 0.3s, box-shadow 0.3s;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.feature-card:hover {
  border-color: var(--blue-pale);
  transform: translateY(-4px);
  box-shadow: 0 12px 32px rgba(30,58,138,0.1);
}
.feature-icon-wrap {
  width: 52px; height: 52px;
  background: var(--blue-light);
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}
.feature-icon { font-size: 26px; }
.feature-card h3 {
  font-size: 17px;
  font-weight: 600;
  color: var(--dark);
}
.feature-card p { font-size: 14px; line-height: 1.7; color: var(--gray); flex: 1; }
.feature-link { font-size: 13px; color: var(--blue-mid); font-weight: 600; margin-top: auto; transition: opacity 0.2s; }
.feature-link:hover { opacity: 0.75; }

/* ── BLOG ── */
.blog-section {
  padding: 100px 48px;
  background: var(--off-white);
}

.posts-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; }
.posts-side { display: flex; flex-direction: column; gap: 24px; }

.post-card {
  background: var(--white);
  border: 1px solid var(--gray-light);
  border-radius: 20px;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  transition: box-shadow 0.3s, transform 0.3s;
}
.post-card:hover { box-shadow: 0 12px 32px rgba(30,58,138,0.1); transform: translateY(-3px); }

.post-img {
  position: relative;
  overflow: hidden;
}
.featured-img {
  height: 220px;
  background: linear-gradient(135deg, #1E3A8A 0%, #2563EB 50%, #1D4ED8 100%);
}
.small-img {
  height: 120px;
  background: linear-gradient(135deg, #DBEAFE 0%, #EFF6FF 100%);
}
.post-card:nth-child(2) .small-img { background: linear-gradient(135deg, #FEF3C7 0%, #FFFBEB 100%); }
.img-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(30,58,138,0.15) 0%, transparent 60%);
}

.post-tag {
  position: absolute;
  top: 16px;
  left: 16px;
  display: inline-block;
  background: var(--yellow);
  color: var(--dark);
  font-size: 10px;
  font-weight: 700;
  letter-spacing: 1px;
  text-transform: uppercase;
  padding: 4px 12px;
  border-radius: 100px;
}
.post-body {
  padding: 24px;
  display: flex;
  flex-direction: column;
  gap: 10px;
  flex: 1;
}
.post-card.featured .post-body { padding: 28px; }
.post-card h3 {
  font-size: 20px;
  font-weight: 600;
  color: var(--dark);
  line-height: 1.3;
}
.post-card.small h3 { font-size: 16px; }
.post-card p { font-size: 14px; color: var(--gray); line-height: 1.6; flex: 1; }
.post-link {
  color: var(--blue-mid);
  font-size: 13px;
  font-weight: 600;
  text-decoration: none;
  margin-top: auto;
  transition: opacity 0.2s;
}
.post-link:hover { opacity: 0.7; }

/* ── CTA ── */
.cta-section {
  padding: 100px 48px;
  background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%);
}
.cta-inner {
  max-width: 640px;
  margin: 0 auto;
  text-align: center;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}
.cta-badge {
  background: rgba(245,158,11,0.2);
  border: 1px solid rgba(245,158,11,0.4);
  color: var(--yellow-warm);
  font-size: 12px;
  font-weight: 800;
  letter-spacing: 1px;
  text-transform: uppercase;
  padding: 6px 18px;
  border-radius: 100px;
}
.cta-title {
  font-family: var(--font-display);
  font-size: clamp(40px, 6vw, 64px);
  letter-spacing: 1px;
  line-height: 1;
  color: var(--white);
}
.cta-desc { font-size: 16px; color: rgba(255,255,255,0.7); line-height: 1.6; }
.cta-btn-yellow {
  background: var(--yellow);
  color: var(--dark);
  padding: 14px 28px;
  border-radius: 100px;
  font-weight: 700;
  font-size: 15px;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
  transition: transform 0.2s, opacity 0.2s;
  box-shadow: 0 4px 20px rgba(245,158,11,0.35);
}
.cta-btn-yellow:hover { transform: translateY(-2px); opacity: 0.92; }
.cta-btn-yellow.large { padding: 16px 36px; font-size: 16px; }
.cta-stores { display: flex; align-items: center; gap: 10px; font-size: 13px; color: rgba(255,255,255,0.55); margin-top: 8px; }
.store-tag {
  background: rgba(255,255,255,0.12);
  border: 1px solid rgba(255,255,255,0.2);
  color: rgba(255,255,255,0.8);
  padding: 4px 12px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 600;
}

@media (max-width: 1024px) {
  .features-grid { grid-template-columns: repeat(2, 1fr); }
}

@media (max-width: 768px) {
  .hero { flex-direction: column; padding: 100px 20px 60px; align-items: flex-start; }
  .hero-visual { width: 100%; display: flex; justify-content: center; }
  .features, .blog-section, .cta-section { padding: 60px 20px; }
  .features-grid { grid-template-columns: 1fr; }
  .posts-grid { grid-template-columns: 1fr; }
  .hero-stats { flex-wrap: wrap; gap: 20px; }
}
</style>
