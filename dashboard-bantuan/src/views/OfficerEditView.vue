<!-- FILE: src/views/OfficerEditView.vue -->
<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, RouterLink } from 'vue-router' // Import RouterLink
import api from '@/services/api'

const props = defineProps({
  id: {
    type: String,
    required: true,
  },
})

const router = useRouter()
const officer = ref({}) // Object to hold officer data
const errors = ref({})
const isLoading = ref(true) // Start with loading state as data needs to be fetched

const passwordData = ref({
  password: '',
  password_confirmation: '',
})

/**
 * Fetches the officer data from the API when the component is mounted.
 * Populates the form fields with the fetched data.
 */
onMounted(async () => {
  try {
    const response = await api.getOfficer(props.id)
    officer.value = response.data.data // Fill form with data from API
  } catch (err) {
    alert('Gagal memuat data petugas untuk diedit.')
    console.error(err)
    router.push({ name: 'officers' }) // Redirect back to list if data fetching fails
  } finally {
    isLoading.value = false // End loading state
  }
})

/**
 * Sends the updated officer data to the API.
 * Handles success/error messages and redirects on success.
 */
async function updateOfficer() {
  isLoading.value = true // Set loading state for update operation
  errors.value = {} // Clear previous validation errors

  let dataToUpdate = {
    name: officer.value.name,
    email: officer.value.email,
  }

  // Only include password fields if a new password is provided
  if (passwordData.value.password) {
    dataToUpdate.password = passwordData.value.password
    dataToUpdate.password_confirmation = passwordData.value.password_confirmation
  }

  try {
    // Assuming api.updateOfficer handles FormData and _method if necessary
    await api.updateOfficer(props.id, dataToUpdate)
    alert('Data petugas berhasil diperbarui!') // Success alert
    router.push({ name: 'officers' }) // Redirect back to the officers list after successful update
  } catch (err) {
    // Handle API errors
    if (err.response && err.response.status === 422) {
      // If validation errors (status 422), set the errors reactive variable
      errors.value = err.response.data.errors
    } else {
      // For other types of errors, show a generic alert
      alert('Terjadi kesalahan saat memperbarui data.')
    }
    console.error('Failed to update data:', err) // Log the error for debugging
  } finally {
    isLoading.value = false // Always reset loading state
  }
}
</script>

<template>
  <div class="edit-officer-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Ubah Data Petugas</h1>
        <p>Perbarui informasi petugas di bawah ini.</p>
      </div>
      <!-- Optional: Add a back button if needed -->
      <!-- <button @click="router.back()" class="back-button">Kembali</button> -->
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data petugas...</p>
    </div>

    <div v-else class="card-container">
      <form @submit.prevent="updateOfficer" class="form-grid">
        <div class="form-group full-width">
          <label for="name">Nama Lengkap</label>
          <input
            type="text"
            id="name"
            v-model="officer.name"
            placeholder="Masukkan nama lengkap petugas"
            required
            class="form-input"
          />
          <div v-if="errors.name" class="error-text">{{ errors.name[0] }}</div>
        </div>
        <div class="form-group full-width">
          <label for="email">Alamat Email</label>
          <input
            type="email"
            id="email"
            v-model="officer.email"
            placeholder="Masukkan alamat email petugas"
            required
            class="form-input"
          />
          <div v-if="errors.email" class="error-text">{{ errors.email[0] }}</div>
        </div>

        <div class="divider full-width"></div>
        <p class="info-text full-width"><i>Kosongkan password jika tidak ingin mengubahnya.</i></p>

        <div class="form-group full-width">
          <label for="password">Password Baru</label>
          <input
            type="password"
            id="password"
            v-model="passwordData.password"
            placeholder="Biarkan kosong jika tidak ingin mengubah password"
            class="form-input"
          />
          <div v-if="errors.password" class="error-text">{{ errors.password[0] }}</div>
        </div>
        <div class="form-group full-width">
          <label for="password_confirmation">Konfirmasi Password Baru</label>
          <input
            type="password"
            id="password_confirmation"
            v-model="passwordData.password_confirmation"
            placeholder="Konfirmasi password baru"
            class="form-input"
          />
        </div>

        <div class="form-actions full-width">
          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Memperbarui...</span>
            <span v-else>Perbarui Petugas</span>
          </button>
          <RouterLink :to="{ name: 'officers' }" class="cancel-button">Batal</RouterLink>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.edit-officer-view {
  padding: 1.5rem;
}

/* Header Styles */
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
}

.header-content h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.header-content p {
  color: #64748b;
  margin: 0.25rem 0 0;
  font-size: 0.875rem;
}

/* Loading State (from RecipientsView) */
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

/* Card Container */
.card-container {
  background-color: white;
  padding: 2rem;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
}

/* Form Layout */
.form-grid {
  display: grid;
  gap: 1.25rem;
  grid-template-columns: 1fr; /* Default to single column for this form as fields are full-width */
}

.form-group {
  margin-bottom: 0;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #475569;
  font-size: 0.875rem;
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.5rem;
  background-color: #f8fafc;
  font-size: 0.875rem;
  color: #334155;
  box-sizing: border-box;
  transition:
    border-color 0.2s,
    box-shadow 0.2s;
}

.form-input::placeholder,
.form-textarea::placeholder {
  color: #94a3b8;
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #a78bfa;
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3);
}

.full-width {
  grid-column: 1 / -1; /* Ensure elements span full width in grid */
}

/* Divider for password section */
.divider {
  border-top: 1px solid #e2e8f0; /* Light gray line */
  margin-top: 1.5rem;
  margin-bottom: 1.5rem;
}

.info-text {
  color: #64748b; /* Slate 500 */
  font-size: 0.875rem;
  margin-bottom: 1rem; /* Space below the info text */
}

.form-actions {
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
  padding-top: 0.5rem;
}

.submit-button,
.cancel-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 1rem;
  text-decoration: none;
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.submit-button {
  background-color: #4f46e5;
  color: white;
}

.submit-button:hover:not(:disabled) {
  background-color: #4338ca;
}

.submit-button:disabled {
  background-color: #cbd5e1;
  color: #94a3b8;
  cursor: not-allowed;
  opacity: 0.8;
}

.cancel-button {
  background-color: #e2e8f0;
  color: #475569;
  border: 1px solid #cbd5e1;
}

.cancel-button:hover {
  background-color: #cbd5e1;
  color: #334155;
}

/* Error Text */
.error-text {
  color: #ef4444;
  font-size: 0.8125rem;
  margin-top: 0.375rem;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .card-container {
    padding: 1.5rem;
  }

  .form-actions {
    flex-direction: column;
    align-items: stretch;
    justify-content: flex-start;
  }

  .submit-button,
  .cancel-button {
    width: 100%;
  }
}
</style>
