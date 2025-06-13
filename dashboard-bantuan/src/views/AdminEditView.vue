<!-- FILE: src/views/AdminEditView.vue -->
<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import api from '@/services/api'

const props = defineProps({
  id: {
    type: [String, Number], // Ensure id can be string or number
    required: true,
  },
})

const router = useRouter()
const admin = ref({
  // Initialize with empty strings, as per your comment,
  // the API doesn't provide a get-one endpoint.
  // User will need to re-enter data.
  name: '',
  email: '',
})
const errors = ref({})
const isLoading = ref(true) // For form submission loading state
const isFetchingInitialData = ref(true) // For initial data loading visual

const passwordData = ref({
  password: '',
  password_confirmation: '',
})

/**
 * On component mount, immediately set loading to false
 * since there's no API endpoint to fetch existing admin data.
 * The user is expected to re-enter the information.
 * In a real application, a `getAdmin(id)` API call would typically go here.
 */
onMounted(async () => {
  // As per your comment: "API tidak menyediakan get-one, jadi kita ambil dari data list."
  // "Untuk saat ini kita tidak bisa memuat data, user harus mengisi ulang."
  // Therefore, we just set loading to false.
  isLoading.value = false // For form submission button
  isFetchingInitialData.value = false // For initial page loading indicator
})

/**
 * Handles the update of admin data, including optional password change.
 * Submits the form data to the API.
 */
async function updateAdmin() {
  isLoading.value = true // Set loading state for the submit button
  errors.value = {} // Clear previous validation errors

  let dataToUpdate = {
    name: admin.value.name,
    email: admin.value.email,
  }

  // Only include password fields in the payload if a new password is provided
  if (passwordData.value.password) {
    dataToUpdate.password = passwordData.value.password
    dataToUpdate.password_confirmation = passwordData.value.password_confirmation
  }

  try {
    // Call the API to update the admin using the provided ID and data
    await api.updateAdmin(props.id, dataToUpdate)
    alert('Data admin berhasil diperbarui!') // Show success message
    router.push({ name: 'admins' }) // Navigate back to the admins list page
  } catch (err) {
    // Handle API errors
    if (err.response && err.response.status === 422) {
      // If validation errors (HTTP status 422), display them
      errors.value = err.response.data.errors
    } else {
      // For other errors, show a generic alert
      alert('Terjadi kesalahan saat memperbarui data.')
      console.error('Error updating admin:', err) // Log the full error
    }
  } finally {
    isLoading.value = false // Reset loading state regardless of success or failure
  }
}
</script>

<template>
  <div class="admin-edit-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Ubah Data Admin</h1>
        <p>Perbarui informasi admin di bawah ini. Harap isi kembali semua field.</p>
      </div>
    </div>

    <!-- Initial loading state for the page -->
    <div v-if="isFetchingInitialData" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data...</p>
    </div>

    <!-- Form for editing admin data -->
    <div v-else class="card-container">
      <form @submit.prevent="updateAdmin">
        <h2 class="card-title">Informasi Dasar</h2>
        <div class="form-group">
          <label for="name">Nama Lengkap</label>
          <input
            type="text"
            id="name"
            v-model="admin.name"
            placeholder="Masukkan nama lengkap admin"
            required
            class="form-input"
          />
          <div v-if="errors.name" class="error-text">{{ errors.name[0] }}</div>
        </div>
        <div class="form-group">
          <label for="email">Alamat Email</label>
          <input
            type="email"
            id="email"
            v-model="admin.email"
            placeholder="Masukkan alamat email admin"
            required
            class="form-input"
          />
          <div v-if="errors.email" class="error-text">{{ errors.email[0] }}</div>
        </div>

        <hr class="form-divider" />

        <h2 class="card-title">Ubah Password</h2>
        <p class="form-hint"><i>Kosongkan password jika tidak ingin mengubahnya.</i></p>
        <div class="form-group">
          <label for="password">Password Baru</label>
          <input
            type="password"
            id="password"
            v-model="passwordData.password"
            placeholder="Biarkan kosong jika tidak ingin mengubah"
            class="form-input"
          />
          <div v-if="errors.password" class="error-text">{{ errors.password[0] }}</div>
        </div>
        <div class="form-group">
          <label for="password_confirmation">Konfirmasi Password Baru</label>
          <input
            type="password"
            id="password_confirmation"
            v-model="passwordData.password_confirmation"
            placeholder="Ulangi password baru Anda"
            class="form-input"
          />
        </div>

        <div class="form-actions-end">
          <RouterLink :to="{ name: 'admins' }" class="cancel-button">Batal</RouterLink>
          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Memperbarui...</span>
            <span v-else>Perbarui Admin</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.admin-edit-view {
  padding: 1.5rem;
}

/* Page Header styles for consistency */
.page-header {
  margin-bottom: 1.5rem;
}

.page-header h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.page-header p {
  color: #64748b;
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
}

/* Loading state styles, consistent with other views */
.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 0;
}

.loading-state .spinner {
  width: 2.5rem;
  height: 2.5rem;
  border: 3px solid rgba(79, 70, 229, 0.2);
  border-radius: 50%;
  border-top-color: #4f46e5;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

.loading-state p {
  color: #64748b;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Card container for the form, consistent with other views */
.card-container {
  background-color: white;
  padding: 2rem;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  max-width: 600px; /* Constrain width for readability */
  margin: 0 auto; /* Center the card */
}

/* Title within the card, consistent with other forms */
.card-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1e293b;
  margin-top: 0;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e2e8f0; /* Light border below title */
  margin-bottom: 1.5rem;
}

/* Form group (label + input) styles for consistency */
.form-group {
  margin-bottom: 1.25rem; /* Space between form fields */
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #475569; /* Slate 600 */
  font-size: 0.875rem;
}

/* Input field styles, consistent across all forms */
.form-input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #e2e8f0; /* Slate 200 */
  border-radius: 0.5rem;
  background-color: #f8fafc; /* Slate 50 */
  font-size: 0.875rem;
  color: #334155; /* Slate 800 */
  box-sizing: border-box; /* Include padding in element's total width/height */
  transition:
    border-color 0.2s,
    box-shadow 0.2s;
}

.form-input::placeholder {
  color: #94a3b8; /* Slate 400 for placeholders */
}

.form-input:focus {
  outline: none;
  border-color: #a78bfa; /* Violet 400 for focus */
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3); /* Soft glow on focus */
}

/* Divider for the password section */
.form-divider {
  border: none;
  border-top: 1px solid #e2e8f0; /* Light gray line */
  margin: 2rem 0; /* Space above and below the divider */
}

/* Hint text for password fields */
.form-hint {
  color: #64748b; /* Slate 500 */
  font-size: 0.875rem;
  margin-top: -0.5rem; /* Adjust margin to sit closer to the section title */
  margin-bottom: 1.5rem;
}

/* Form actions (buttons) layout */
.form-actions-end {
  display: flex;
  justify-content: flex-end; /* Align buttons to the right */
  gap: 0.75rem; /* Space between buttons */
  padding-top: 1rem; /* Space above the buttons */
}

/* Submit button styles, consistent with primary actions */
.submit-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  background-color: #4f46e5; /* Indigo 600 */
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s ease;
}

.submit-button:hover:not(:disabled) {
  background-color: #4338ca; /* Darker indigo on hover */
}

.submit-button:disabled {
  background-color: #cbd5e1; /* Light gray when disabled */
  color: #94a3b8; /* Darker gray text for disabled */
  cursor: not-allowed;
  opacity: 0.8;
}

/* Cancel button styles, consistent with secondary actions */
.cancel-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  background-color: #e2e8f0; /* Slate 200 */
  color: #475569; /* Slate 600 */
  border: 1px solid #cbd5e1; /* Slate 300 */
  border-radius: 0.5rem;
  font-weight: 500;
  text-decoration: none; /* For RouterLink */
  transition:
    background-color 0.2s ease,
    color 0.2s ease,
    border-color 0.2s ease;
  font-size: 1rem;
}

.cancel-button:hover {
  background-color: #cbd5e1; /* Slate 300 on hover */
  color: #334155; /* Slate 800 */
}

/* Error text styles for validation feedback */
.error-text {
  color: #ef4444; /* Red 500 */
  font-size: 0.8125rem;
  margin-top: 0.375rem;
}

/* Responsive adjustments */
@media (max-width: 600px) {
  .card-container {
    padding: 1.5rem; /* Reduce padding on smaller screens */
  }
  .form-actions-end {
    flex-direction: column; /* Stack buttons vertically on small screens */
    gap: 0.75rem;
  }
  .submit-button,
  .cancel-button {
    width: 100%; /* Make buttons full width */
  }
}
</style>
