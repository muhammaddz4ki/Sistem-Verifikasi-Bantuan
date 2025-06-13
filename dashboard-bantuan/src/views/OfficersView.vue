<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api.js'

const officers = ref([])
const isLoading = ref(true)
const error = ref(null)

// Function to load officer data
async function loadOfficers() {
  isLoading.value = true
  error.value = null
  try {
    const response = await api.getOfficers()
    // Assuming the API response structure is consistent with RecipientsView
    // i.e., response.data.data.data for the array of items
    officers.value = response.data.data.data
  } catch (err) {
    error.value = 'Gagal memuat data petugas.'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

// Function to delete officer data
async function deleteOfficer(id, name) {
  if (confirm(`Anda yakin ingin menghapus petugas "${name}"?`)) {
    try {
      await api.deleteOfficer(id)
      alert('Petugas berhasil dihapus.')
      loadOfficers() // Reload list after successful deletion
    } catch (err) {
      alert('Gagal menghapus petugas.')
      console.error(err)
    }
  }
}

// Call on component mount
onMounted(loadOfficers)
</script>

<template>
  <div class="officers-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Manajemen Data Petugas</h1>
        <p>Kelola data petugas yang mengelola bantuan sosial.</p>
      </div>
      <RouterLink :to="{ name: 'officer-add' }" class="add-button">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path
            d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z"
          />
        </svg>
        Tambah Petugas
      </RouterLink>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data petugas...</p>
    </div>

    <div v-else-if="error" class="error-state">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
        <path
          fill-rule="evenodd"
          d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
          clip-rule="evenodd"
        />
      </svg>
      <p>{{ error }}</p>
      <button @click="loadOfficers()" class="retry-button">Coba Lagi</button>
    </div>

    <div v-else>
      <div class="card-container">
        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>Nama</th>
                <th>Email</th>
                <th>Tanggal Dibuat</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="!officers || officers.length === 0">
                <td colspan="5" class="empty-state">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h6.5a.75.75 0 000-1.5h-6.5z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <p>Tidak ada data petugas ditemukan.</p>
                </td>
              </tr>
              <tr v-for="officer in officers" :key="officer.id">
                <td>{{ officer.id }}</td>
                <td>{{ officer.name }}</td>
                <td>{{ officer.email }}</td>
                <td>{{ new Date(officer.created_at).toLocaleDateString('id-ID') }}</td>
                <td>
                  <div class="actions">
                    <RouterLink
                      :to="{ name: 'officer-edit', params: { id: officer.id } }"
                      class="action-button edit"
                      title="Edit"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 20 20"
                        fill="currentColor"
                      >
                        <path
                          d="M5.433 13.917l1.262-3.155A4 4 0 017.58 9.42l6.92-6.918a2.121 2.121 0 013 3l-6.92 6.918c-.383.383-.84.685-1.343.886l-3.154 1.262a.5.5 0 01-.65-.65z"
                        />
                        <path
                          d="M3.5 5.75c0-.69.56-1.25 1.25-1.25H10A.75.75 0 0010 3H4.75A2.75 2.75 0 002 5.75v9.5A2.75 2.75 0 004.75 18h9.5A2.75 2.75 0 0017 15.25V10a.75.75 0 00-1.5 0v5.25c0 .69-.56 1.25-1.25 1.25h-9.5c-.69 0-1.25-.56-1.25-1.25v-9.5z"
                        />
                      </svg>
                    </RouterLink>
                    <button
                      @click="deleteOfficer(officer.id, officer.name)"
                      class="action-button delete"
                      title="Hapus"
                    >
                      <svg
                        xmlns="http://www.w3.org/2000/svg"
                        viewBox="0 0 20 20"
                        fill="currentColor"
                      >
                        <path
                          fill-rule="evenodd"
                          d="M8.75 1A2.75 2.75 0 006 3.75v.443c-.795.077-1.584.176-2.365.298a.75.75 0 10.23 1.482l.149-.022.841 10.518A2.75 2.75 0 007.596 19h4.807a2.75 2.75 0 002.742-2.53l.841-10.52.149.023a.75.75 0 00.23-1.482A41.03 41.03 0 0014 4.193V3.75A2.75 2.75 0 0011.25 1h-2.5zM10 4c.84 0 1.673.025 2.5.075V3.75c0-.69-.56-1.25-1.25-1.25h-2.5c-.69 0-1.25.56-1.25 1.25v.325C8.327 4.025 9.16 4 10 4zM8.58 7.72a.75.75 0 00-1.5.06l.3 7.5a.75.75 0 101.5-.06l-.3-7.5zm4.34.06a.75.75 0 10-1.5-.06l-.3 7.5a.75.75 0 101.5.06l.3-7.5z"
                          clip-rule="evenodd"
                        />
                      </svg>
                    </button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.officers-view {
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

.add-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  background-color: #4f46e5;
  color: white;
  padding: 0.625rem 1rem;
  border-radius: 0.5rem;
  font-weight: 500;
  text-decoration: none;
  transition: background-color 0.2s;
}

.add-button:hover {
  background-color: #4338ca;
}

.add-button svg {
  width: 1rem;
  height: 1rem;
}

/* Loading & Error States */
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

.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 0;
  text-align: center;
}

.error-state svg {
  width: 2.5rem;
  height: 2.5rem;
  color: #ef4444;
  margin-bottom: 1rem;
}

.error-state p {
  color: #64748b;
  margin-bottom: 1.5rem;
}

.retry-button {
  background-color: #4f46e5;
  color: white;
  padding: 0.5rem 1rem;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.retry-button:hover {
  background-color: #4338ca;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

/* Table Styles */
.card-container {
  background-color: white;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden;
}

.table-responsive {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background-color: #f8fafc;
  border-bottom: 1px solid #e2e8f0;
}

th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #475569;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #e2e8f0;
  color: #334155;
  font-size: 0.875rem;
}

.empty-state {
  padding: 3rem 1rem;
  text-align: center;
}

.empty-state svg {
  width: 2.5rem;
  height: 2.5rem;
  color: #94a3b8;
  margin-bottom: 1rem;
}

.empty-state p {
  color: #64748b;
  margin: 0;
}

/* Action Buttons */
.actions {
  display: flex;
  gap: 0.5rem;
}

.action-button {
  width: 2rem;
  height: 2rem;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 0.375rem;
  transition: background-color 0.2s;
}

.action-button svg {
  width: 1rem;
  height: 1rem;
}

.action-button.edit {
  background-color: #fef3c7;
  color: #d97706;
}

.action-button.edit:hover {
  background-color: #fde68a;
}

.action-button.delete {
  background-color: #fee2e2;
  color: #dc2626;
}

.action-button.delete:hover {
  background-color: #fecaca;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  th,
  td {
    padding: 0.75rem;
  }
}
</style>
