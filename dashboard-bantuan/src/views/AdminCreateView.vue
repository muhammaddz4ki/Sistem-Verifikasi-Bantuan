<script setup>
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router' // Ensure RouterLink is imported
import api from '@/services/api'

const router = useRouter() // Initialize router for navigation

// Reactive reference for admin data, including password fields
const adminData = ref({
  name: '',
  email: '',
  password: '',
  password_confirmation: '',
})

// Reactive reference for storing validation errors from the API
const errors = ref({})

// Reactive reference for managing loading state during form submission
const isLoading = ref(false)

/**
 * Handles the form submission to create a new admin.
 * Sets loading state, clears previous errors, calls the API,
 * and handles success or error responses.
 */
async function saveAdmin() {
  isLoading.value = true // Set loading state to true
  errors.value = {} // Clear any existing errors

  try {
    // Call the API to create a new admin with the data from the form
    await api.createAdmin(adminData.value)
    alert('Admin baru berhasil ditambahkan!') // Show success message
    router.push({ name: 'admins' }) // Navigate back to the admin list page
  } catch (err) {
    // Handle API errors
    if (err.response && err.response.status === 422) {
      // If validation errors (HTTP status 422), store them
      errors.value = err.response.data.errors
    } else {
      // For other types of errors, show a generic alert
      alert('Terjadi kesalahan saat menyimpan data.')
    }
    console.error('Error saving admin:', err) // Log the full error for debugging
  } finally {
    isLoading.value = false // Always reset loading state when the operation completes
  }
}
</script>

<template>
  <div class="admin-create-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Tambah Admin Baru</h1>
        <p>Isi form di bawah untuk mendaftarkan admin baru.</p>
      </div>
    </div>

    <div class="card-container">
      <form @submit.prevent="saveAdmin">
        <h2 class="card-title">Detail Admin</h2>
        <div class="form-group">
          <label for="name">Nama Lengkap</label>
          <input
            type="text"
            id="name"
            v-model="adminData.name"
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
            v-model="adminData.email"
            placeholder="Masukkan alamat email admin"
            required
            class="form-input"
          />
          <div v-if="errors.email" class="error-text">{{ errors.email[0] }}</div>
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input
            type="password"
            id="password"
            v-model="adminData.password"
            placeholder="Buat password untuk admin"
            required
            class="form-input"
          />
          <div v-if="errors.password" class="error-text">{{ errors.password[0] }}</div>
        </div>
        <div class="form-group">
          <label for="password_confirmation">Konfirmasi Password</label>
          <input
            type="password"
            id="password_confirmation"
            v-model="adminData.password_confirmation"
            placeholder="Ulangi password Anda"
            required
            class="form-input"
          />
        </div>

        <div class="form-actions-end">
          <RouterLink :to="{ name: 'admins' }" class="cancel-button">Batal</RouterLink>
          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Menyimpan...</span>
            <span v-else>Simpan Admin</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.admin-create-view {
  padding: 1.5rem; /* Consistent page padding */
}

/* Page Header styles, consistent with other views */
.page-header {
  margin-bottom: 1.5rem; /* Space below the header */
}

.page-header h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e293b; /* Darker text for headings */
  margin: 0; /* Remove default margin */
}

.page-header p {
  color: #64748b; /* Muted text for descriptions */
  margin: 0.25rem 0 0; /* Small margin for sub-heading */
  font-size: 0.875rem; /* Smaller font size for description */
}

/* Card container for the form, consistent with other views */
.card-container {
  background-color: white;
  padding: 2rem;
  border-radius: 0.75rem; /* Rounded corners */
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05); /* Subtle shadow */
  max-width: 600px; /* Constrain width for better readability */
  margin: 0 auto; /* Center the card on the page */
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
  color: #94a3b8; /* Muted placeholder text */
}

.form-input:focus {
  outline: none;
  border-color: #a78bfa; /* Primary purple for focus */
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3); /* Soft glow on focus */
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
  background-color: #22c55e; /* Green 500 */
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s ease;
}

.submit-button:hover:not(:disabled) {
  background-color: #16a34a; /* Darker green on hover */
}

.submit-button:disabled {
  background-color: #a7f3d0; /* Lighter green when disabled */
  color: #065f46; /* Darker green text for disabled */
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
  font-size: 0.8125rem; /* Smaller font size */
  margin-top: 0.375rem; /* Space above the error message */
}

/* Responsive adjustments for smaller screens */
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
