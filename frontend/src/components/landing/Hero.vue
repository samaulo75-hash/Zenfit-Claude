<template>
  <section class="hero">
    <div class="hero-content animate-fadeInUp">
      <i class="fas fa-leaf hero-icon animate-bounce"></i>
      <h2>Transforma tu estilo de vida desde hoy</h2>
      <p>Planes personalizados adaptados a tus necesidades</p>
      <router-link to="/register" class="btn animate-pulse">
        <i class="fas fa-rocket"></i> Explorar servicios
      </router-link>
    </div>
  </section>
</template>

<script>
export default { name: 'Hero' }
</script>

<style scoped>
.hero {
  height: 85vh;
  background: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)),
      url("@/assets/gimnasio.png") center/cover no-repeat;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
  padding: 20px;
}
.hero-content { color: white; animation: fadeInUp 0.8s ease; }
.hero-icon {
  font-size: 64px; margin-bottom: 20px; color: #F2E638;
  display: inline-block; animation: bounce 2s ease infinite;
}
.hero h2 { font-size: 42px; margin-bottom: 20px; animation: fadeInUp 0.8s ease 0.1s both; }
.hero p { font-size: 20px; margin-bottom: 30px; animation: fadeInUp 0.8s ease 0.2s both; }
.btn {
  padding: 12px 25px; background: #F2E638; color: #333; text-decoration: none;
  border-radius: 25px; transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  display: inline-flex; align-items: center; gap: 8px;
  animation: fadeInUp 0.8s ease 0.3s both;
}
.btn:hover { background: #e0d422; transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2); }
.btn i { transition: transform 0.2s ease; }
.btn:hover i { transform: translateX(5px); }
@media (max-width: 768px) {
  .hero h2 { font-size: 30px; }
  .hero-icon { font-size: 48px; }
}
@keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } }
@keyframes bounce { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
</style>
