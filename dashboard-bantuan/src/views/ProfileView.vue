<script setup>
import { ref, onMounted } from 'vue'
import api from '@/services/api'

const user = ref({})
const passwordData = ref({
  current_password: '',
  password: '',
  password_confirmation: '',
})

const isLoading = ref(true) // For initial profile data loading
const isUpdatingProfile = ref(false) // For profile update button loading
const isUpdatingPassword = ref(false) // For password update button loading

const errors = ref({}) // For profile update errors
const passwordErrors = ref({}) // For password update errors
const successMessage = ref('')

/**
 * Fetches user profile data when the component is mounted.
 */
onMounted(async () => {
  try {
    const response = await api.getProfile()
    user.value = response.data.data
  } catch (err) {
    console.error('Gagal memuat profil:', err)
    // Optionally, display an error message to the user
  } finally {
    isLoading.value = false
  }
})

/**
 * Updates user profile information (name, email).
 */
async function updateProfile() {
  isUpdatingProfile.value = true // Set loading state for profile update
  errors.value = {} // Clear previous errors
  successMessage.value = '' // Clear previous success messages

  try {
    await api.updateProfile({
      name: user.value.name,
      email: user.value.email,
    })
    successMessage.value = 'Profil berhasil diperbarui!'
  } catch (err) {
    if (err.response && err.response.status === 422) {
      errors.value = err.response.data.errors
    } else {
      alert('Gagal memperbarui profil.')
    }
    console.error('Gagal memperbarui profil:', err)
  } finally {
    isUpdatingProfile.value = false // Reset loading state
  }
}

/**
 * Updates user password.
 */
async function updatePassword() {
  isUpdatingPassword.value = true // Set loading state for password update
  passwordErrors.value = {} // Clear previous password errors
  successMessage.value = '' // Clear previous success messages

  try {
    await api.updatePassword(passwordData.value)
    successMessage.value = 'Password berhasil diubah!'
    // Clear password form fields on success
    passwordData.value = { current_password: '', password: '', password_confirmation: '' }
  } catch (err) {
    if (err.response && err.response.status === 422) {
      passwordErrors.value = err.response.data.errors
    } else {
      alert('Gagal mengubah password.')
    }
    console.error('Gagal mengubah password:', err)
  } finally {
    isUpdatingPassword.value = false // Reset loading state
  }
}
</script>

<template>
  <div class="profile-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Profil Saya</h1>
        <p>Kelola informasi profil dan kredensial login Anda.</p>
      </div>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat profil...</p>
    </div>

    <div v-else class="profile-grid">
      <div class="card-container">
        <form @submit.prevent="updateProfile">
          <h2 class="card-title">Informasi Profil</h2>
          <div class="form-group">
            <label for="name">Nama Lengkap</label>
            <input
              type="text"
              id="name"
              v-model="user.name"
              placeholder="Masukkan nama lengkap Anda"
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
              v-model="user.email"
              placeholder="Masukkan alamat email Anda"
              required
              class="form-input"
            />
            <div v-if="errors.email" class="error-text">{{ errors.email[0] }}</div>
          </div>
          <div class="form-actions-end">
            <button type="submit" :disabled="isUpdatingProfile" class="submit-button">
              {{ isUpdatingProfile ? 'Menyimpan...' : 'Simpan Perubahan Profil' }}
            </button>
          </div>
        </form>
      </div>

      <div class="card-container">
        <form @submit.prevent="updatePassword">
          <h2 class="card-title">Ubah Password</h2>
          <div class="form-group">
            <label for="current_password">Password Saat Ini</label>
            <input
              type="password"
              id="current_password"
              v-model="passwordData.current_password"
              placeholder="Masukkan password Anda saat ini"
              required
              class="form-input"
            />
            <div v-if="passwordErrors.current_password" class="error-text">
              {{ passwordErrors.current_password[0] }}
            </div>
          </div>
          <div class="form-group">
            <label for="password">Password Baru</label>
            <input
              type="password"
              id="password"
              v-model="passwordData.password"
              placeholder="Masukkan password baru"
              required
              class="form-input"
            />
            <div v-if="passwordErrors.password" class="error-text">
              {{ passwordErrors.password[0] }}
            </div>
          </div>
          <div class="form-group">
            <label for="password_confirmation">Konfirmasi Password Baru</label>
            <input
              type="password"
              id="password_confirmation"
              v-model="passwordData.password_confirmation"
              placeholder="Konfirmasi password baru Anda"
              required
              class="form-input"
            />
          </div>
          <div class="form-actions-end">
            <button type="submit" :disabled="isUpdatingPassword" class="submit-button">
              {{ isUpdatingPassword ? 'Mengubah...' : 'Ubah Password' }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="successMessage" class="success-message">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
        <path
          fill-rule="evenodd"
          d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.06l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
          clip-rule="evenodd"
        />
      </svg>
      <span>{{ successMessage }}</span>
    </div>
  </div>
</template>

<style scoped>
.profile-view {
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

/* Loading State */
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

/* Grid for Profile and Password Forms */
.profile-grid {
  display: grid;
  grid-template-columns: 1fr 1fr; /* Two columns */
  gap: 1.5rem; /* Gap between cards */
}

/* Card Container for each form */
.card-container {
  background-color: white;
  padding: 2rem;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.card-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1e293b;
  margin-top: 0;
  padding-bottom: 1rem;
  border-bottom: 1px solid #e2e8f0; /* Light border below title */
  margin-bottom: 1.5rem;
}

/* Form Group Styles */
.form-group {
  margin-bottom: 1.25rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500;
  color: #475569;
  font-size: 0.875rem;
}

.form-input {
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

.form-input::placeholder {
  color: #94a3b8;
}

.form-input:focus {
  outline: none;
  border-color: #a78bfa;
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3);
}

/* Button Styles (Primary submit button) */
.form-actions-end {
  display: flex;
  justify-content: flex-end; /* Align button to the right */
  padding-top: 1rem;
}

.submit-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem;
  background-color: #4f46e5;
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s ease;
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

/* Error Text */
.error-text {
  color: #ef4444;
  font-size: 0.8125rem;
  margin-top: 0.375rem;
}

/* Success Message */
.success-message {
  margin-top: 1.5rem;
  padding: 1rem 1.25rem;
  background-color: #ecfdf5; /* Light green background */
  color: #047857; /* Dark green text */
  border: 1px solid #a7f3d0; /* Green border */
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-size: 0.9375rem;
  font-weight: 500;
  max-width: 700px; /* Match card container width */
  margin-left: auto;
  margin-right: auto;
}

.success-message svg {
  width: 1.5rem;
  height: 1.5rem;
  color: #10b981; /* Green icon color */
}

/* Responsive Styles */
@media (max-width: 992px) {
  .profile-grid {
    grid-template-columns: 1fr; /* Stack cards vertically on smaller screens */
  }

  .form-actions-end button {
    width: 100%; /* Full width button on small screens */
  }
}
</style>
