<script setup>
import { ref } from 'vue'
import api from '../services/api.js'
import { useRouter } from 'vue-router'

const router = useRouter()
const recipient = ref({
  nik: '',
  name: '',
  address: '',
})
const errors = ref({})
const isLoading = ref(false)

async function saveRecipient() {
  isLoading.value = true
  errors.value = {}

  try {
    await api.storeRecipient(recipient.value)
    alert('Data penerima berhasil ditambahkan!')
    router.push({ name: 'recipients' }) // Kembali ke daftar penerima
  } catch (err) {
    if (err.response && err.response.status === 422) {
      errors.value = err.response.data.errors
    } else {
      alert('Terjadi kesalahan saat menyimpan data.')
    }
    console.error(err)
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="add-recipient-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Tambah Data Penerima Baru</h1>
        <p>Formulir untuk menambahkan penerima bantuan sosial baru</p>
      </div>
    </div>

    <div class="card-container">
      <form @submit.prevent="saveRecipient" class="form-grid">
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
          <label for="name">Nama</label>
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
            <span v-if="isLoading">Menyimpan...</span>
            <span v-else>Simpan Data</span>
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.add-recipient-view {
  padding: 1.5rem;
}

/* Header Styles (from RecipientsView) */
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

/* Card Container (similar to RecipientsView's table container) */
.card-container {
  background-color: white;
  padding: 2rem; /* Adjusted padding for forms */
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  max-width: 700px; /* Limit width for better form presentation */
  margin-left: auto;
  margin-right: auto;
}

/* Form Layout */
.form-grid {
  display: grid;
  gap: 1.25rem; /* Consistent gap */
  grid-template-columns: 1fr 1fr; /* Two columns by default */
}

.form-group {
  margin-bottom: 0; /* Override default margin to use grid gap */
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  font-weight: 500; /* Medium font weight */
  color: #475569; /* Slate 600 */
  font-size: 0.875rem; /* Smaller label font size */
}

.form-input,
.form-textarea {
  width: 100%;
  padding: 0.75rem 1rem; /* Consistent padding */
  border: 1px solid #e2e8f0; /* Border color from RecipientsView */
  border-radius: 0.5rem; /* Rounded corners */
  background-color: #f8fafc; /* Light background */
  font-size: 0.875rem; /* Smaller font size */
  color: #334155; /* Slate 700 */
  box-sizing: border-box;
  transition:
    border-color 0.2s,
    box-shadow 0.2s;
}

.form-input::placeholder,
.form-textarea::placeholder {
  color: #94a3b8; /* Placeholder color */
}

.form-input:focus,
.form-textarea:focus {
  outline: none;
  border-color: #a78bfa; /* Violet 400 - slightly lighter than button for focus */
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3); /* Soft glow */
}

.full-width {
  grid-column: 1 / -1; /* Make element span full width in grid */
}

.form-actions {
  display: flex;
  justify-content: flex-end; /* Align button to the right */
  padding-top: 0.5rem; /* Space above button */
}

.submit-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.75rem 1.5rem; /* Larger padding for main button */
  background-color: #4f46e5; /* Primary purple color */
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 1rem; /* Standard font size */
  transition: background-color 0.2s ease;
}

.submit-button:hover:not(:disabled) {
  background-color: #4338ca;
}

.submit-button:disabled {
  background-color: #cbd5e1; /* Gray for disabled */
  color: #94a3b8; /* Darker gray text for disabled */
  cursor: not-allowed;
  opacity: 0.8; /* Slightly transparent */
}

/* Error Text (from previous code) */
.error-text {
  color: #ef4444; /* Tailwind's red-500 */
  font-size: 0.8125rem; /* Slightly smaller for error messages */
  margin-top: 0.375rem; /* Smaller top margin */
}

/* Responsive Styles */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .card-container {
    padding: 1.5rem; /* Reduce padding on smaller screens */
  }

  .form-grid {
    grid-template-columns: 1fr; /* Single column layout on small screens */
  }

  .form-actions {
    justify-content: stretch; /* Stretch button to full width */
  }

  .submit-button {
    width: 100%; /* Full width button on small screens */
  }
}
</style>
