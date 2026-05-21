<template>
  <section class="cta-final">
    <div class="container">
      <h2><i class="fas fa-heart"></i> ¿Listo para transformar tu vida?</h2>
      <p>Únete a miles de personas que ya están mejorando su salud con ZenFit</p>
      <div class="cta-buttons">
        <router-link to="/register" class="btn-primario">
          <i class="fas fa-user-plus"></i> Crear cuenta
        </router-link>
        <router-link to="/login" class="btn-secundario">
          <i class="fas fa-sign-in-alt"></i> Iniciar sesión
        </router-link>
      </div>
    </div>
  </section>
</template>

<script>
export default { name: 'CallToAction' }
</script>

<style scoped>
.cta-final { background: linear-gradient(135deg, #F2E638, #e0d422); padding: 80px 50px; text-align: center; color: #333; }
.container { max-width: 800px; margin: 0 auto; }
.cta-final h2 { font-size: 36px; margin-bottom: 20px; color: #333; }
.cta-final h2 i { margin-right: 10px; color: #333; }
.cta-final p { font-size: 18px; margin-bottom: 30px; color: #555; }
.cta-buttons { display: flex; gap: 20px; justify-content: center; flex-wrap: wrap; }
.btn-primario {
  display: inline-flex; align-items: center; gap: 10px; padding: 15px 35px;
  background: #333; color: #F2E638; text-decoration: none; border-radius: 50px;
  font-weight: bold; font-size: 16px; transition: all 0.3s;
}
.btn-primario:hover { transform: translateY(-2px); background: #555; box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2); }
.btn-secundario {
  display: inline-flex; align-items: center; gap: 10px; padding: 15px 35px;
  background: transparent; color: #333; text-decoration: none; border-radius: 50px;
  font-weight: bold; border: 2px solid #333; transition: all 0.3s;
}
.btn-secundario:hover { background: #333; color: #F2E638; transform: translateY(-2px); }
@media (max-width: 768px) {
  .cta-final { padding: 50px 20px; }
  .cta-final h2 { font-size: 28px; }
  .btn-primario, .btn-secundario { padding: 12px 25px; }
}
</style>
