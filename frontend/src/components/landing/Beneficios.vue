<template>
  <section class="beneficios">
    <div class="overlay"></div>
    <div class="container">
      <h2 class="animate-fadeInUp"><i class="fas fa-star-of-life"></i> ¿Por qué elegir ZenFit?</h2>
      <p class="subtitulo animate-fadeInUp" :style="{ animationDelay: '0.1s' }">Descubre las ventajas de transformar tu estilo de vida con nosotros</p>

      <div class="beneficios-grid">
        <div class="beneficio-card animate-fadeInUp" v-for="(beneficio, index) in beneficios" :key="index" :style="{ animationDelay: `${0.2 + index * 0.05}s` }">
          <div class="beneficio-icon">
            <i :class="beneficio.icono"></i>
          </div>
          <h3>{{ beneficio.titulo }}</h3>
          <p>{{ beneficio.texto }}</p>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Beneficios',
  data() {
    return {
      beneficios: [
        { icono: 'fas fa-chart-line', titulo: 'Resultados Reales', texto: 'Planes personalizados adaptados a tus necesidades específicas' },
        { icono: 'fas fa-mobile-alt', titulo: 'Acceso Multiplataforma', texto: 'Disponible en web, móvil y tablet. Tus planes siempre contigo' },
        { icono: 'fas fa-robot', titulo: 'Recomendaciones IA', texto: 'Planes adaptados por inteligencia artificial a tus necesidades' },
        { icono: 'fas fa-clock', titulo: 'Ahorro de Tiempo', texto: 'Olvídate de planificar. Nosotros te damos todo listo para seguir' },
        { icono: 'fas fa-heartbeat', titulo: 'Salud Integral', texto: 'Abordamos nutrición, ejercicio y descanso para un bienestar completo' },
        { icono: 'fas fa-headset', titulo: 'Soporte 24/7', texto: 'Asistencia personalizada para resolver tus dudas' }
      ]
    }
  }
}
</script>

<style scoped>
.beneficios {
  position: relative; padding: 80px 50px;
  background-image: url('@/assets/gimnasio2.jpg');
  background-size: cover; background-position: center;
  background-attachment: scroll; background-repeat: no-repeat; overflow: hidden;
}
.beneficios .overlay {
  position: absolute; top: 0; left: 0; width: 100%; height: 100%;
  background: rgba(0, 0, 0, 0.75); z-index: 1;
}
.container { position: relative; z-index: 2; max-width: 1200px; margin: 0 auto; }
.beneficios h2 { text-align: center; color: #F2E638; font-size: 36px; margin-bottom: 15px; }
.beneficios h2 i { margin-right: 10px; }
.subtitulo { text-align: center; color: #ffffff; font-size: 18px; margin-bottom: 50px; }
.beneficios-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 30px; }
.beneficio-card {
  background: rgba(255, 255, 255, 0.95); padding: 30px; border-radius: 20px; text-align: center;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
  opacity: 0; animation: fadeInUp 0.6s ease forwards;
}
.beneficio-card:hover { transform: translateY(-10px) scale(1.02); background: white; box-shadow: 0 20px 40px rgba(242, 230, 56, 0.3); }
.beneficio-icon {
  width: 80px; height: 80px; background: #F2E638; border-radius: 50%;
  display: flex; align-items: center; justify-content: center; margin: 0 auto 20px;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}
.beneficio-card:hover .beneficio-icon { transform: scale(1.1) rotate(360deg); background: #e0d422; }
.beneficio-icon i { font-size: 36px; color: #333; }
.beneficio-card h3 { color: #333; margin-bottom: 15px; font-size: 20px; }
.beneficio-card p { color: #555; line-height: 1.5; }
@keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
@media (max-width: 768px) {
  .beneficios { padding: 50px 20px; }
  .beneficios h2 { font-size: 28px; }
}
</style>
