<script setup>
import { ref, onMounted, computed } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api.js'

const admins = ref([])
const isLoading = ref(true)
const error = ref(null)

// --- GET LOGGED-IN USER DATA ---
const loggedInUser = computed(() => {
  const userString = localStorage.getItem('user')
  return userString ? JSON.parse(userString) : null
})

/**
 * Loads admin data from the API.
 */
async function loadAdmins() {
  isLoading.value = true
  error.value = null
  try {
    const response = await api.getAdmins()
    admins.value = response.data.data.data
  } catch (err) {
    error.value = 'Gagal memuat data admin.'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

/**
 * Deletes an admin after confirmation.
 * @param {number} id The ID of the admin to delete.
 * @param {string} name The name of the admin to display in the confirmation.
 */
async function deleteAdmin(id, name) {
  if (confirm(`Anda yakin ingin menghapus admin "${name}"?`)) {
    try {
      await api.deleteAdmin(id)
      alert('Admin berhasil dihapus.')
      loadAdmins() // Reload the list after successful deletion
    } catch (err) {
      alert('Gagal menghapus admin.')
      console.error(err)
    }
  }
}

// Load admins when the component is mounted
onMounted(loadAdmins)
</script>

<template>
  <div class="admins-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Manajemen Data Admin</h1>
        <p>Di sini Anda bisa melihat, menambah, mengubah, dan menghapus data admin lain.</p>
      </div>
      <RouterLink :to="{ name: 'admin-add' }" class="add-button">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path
            d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z"
          />
        </svg>
        <span>Tambah Admin Baru</span>
      </RouterLink>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data admin...</p>
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
      <button @click="loadAdmins()" class="retry-button">Coba Lagi</button>
    </div>

    <div v-else class="card-container">
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
            <tr v-if="!admins || admins.length === 0">
              <td colspan="5" class="empty-state">
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h6.5a.75.75 0 000-1.5h-6.5z"
                    clip-rule="evenodd"
                  />
                </svg>
                <p>Tidak ada data admin.</p>
              </td>
            </tr>
            <tr v-for="admin in admins" :key="admin.id">
              <td>{{ admin.id }}</td>
              <td>
                {{ admin.name }}
                <span v-if="loggedInUser && loggedInUser.id === admin.id" class="self-indicator"
                  >(Anda)</span
                >
              </td>
              <td>{{ admin.email }}</td>
              <td>{{ new Date(admin.created_at).toLocaleDateString('id-ID') }}</td>
              <td>
                <div class="action-buttons">
                  <template v-if="loggedInUser && loggedInUser.id !== admin.id">
                    <RouterLink
                      :to="{ name: 'admin-edit', params: { id: admin.id } }"
                      class="action-btn edit-btn"
                      title="Ubah Admin"
                    >
                      <svg class="btn-icon" viewBox="0 0 20 20" fill="currentColor">
                        <path
                          d="M17.414 2.586a2 2 0 00-2.828 0L7 10.172V13h2.828l7.586-7.586a2 2 0 000-2.828z"
                        />
                        <path
                          fill-rule="evenodd"
                          d="M2 6a2 2 0 012-2h4a1 1 0 010 2H4v10h10v-4a1 1 0 112 0v4a2 2 0 01-2 2H4a2 2 0 01-2-2V6z"
                          clip-rule="evenodd"
                        />
                      </svg>
                    </RouterLink>
                    <button
                      @click="deleteAdmin(admin.id, admin.name)"
                      class="action-btn delete-btn"
                      title="Hapus Admin"
                    >
                      <svg class="btn-icon" viewBox="0 0 20 20" fill="currentColor">
                        <path
                          fill-rule="evenodd"
                          d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm4 0a1 1 0 012 0v6a1 1 0 11-2 0V8z"
                          clip-rule="evenodd"
                        />
                      </svg>
                    </button>
                  </template>
                  <span v-else class="self-action-text"> Ubah di Profil </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<style scoped>
.admins-view {
  padding: 1.5rem;
}

/* Page Header Styles */
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

/* Add New Button */
.add-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  background-color: #4f46e5; /* Indigo 600 */
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  text-decoration: none;
  transition: background-color 0.2s ease;
  font-size: 0.9375rem;
}

.add-button:hover {
  background-color: #4338ca; /* Indigo 700 */
}

.add-button svg {
  width: 1.25rem;
  height: 1.25rem;
}

/* Loading State (from other views) */
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

/* Error State (from other views) */
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
  color: #ef4444; /* Red 500 */
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

/* Card Container for Table */
.card-container {
  background-color: white;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow: hidden; /* Ensures borders are rounded */
}

.table-responsive {
  overflow-x: auto; /* Allows table to scroll horizontally on small screens */
}

/* Table Styles */
table {
  width: 100%;
  border-collapse: collapse;
}

thead {
  background-color: #f8fafc; /* Slate 50 */
  border-bottom: 1px solid #e2e8f0; /* Slate 200 */
}

th {
  padding: 1rem;
  text-align: left;
  font-weight: 600;
  color: #475569; /* Slate 600 */
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #e2e8f0; /* Slate 200 */
  color: #334155; /* Slate 800 */
  font-size: 0.875rem;
}

tr:last-child td {
  border-bottom: none; /* No border for the last row */
}

.empty-state {
  padding: 3rem 1rem;
  text-align: center;
}

.empty-state svg {
  width: 2.5rem;
  height: 2.5rem;
  color: #94a3b8; /* Slate 400 */
  margin-bottom: 1rem;
}

.empty-state p {
  color: #64748b; /* Slate 500 */
  margin: 0;
}

/* Action Buttons in Table */
.action-buttons {
  display: flex;
  gap: 0.5rem;
}

.action-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 0.625rem; /* Equivalent to 10px */
  border: none;
  border-radius: 0.375rem; /* Equivalent to 6px */
  color: white;
  cursor: pointer;
  text-decoration: none;
  transition:
    background-color 0.2s ease,
    transform 0.2s ease,
    box-shadow 0.2s ease;
}

.action-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.edit-btn {
  background-color: #f59e0b; /* Amber 500 */
}

.edit-btn:hover {
  background-color: #d97706; /* Amber 600 */
}

.delete-btn {
  background-color: #ef4444; /* Red 500 */
}

.delete-btn:hover {
  background-color: #dc2626; /* Red 600 */
}

.btn-icon {
  width: 1rem; /* Equivalent to 16px */
  height: 1rem; /* Equivalent to 16px */
}

/* Self Indicator & Action Text */
.self-indicator {
  font-size: 0.75rem; /* Smaller font size */
  font-weight: 600; /* Bolder */
  color: #065f46; /* Green 800 */
  margin-left: 0.5rem; /* Space from name */
  background-color: #d1fae5; /* Green 100 */
  padding: 0.125rem 0.5rem; /* Smaller padding */
  border-radius: 9999px; /* Pill shape */
}

.self-action-text {
  font-style: italic;
  color: #64748b; /* Slate 500 */
  font-size: 0.8125rem; /* Slightly smaller text */
  padding: 0.625rem; /* Match button padding for alignment */
  display: inline-block; /* Ensure padding applies */
}

/* Responsive adjustments */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .add-button {
    width: 100%;
    justify-content: center;
  }

  th,
  td {
    padding: 0.75rem;
  }

  .action-buttons {
    justify-content: flex-start; /* Align buttons to the left */
  }
}
</style>
