// FILE: src/services/toast.js

import { reactive } from 'vue'

// Ini adalah state global untuk notifikasi kita
export const toastState = reactive({
  visible: false,
  message: '',
  type: 'success', // bisa 'success' atau 'error'
})

let timeoutId = null

// Ini adalah fungsi yang akan kita panggil dari komponen lain
export function showToast(message, type = 'success', duration = 3000) {
  // Hapus timeout sebelumnya jika ada notifikasi yang masih berjalan
  if (timeoutId) {
    clearTimeout(timeoutId)
  }

  // Set properti notifikasi
  toastState.message = message
  toastState.type = type
  toastState.visible = true

  // Atur timer untuk menyembunyikan notifikasi secara otomatis
  timeoutId = setTimeout(() => {
    toastState.visible = false
  }, duration)
}
