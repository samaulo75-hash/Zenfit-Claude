<template>
  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-brand">
        <div class="footer-logo">
          <img src="@/assets/logo-trim.png" alt="ZenFit" class="footer-logo-img" />
        </div>
        <p class="footer-tagline">Tu compañero hacia una vida más saludable.</p>
        <div class="store-badges">
          <a href="#" class="store-badge">
            <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16"><path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z"/></svg>
            App Store
          </a>
          <a href="#" class="store-badge">
            <svg viewBox="0 0 24 24" fill="currentColor" width="16" height="16"><path d="M3.18 23.76c.4.22.87.22 1.27-.01l13.2-7.54-2.88-2.89-11.59 10.44zM.5 1.63C.19 2.03 0 2.57 0 3.24v17.52c0 .67.19 1.21.5 1.61l.09.08 9.82-9.82v-.22L.59 1.55.5 1.63zM20.37 10.25l-2.77-1.58-3.13 3.13 3.14 3.14 2.8-1.6c.8-.45.8-1.19-.04-1.09zm-17.19 13.51l11.59-10.44-2.88-2.88L.5 21.88l2.68 1.88z"/></svg>
            Google Play
          </a>
        </div>
      </div>

      <div class="footer-links">
        <div class="link-col">
          <h4>Producto</h4>
          <router-link to="/blog">Blog</router-link>
          <router-link to="/dashboard">Dashboard</router-link>
          <a href="#">Características</a>
          <a href="#">Precios</a>
        </div>
        <div class="link-col">
          <h4>Comunidad</h4>
          <a href="#">Testimonios</a>
          <a href="#">Guías</a>
          <a href="#">Newsletter</a>
        </div>
        <div class="link-col">
          <h4>Legal</h4>
          <a href="#">Privacidad</a>
          <a href="#">Términos</a>
          <a href="#">Cookies</a>
        </div>
      </div>
    </div>

    <div class="footer-bottom">
      <span>© 2026 ZenFit. Todos los derechos reservados.</span>
      <div class="footer-rating">
        <span>⭐ 4.8 App Store</span>
        <span>⭐ 4.7 Google Play</span>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: var(--off-white);
  border-top: 1px solid var(--gray-light);
  padding: 64px 48px 32px;
}
.footer-inner {
  display: flex;
  gap: 80px;
  margin-bottom: 48px;
  max-width: 1200px;
  margin-left: auto;
  margin-right: auto;
}
.footer-brand { flex: 0 0 260px; }
.footer-logo {
  display: inline-flex;
  width: fit-content;
  align-items: center;
  margin-bottom: 20px;
}
.footer-logo-img {
  height: 72px;
  width: auto;
  display: block;
  transition: filter 0.2s ease;
}
/* En modo oscuro el footer tiene fondo oscuro -> logo en blanco */
:global(.dark) .footer-logo-img { filter: brightness(0) invert(1); }
.footer-tagline {
  color: var(--gray);
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 24px;
}
.store-badges {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}
.store-badge {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--white);
  border: 1px solid var(--gray-light);
  color: var(--dark);
  padding: 8px 14px;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 500;
  transition: border-color 0.2s, color 0.2s;
}
.store-badge:hover { border-color: var(--blue-mid); color: var(--blue-mid); }

.footer-links {
  display: flex;
  gap: 60px;
  flex: 1;
}
.link-col {
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.link-col h4 {
  color: var(--dark);
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.8px;
  text-transform: uppercase;
  margin-bottom: 8px;
}
.link-col a {
  color: var(--gray);
  font-size: 14px;
  transition: color 0.2s;
}
.link-col a:hover { color: var(--blue-mid); }

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding-top: 24px;
  border-top: 1px solid var(--gray-light);
  font-size: 13px;
  color: var(--gray);
  max-width: 1200px;
  margin: 0 auto;
}
.footer-rating { display: flex; gap: 20px; }

@media (max-width: 768px) {
  .footer { padding: 40px 20px 24px; }
  .footer-inner { flex-direction: column; gap: 40px; margin-bottom: 32px; }
  .footer-brand { flex: none; }
  .footer-links { flex-wrap: wrap; gap: 32px; }
  .footer-bottom { flex-direction: column; gap: 12px; text-align: center; }
}
</style>
