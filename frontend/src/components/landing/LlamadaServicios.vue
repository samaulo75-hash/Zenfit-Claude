<template>
  <section class="llamada-servicios">
    <div class="container">
      <div class="llamada-card">
        <h2><i class="fas fa-rocket"></i> ¿Listo para empezar?</h2>
        <p>
          Descubre planes personalizados de <strong>dieta, ejercicio y sueño</strong>
          adaptados a tus necesidades y objetivos.
        </p>
        <router-link to="/register" class="btn-llamada">
          <i class="fas fa-arrow-right"></i> Ver todos los servicios
        </router-link>
      </div>
    </div>
  </section>
</template>

<script>
export default { name: 'LlamadaServicios' }
</script>

<style scoped>
.llamada-servicios { padding: 60px 50px 100px 50px; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }
.container { max-width: 900px; margin: 0 auto; }
.llamada-card {
  background: white; padding: 50px; border-radius: 30px; text-align: center;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1); transition: all 0.3s;
}
.llamada-card:hover { transform: translateY(-5px); box-shadow: 0 25px 50px rgba(0, 0, 0, 0.15); }
.llamada-card h2 { color: #F2E638; font-size: 36px; margin-bottom: 20px; }
.llamada-card h2 i { margin-right: 10px; color: #F2E638; }
.llamada-card p { color: #555; font-size: 18px; line-height: 1.6; margin-bottom: 30px; }
.llamada-card strong { color: #F2E638; }
.btn-llamada {
  display: inline-flex; align-items: center; gap: 10px; padding: 15px 35px;
  background: #F2E638; color: #333; text-decoration: none; border-radius: 50px;
  font-weight: bold; font-size: 18px; transition: all 0.3s; border: none; cursor: pointer;
}
.btn-llamada:hover { background: #e0d422; transform: translateY(-2px); box-shadow: 0 10px 20px rgba(242, 230, 56, 0.3); }
.btn-llamada i { transition: transform 0.3s; }
.btn-llamada:hover i { transform: translateX(5px); }
@media (max-width: 768px) {
  .llamada-servicios { padding: 40px 20px 60px 20px; }
  .llamada-card { padding: 30px 20px; }
  .llamada-card h2 { font-size: 28px; }
  .llamada-card p { font-size: 16px; }
  .btn-llamada { padding: 12px 25px; font-size: 16px; }
}
</style>
