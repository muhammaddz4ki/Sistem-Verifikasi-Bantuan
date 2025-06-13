<script setup>
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router' // Import RouterLink
import api from '@/services/api'

const router = useRouter()
const officerData = ref({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
})
const errors = ref({})
const isLoading = ref(false)

/**
 * Handles saving the new officer data to the backend.
 * Displays success/error messages and redirects on success.
 */
async function saveOfficer() {
  isLoading.value = true // Set loading state to true
  errors.value = {} // Clear previous errors

  try {
    // Attempt to create the officer data using the API service
    await api.createOfficer(officerData.value)
    alert('Petugas baru berhasil ditambahkan!') // Success alert
    router.push({ name: 'officers' }) // Redirect to the officers list page
  } catch (err) {
    // Handle API errors
    if (err.response && err.response.status === 422) {
      // If validation errors (status 422), set the errors reactive variable
      errors.value = err.response.data.errors
    } else {
      // For other types of errors, show a generic alert
      alert('Terjadi kesalahan saat menyimpan data.')
    }
    console.error(err) // Log the error for debugging
  } finally {
    isLoading.value = false // Always reset loading state
  }
}
</script>

<template>
  <div class="officer-create-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Tambah Petugas Baru</h1>
        <p>Isi form di bawah untuk mendaftarkan petugas baru.</p>
      </div>
    </div>

    <div class="card-container">
      <form @submit.prevent="saveOfficer" class="form-grid">
        <div class="form-group full-width">
          <label for="name">Nama Lengkap</label>
          <input
            type="text"
            id="name"
            v-model="officerData.name"
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
            v-model="officerData.email"
            placeholder="Masukkan alamat email petugas"
            required
            class="form-input"
          />
          <div v-if="errors.email" class="error-text">{{ errors.email[0] }}</div>
        </div>
        <div class="form-group full-width">
          <label for="password">Password</label>
          <input
            type="password"
            id="password"
            v-model="officerData.password"
            placeholder="Masukkan password"
            required
            class="form-input"
          />
          <div v-if="errors.password" class="error-text">{{ errors.password[0] }}</div>
        </div>
        <div class="form-group full-width">
          <label for="password_confirmation">Konfirmasi Password</label>
          <input
            type="password"
            id="password_confirmation"
            v-model="officerData.password_confirmation"
            placeholder="Konfirmasi password Anda"
            required
            class="form-input"
          />
        </div>

        <div class="form-actions full-width">
          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Menyimpan...</span>
            <span v-else>Simpan Petugas</span>
          </button>
          <RouterLink :to="{ name: 'officers' }" class="cancel-button">Batal</RouterLink>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.officer-create-view {
  padding: 1.5rem;
}

/* Header Styles (from other views) */
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

/* Card Container (similar to other forms) */
.card-container {
  background-color: white;
  padding: 2rem;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  max-width: 700px;
  margin-left: auto;
  margin-right: auto;
}

/* Form Layout (consistent grid for full-width fields) */
.form-grid {
  display: grid;
  gap: 1.25rem;
  grid-template-columns: 1fr; /* Single column by default for this form */
}

.form-group {
  margin-bottom: 0; /* Use grid gap for spacing */
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
  grid-column: 1 / -1; /* Ensures elements span full width in the grid */
}

.form-actions {
  display: flex;
  gap: 0.75rem;
  justify-content: flex-end;
  padding-top: 0.5rem;
}

/* Button Styles (primary for submit, secondary for cancel) */
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
  text-decoration: none; /* For RouterLink */
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.submit-button {
  background-color: #4f46e5; /* Primary purple color */
  color: white;
}

.submit-button:hover:not(:disabled) {
  background-color: #4338ca; /* Darker shade on hover */
}

.submit-button:disabled {
  background-color: #cbd5e1; /* Gray for disabled */
  color: #94a3b8; /* Darker gray text for disabled */
  cursor: not-allowed;
  opacity: 0.8;
}

.cancel-button {
  background-color: #e2e8f0; /* Light gray */
  color: #475569; /* Slate 600 */
  border: 1px solid #cbd5e1; /* Light border */
}

.cancel-button:hover {
  background-color: #cbd5e1;
  color: #334155;
}

/* Error Text */
.error-text {
  color: #ef4444; /* Tailwind's red-500 */
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
    flex-direction: column; /* Stack buttons on small screens */
    align-items: stretch; /* Stretch buttons to full width */
    justify-content: flex-start;
  }

  .submit-button,
  .cancel-button {
    width: 100%; /* Full width buttons */
  }
}
</style>
