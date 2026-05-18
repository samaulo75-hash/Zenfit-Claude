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
        Sueño optimizado, hábitos inteligentes y entrenamientos adaptados.<br/>
        Todo en una app. Empieza hoy, sin excusas.
      </p>
      <div class="hero-actions">
        <router-link to="/register" class="cta-primary">Empieza gratis →</router-link>
        <router-link to="/blog" class="cta-secondary">Cómo funciona</router-link>
      </div>
      <div class="hero-stats">
        <div class="stat-item">
          <span class="stat-number">50K+</span>
          <span class="stat-label">Usuarios activos</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">4.8★</span>
          <span class="stat-label">Valoración</span>
        </div>
        <div class="stat-divider"></div>
        <div class="stat-item">
          <span class="stat-number">3M+</span>
          <span class="stat-label">Entrenamientos</span>
        </div>
      </div>
    </div>

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
        </div>
      </div>
    </div>
  </section>

  <!-- BLOG TEASER -->
  <section class="blog-teaser">
    <div class="section-inner teaser-inner">
      <div>
        <div class="section-label">Blog ZenFit</div>
        <h2 class="section-title">¿No sabes por dónde<br/><span class="accent">empezar?</span></h2>
        <p class="teaser-desc">
          En nuestro blog te explicamos paso a paso cómo usar ZenFit, para qué sirve cada
          módulo y cómo puede ayudarte a construir una versión más sana de ti.
        </p>
        <router-link to="/blog" class="cta-primary">Ir al blog →</router-link>
      </div>
      <div class="teaser-cards">
        <router-link
          v-for="p in teaserPosts"
          :key="p.slug"
          :to="'/blog/' + p.slug"
          class="teaser-card"
        >
          <span class="tc-tag">{{ p.tag }}</span>
          <h3>{{ p.title }}</h3>
          <span class="tc-link">Leer →</span>
        </router-link>
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
    </div>
  </section>
</template>

<script setup>
import { ref } from 'vue'
import { blogPosts } from '../data/blogPosts'

const teaserPosts = blogPosts.slice(0, 3)

const features = ref([
  { icon: '🌙', title: 'Sueño inteligente', desc: 'Registra tu descanso y entiende cómo afecta a tu energía y tu rendimiento diario.' },
  { icon: '✅', title: 'Hábitos con racha', desc: 'Crea hábitos, márcalos cada día y construye rachas que te mantienen constante.' },
  { icon: '💪', title: 'Entrenos adaptados', desc: 'Rutinas listas para todos los niveles. Desde 10 minutos hasta sesiones completas.' },
  { icon: '📊', title: 'Seguimiento total', desc: 'Tu progreso real en un dashboard: entrenos, hábitos, sueño y rachas en tiempo real.' },
  { icon: '🧘', title: 'Bienestar integral', desc: 'Fitness, descanso y salud mental conectados, porque se influyen entre sí.' },
  { icon: '🔒', title: 'Datos seguros', desc: 'Tu información se guarda cifrada y autenticada. Tu bienestar es solo tuyo.' },
])
</script>

<style scoped>
.hero {
  position: relative; min-height: 100vh; display: flex; align-items: center;
  padding: 120px 48px 80px; gap: 60px; overflow: hidden;
  background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 50%, #EFF6FF 100%);
}
.hero-bg { position: absolute; inset: 0; z-index: 0; pointer-events: none; }
.blob { position: absolute; border-radius: 50%; filter: blur(90px); opacity: 0.25; }
.blob-1 { width: 500px; height: 500px; background: #DBEAFE; top: -150px; left: -100px; }
.blob-2 { width: 400px; height: 400px; background: #FDE68A; bottom: -80px; right: 80px; }
.hero-content { position: relative; z-index: 1; flex: 1; max-width: 560px; }
.hero-badge {
  display: inline-block; background: var(--yellow-light); border: 1px solid #FDE68A;
  color: #92400E; font-size: 12px; font-weight: 600; letter-spacing: 1px;
  text-transform: uppercase; padding: 6px 16px; border-radius: 100px; margin-bottom: 28px;
}
.hero-title { font-family: var(--font-display); font-size: clamp(64px, 8vw, 108px); line-height: 0.92; letter-spacing: 2px; color: var(--blue); margin-bottom: 28px; }
.hero-accent { color: var(--yellow); }
.hero-desc { font-size: 17px; line-height: 1.7; color: var(--gray); margin-bottom: 36px; }
.hero-actions { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 48px; }
.cta-primary {
  background: var(--blue); color: var(--white); padding: 14px 28px; border-radius: 100px;
  font-weight: 700; font-size: 15px; text-decoration: none; display: inline-flex; align-items: center;
  transition: transform 0.2s, opacity 0.2s; box-shadow: 0 4px 16px rgba(30,58,138,0.25);
}
.cta-primary:hover { transform: translateY(-2px); opacity: 0.92; }
.cta-secondary {
  background: var(--white); border: 1px solid var(--gray-light); color: var(--dark);
  padding: 14px 28px; border-radius: 100px; font-weight: 500; font-size: 15px;
  text-decoration: none; display: inline-flex; align-items: center;
  transition: border-color 0.2s, box-shadow 0.2s;
}
.cta-secondary:hover { border-color: var(--blue-mid); box-shadow: 0 2px 8px rgba(30,58,138,0.1); }
.hero-stats { display: flex; align-items: center; gap: 28px; }
.stat-item { display: flex; flex-direction: column; gap: 2px; }
.stat-number { font-family: var(--font-display); font-size: 28px; color: var(--blue); letter-spacing: 1px; }
.stat-label { font-size: 11px; color: var(--gray); letter-spacing: 0.5px; text-transform: uppercase; }
.stat-divider { width: 1px; height: 36px; background: var(--gray-light); }
.hero-visual { position: relative; z-index: 1; flex-shrink: 0; display: flex; align-items: center; justify-content: center; }
.phone-frame {
  width: 280px; height: 560px; background: var(--white); border-radius: 40px;
  border: 2px solid var(--blue-pale); overflow: hidden; position: relative;
  box-shadow: 0 40px 80px rgba(30,58,138,0.18), 0 8px 24px rgba(30,58,138,0.1);
}
.phone-notch { position: absolute; top: 12px; left: 50%; transform: translateX(-50%); width: 80px; height: 22px; background: var(--off-white); border-radius: 20px; z-index: 10; }
.phone-screen { padding: 48px 20px 20px; height: 100%; display: flex; flex-direction: column; gap: 14px; background: var(--off-white); }
.phone-topbar { text-align: right; }
.phone-time { font-size: 11px; color: var(--gray); }
.phone-greeting { font-size: 14px; font-weight: 600; color: var(--dark); }
.phone-card { background: var(--white); border-radius: 16px; padding: 16px; border: 1px solid var(--blue-pale); display: flex; align-items: center; gap: 16px; box-shadow: 0 2px 8px rgba(30,58,138,0.06); }
.phone-card-label { font-size: 11px; color: var(--gray); flex: 1; }
.phone-progress-ring { position: relative; width: 56px; height: 56px; display: flex; align-items: center; justify-content: center; }
.phone-progress-ring svg { position: absolute; inset: 0; width: 100%; height: 100%; }
.phone-progress-ring span { font-size: 13px; font-weight: 700; color: var(--yellow); position: relative; z-index: 1; }
.phone-metrics { display: flex; justify-content: space-between; background: var(--white); border-radius: 12px; padding: 12px; border: 1px solid var(--gray-light); }
.phone-metric { display: flex; flex-direction: column; align-items: center; gap: 2px; }
.pm-val { font-size: 13px; font-weight: 700; color: var(--dark); }
.pm-lab { font-size: 9px; color: var(--gray); text-transform: uppercase; letter-spacing: 0.5px; }
.phone-exercise { background: var(--blue); border-radius: 14px; padding: 14px; color: var(--white); }
.pe-label { font-size: 10px; font-weight: 600; letter-spacing: 0.8px; text-transform: uppercase; opacity: 0.7; }
.pe-name { font-size: 14px; font-weight: 700; margin: 4px 0 10px; }
.pe-btn { display: inline-block; background: var(--yellow); color: var(--dark); font-size: 11px; font-weight: 700; padding: 6px 14px; border-radius: 100px; }
.phone-glow { position: absolute; width: 300px; height: 300px; background: radial-gradient(circle, rgba(245,158,11,0.2) 0%, transparent 70%); border-radius: 50%; bottom: -80px; left: 50%; transform: translateX(-50%); pointer-events: none; }

.features { padding: 100px 48px; background: var(--white); }
.section-inner { max-width: 1200px; margin: 0 auto; }
.section-label { font-size: 11px; font-weight: 700; letter-spacing: 2px; text-transform: uppercase; color: var(--yellow); margin-bottom: 16px; }
.section-title { font-family: var(--font-display); font-size: clamp(36px, 5vw, 56px); line-height: 1.05; letter-spacing: 1px; color: var(--dark); margin-bottom: 56px; }
.accent { color: var(--blue); }
.features-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; }
.feature-card { background: var(--white); border: 1px solid var(--gray-light); border-radius: 20px; padding: 32px 28px; transition: border-color 0.3s, transform 0.3s, box-shadow 0.3s; display: flex; flex-direction: column; gap: 12px; }
.feature-card:hover { border-color: var(--blue-pale); transform: translateY(-4px); box-shadow: 0 12px 32px rgba(30,58,138,0.1); }
.feature-icon-wrap { width: 52px; height: 52px; background: var(--blue-light); border-radius: 14px; display: flex; align-items: center; justify-content: center; }
.feature-icon { font-size: 26px; }
.feature-card h3 { font-size: 17px; font-weight: 600; color: var(--dark); }
.feature-card p { font-size: 14px; line-height: 1.7; color: var(--gray); flex: 1; }

.blog-teaser { padding: 100px 48px; background: var(--off-white); }
.teaser-inner { display: grid; grid-template-columns: 1fr 1fr; gap: 48px; align-items: center; }
.teaser-desc { font-size: 16px; line-height: 1.7; color: var(--gray); margin-bottom: 28px; max-width: 420px; }
.teaser-cards { display: flex; flex-direction: column; gap: 14px; }
.teaser-card {
  background: var(--white); border: 1px solid var(--gray-light); border-radius: 16px;
  padding: 20px 24px; text-decoration: none; display: flex; flex-direction: column; gap: 8px;
  transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
}
.teaser-card:hover { border-color: var(--blue-pale); transform: translateX(4px); box-shadow: 0 8px 24px rgba(30,58,138,0.08); }
.tc-tag { font-size: 10px; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: var(--yellow); }
.teaser-card h3 { font-size: 16px; font-weight: 600; color: var(--dark); }
.tc-link { font-size: 13px; color: var(--blue-mid); font-weight: 600; }

.cta-section { padding: 100px 48px; background: linear-gradient(135deg, var(--blue) 0%, #1D4ED8 60%, #2563EB 100%); }
.cta-inner { max-width: 640px; margin: 0 auto; text-align: center; display: flex; flex-direction: column; align-items: center; gap: 20px; }
.cta-badge { background: rgba(245,158,11,0.2); border: 1px solid rgba(245,158,11,0.4); color: var(--yellow-warm); font-size: 12px; font-weight: 800; letter-spacing: 1px; text-transform: uppercase; padding: 6px 18px; border-radius: 100px; }
.cta-title { font-family: var(--font-display); font-size: clamp(40px, 6vw, 64px); letter-spacing: 1px; line-height: 1; color: var(--white); }
.cta-desc { font-size: 16px; color: rgba(255,255,255,0.7); line-height: 1.6; }
.cta-btn-yellow { background: var(--yellow); color: var(--dark); padding: 14px 28px; border-radius: 100px; font-weight: 700; font-size: 15px; text-decoration: none; display: inline-flex; align-items: center; transition: transform 0.2s, opacity 0.2s; box-shadow: 0 4px 20px rgba(245,158,11,0.35); }
.cta-btn-yellow:hover { transform: translateY(-2px); opacity: 0.92; }
.cta-btn-yellow.large { padding: 16px 36px; font-size: 16px; }

@media (max-width: 1024px) {
  .features-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 768px) {
  .hero { flex-direction: column; padding: 100px 20px 60px; align-items: flex-start; }
  .hero-visual { width: 100%; display: flex; justify-content: center; }
  .features, .blog-teaser, .cta-section { padding: 60px 20px; }
  .features-grid { grid-template-columns: 1fr; }
  .teaser-inner { grid-template-columns: 1fr; gap: 32px; }
  .hero-stats { flex-wrap: wrap; gap: 20px; }
}
</style>
