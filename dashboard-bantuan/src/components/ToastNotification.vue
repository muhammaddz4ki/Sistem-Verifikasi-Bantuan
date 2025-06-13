<!-- FILE: src/components/ToastNotification.vue -->
<script setup>
import { computed } from 'vue'
import { toastState } from '../services/toast.js'

// Menentukan ikon dan warna berdasarkan tipe notifikasi
const toastClasses = computed(() => {
  return toastState.type === 'success' ? 'toast-success' : 'toast-error'
})
</script>

<template>
  <!-- Gunakan transisi untuk animasi muncul dan hilang -->
  <Transition name="toast-slide">
    <div v-if="toastState.visible" class="toast-container" :class="toastClasses">
      <!-- Ikon Success -->
      <svg
        v-if="toastState.type === 'success'"
        class="toast-icon"
        viewBox="0 0 20 20"
        fill="currentColor"
      >
        <path
          fill-rule="evenodd"
          d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
          clip-rule="evenodd"
        />
      </svg>
      <!-- Ikon Error -->
      <svg
        v-if="toastState.type === 'error'"
        class="toast-icon"
        viewBox="0 0 20 20"
        fill="currentColor"
      >
        <path
          fill-rule="evenodd"
          d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z"
          clip-rule="evenodd"
        />
      </svg>
      <p>{{ toastState.message }}</p>
    </div>
  </Transition>
</template>

<style scoped>
.toast-container {
  position: fixed;
  bottom: 20px;
  right: 20px;
  display: flex;
  align-items: center;
  padding: 12px 20px;
  border-radius: 8px;
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
  color: white;
  z-index: 9999;
  font-weight: 500;
}

.toast-success {
  background-color: #2f9e44; /* Hijau yang lebih bagus */
}

.toast-error {
  background-color: #d9480f; /* Merah oranye */
}

.toast-icon {
  width: 20px;
  height: 20px;
  margin-right: 12px;
}

.toast-container p {
  margin: 0;
}

/* Animasi untuk Toast */
.toast-slide-enter-active,
.toast-slide-leave-active {
  transition: all 0.5s cubic-bezier(0.23, 1, 0.32, 1);
}

.toast-slide-enter-from,
.toast-slide-leave-to {
  transform: translateY(20px) translateX(100%);
  opacity: 0;
}
</style>
