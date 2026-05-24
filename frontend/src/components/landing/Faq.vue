<template>
  <section class="faq">
    <div class="container">
      <h2><i class="fas fa-question-circle"></i> Preguntas frecuentes</h2>
      <p class="subtitulo">Resolvemos tus dudas más comunes</p>

      <div class="faq-grid">
        <div class="faq-item" v-for="(item, index) in preguntas" :key="index">
          <div class="faq-pregunta" @click="toggleFAQ(index)">
            <h3>{{ item.pregunta }}</h3>
            <i :class="item.abierto ? 'fas fa-chevron-up' : 'fas fa-chevron-down'"></i>
          </div>
          <div class="faq-respuesta" v-show="item.abierto">
            <p>{{ item.respuesta }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: 'Faq',
  data() {
    return {
      preguntas: [
        { pregunta: '¿Es completamente gratis?', respuesta: 'Sí, ZenFit ofrece una versión gratuita con todas las funcionalidades básicas. También tenemos planes premium con características adicionales.', abierto: false },
        { pregunta: '¿Necesito equipo especial para los ejercicios?', respuesta: 'No necesariamente. Ofrecemos rutinas adaptadas a tu equipo disponible: solo peso corporal, bandas elásticas, pesas o máquinas de gimnasio.', abierto: false },
        { pregunta: '¿Los planes de dieta consideran alergias?', respuesta: 'Sí, puedes seleccionar restricciones alimentarias como vegetariano, vegano, sin gluten o sin lácteos para personalizar tu plan.', abierto: false },
        { pregunta: '¿Puedo cambiar mi objetivo después?', respuesta: '¡Claro! Puedes modificar tu objetivo cuando quieras y el sistema generará un nuevo plan adaptado a tus nuevas metas.', abierto: false }
      ]
    }
  },
  methods: {
    toggleFAQ(index) { this.preguntas[index].abierto = !this.preguntas[index].abierto }
  }
}
</script>

<style scoped>
.faq { padding: 80px 50px; background: white; }
.container { max-width: 800px; margin: 0 auto; }
.faq h2 { text-align: center; color: #F2E638; font-size: 36px; margin-bottom: 15px; }
.faq h2 i { margin-right: 10px; }
.subtitulo { text-align: center; color: #666; font-size: 18px; margin-bottom: 50px; }
.faq-grid { display: flex; flex-direction: column; gap: 15px; }
.faq-item { background: #f8f9fa; border-radius: 15px; overflow: hidden; }
.faq-pregunta {
  display: flex; justify-content: space-between; align-items: center;
  gap: 24px;
  padding: 22px 32px;
  cursor: pointer; transition: all 0.3s;
}
.faq-pregunta:hover { background: #e9ecef; }
.faq-pregunta h3 { color: #333; font-size: 18px; margin: 0; }
.faq-pregunta i { color: #F2E638; font-size: 16px; flex-shrink: 0; }
.faq-respuesta {
  padding: 18px 32px 24px 32px;
  color: #666; line-height: 1.65;
  border-top: 1px solid #e0e0e0;
}
@media (max-width: 768px) {
  .faq { padding: 50px 20px; }
  .faq-pregunta { padding: 18px 20px; gap: 14px; }
  .faq-pregunta h3 { font-size: 16px; }
  .faq-respuesta { padding: 14px 20px 18px 20px; }
}
</style>
