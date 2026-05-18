<template>
  <div class="layout">
    <Topbar />
    <main class="main">
      <router-view />
    </main>
    <AppFooter />
  </div>
</template>

<script setup>
import Topbar from '../components/layout/Topbar.vue'
import AppFooter from '../components/layout/AppFooter.vue'
</script>

<style scoped>
.layout {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}
.main {
  flex: 1;
}
</style>
