<template>
  <section class="descripcion">
    <div class="container">
      <div class="descripcion-content">
        <div class="descripcion-texto">
          <h2><i class="fas fa-leaf"></i> ¿Qué es ZenFit?</h2>
          <p>
            ZenFit es una plataforma diseñada para ayudarte a mejorar tu salud
            <strong>física y mental</strong> de forma <strong>sencilla y personalizada</strong>.
          </p>
          <p>
            Sabemos que llevar una vida saludable puede ser complicado por la falta de
            <strong>organización y orientación</strong>. Por eso, en ZenFit te ofrecemos
            herramientas prácticas y adaptadas a ti.
          </p>
          <p>
            Nuestra misión es <strong>facilitar hábitos saludables</strong> de forma
            accesible para todos, ayudándote a alcanzar tus metas de bienestar
            sin complicaciones.
          </p>
        </div>
        <div class="descripcion-icono">
          <i class="fas fa-heartbeat"></i>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default { name: 'DescripcionZenFit' }
</script>

<style scoped>
.descripcion { padding: 80px 50px; background: white; }
.container { max-width: 1200px; margin: 0 auto; }
.descripcion-content { display: flex; align-items: center; gap: 50px; flex-wrap: wrap; }
.descripcion-texto { flex: 2; }
.descripcion-texto h2 { color: #F2E638; font-size: 36px; margin-bottom: 25px; }
.descripcion-texto h2 i { margin-right: 10px; color: #F2E638; }
.descripcion-texto p { color: #555; font-size: 18px; line-height: 1.6; margin-bottom: 20px; }
.descripcion-texto strong { color: #F2E638; font-weight: bold; }
.descripcion-icono { flex: 1; text-align: center; }
.descripcion-icono i { font-size: 180px; color: #F2E638; opacity: 0.8; }
@media (max-width: 768px) {
  .descripcion { padding: 50px 20px; }
  .descripcion-texto h2 { font-size: 28px; }
  .descripcion-texto p { font-size: 16px; }
  .descripcion-icono i { font-size: 100px; }
}
</style>
