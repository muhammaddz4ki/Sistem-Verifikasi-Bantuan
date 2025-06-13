<!-- FILE: src/views/EditRecipientView.vue -->
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
const recipient = ref({}) // Empty object to hold recipient data
const errors = ref({})
const isLoading = ref(true) // Start with loading state as data needs to be fetched

/**
 * Fetches the recipient data from the API when the component is mounted.
 * Populates the form fields with the fetched data.
 */
onMounted(async () => {
  try {
    const response = await api.getRecipient(props.id)
    recipient.value = response.data.data // Fill form with data from API
  } catch (err) {
    alert('Gagal memuat data untuk diedit.')
    console.error(err)
    router.push({ name: 'recipients' }) // Redirect back to list if data fetching fails
  } finally {
    isLoading.value = false // End loading state
  }
})

/**
 * Sends the updated recipient data to the API.
 * Handles success/error messages and redirects on success.
 */
async function updateRecipient() {
  isLoading.value = true // Set loading state for update operation
  errors.value = {} // Clear previous validation errors
  try {
    await api.updateRecipient(props.id, recipient.value)
    alert('Data penerima berhasil diperbarui!') // Success alert
    router.push({ name: 'recipients' }) // Redirect back to the recipients list after successful update
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
  <div class="edit-recipient-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Ubah Data Penerima</h1>
        <p>Perbarui informasi penerima di bawah ini.</p>
      </div>
      <!-- Optional: Add a back button if needed -->
      <!-- <button @click="router.back()" class="back-button">Kembali</button> -->
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data penerima...</p>
    </div>

    <div v-else class="card-container">
      <form @submit.prevent="updateRecipient" class="form-grid">
        <div class="form-group">
          <label for="nik">NIK</label>
          <input
            type="text"
            id="nik"
            v-model="recipient.nik"
            placeholder="Masukkan 16 digit NIK"
            required
            class="form-input"
          />
          <div v-if="errors.nik" class="error-text">{{ errors.nik[0] }}</div>
        </div>
        <div class="form-group">
          <label for="name">Nama Lengkap</label>
          <input
            type="text"
            id="name"
            v-model="recipient.name"
            placeholder="Masukkan nama lengkap penerima"
            required
            class="form-input"
          />
          <div v-if="errors.name" class="error-text">{{ errors.name[0] }}</div>
        </div>
        <div class="form-group full-width">
          <label for="address">Alamat</label>
          <textarea
            id="address"
            v-model="recipient.address"
            rows="3"
            placeholder="Masukkan alamat lengkap penerima"
            required
            class="form-textarea"
          ></textarea>
          <div v-if="errors.address" class="error-text">{{ errors.address[0] }}</div>
        </div>
        <div class="form-actions full-width">
          <button type="submit" :disabled="isLoading" class="submit-button">
            <span v-if="isLoading">Memperbarui...</span>
            <span v-else>Perbarui Data</span>
          </button>
          <RouterLink :to="{ name: 'recipients' }" class="cancel-button">Batal</RouterLink>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.edit-recipient-view {
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
  grid-template-columns: 1fr 1fr;
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
  grid-column: 1 / -1;
}

.form-actions {
  display: flex;
  gap: 0.75rem; /* Gap between buttons */
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
  text-decoration: none; /* For RouterLink */
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

  .form-grid {
    grid-template-columns: 1fr;
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
