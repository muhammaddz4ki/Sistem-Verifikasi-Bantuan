<!-- FILE: src/views/RecipientsView.vue -->
<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import api from '../services/api.js'
import VueQrcode from 'vue-qrcode'

const recipients = ref([])
const isLoading = ref(true)
const error = ref(null)
const showModal = ref(false)
const selectedQrValue = ref('')
const searchQuery = ref('')
const pagination = ref({})

async function loadRecipients(page = 1) {
  isLoading.value = true
  error.value = null
  try {
    const response = await api.getRecipients(page, searchQuery.value)
    recipients.value = response.data.data.data
    pagination.value = response.data.data
  } catch (err) {
    error.value = 'Gagal memuat data penerima.'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

function handleSearch() {
  loadRecipients(1)
}

async function deleteRecipient(id, name) {
  if (confirm(`Anda yakin ingin menghapus data "${name}"?`)) {
    try {
      await api.deleteRecipient(id)
      alert('Data berhasil dihapus.')
      loadRecipients(pagination.value.current_page || 1)
    } catch (err) {
      alert('Gagal menghapus data.')
      console.error(err)
    }
  }
}

onMounted(() => {
  loadRecipients()
})

function openQrModal(value) {
  selectedQrValue.value = value
  showModal.value = true
}

function downloadQr() {
  const svg = document.getElementById('modal-qr-code')
  if (!svg) return
  const serializer = new XMLSerializer()
  let source = serializer.serializeToString(svg)
  if (!source.match(/^<svg[^>]+xmlns="http:\/\/www\.w3\.org\/2000\/svg"/)) {
    source = source.replace(/^<svg/, '<svg xmlns="http://www.w3.org/2000/svg"')
  }
  if (!source.match(/^<svg[^>]+"http:\/\/www\.w3\.org\/1999\/xlink"/)) {
    source = source.replace(/^<svg/, '<svg xmlns:xlink="http://www.w3.org/1999/xlink"')
  }
  source = '<?xml version="1.0" standalone="no"?>\r\n' + source
  const url = 'data:image/svg+xml;charset=utf-8,' + encodeURIComponent(source)
  const downloadLink = document.createElement('a')
  downloadLink.href = url
  downloadLink.download = `qr-code-${selectedQrValue.value}.svg`
  document.body.appendChild(downloadLink)
  downloadLink.click()
  document.body.removeChild(downloadLink)
}
</script>

<template>
  <div class="recipients-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Data Penerima Bantuan</h1>
        <p>Kelola data penerima bantuan sosial</p>
      </div>
      <RouterLink to="/dashboard/penerima/tambah" class="add-button">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path
            d="M10.75 4.75a.75.75 0 00-1.5 0v4.5h-4.5a.75.75 0 000 1.5h4.5v4.5a.75.75 0 001.5 0v-4.5h4.5a.75.75 0 000-1.5h-4.5v-4.5z"
          />
        </svg>
        Tambah Penerima
      </RouterLink>
    </div>

    <div class="search-container">
      <div class="search-input-container">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path
            fill-rule="evenodd"
            d="M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z"
            clip-rule="evenodd"
          />
        </svg>
        <input
          type="text"
          v-model="searchQuery"
          placeholder="Cari penerima (NIK/Nama/Alamat)..."
          @keyup.enter="handleSearch"
        />
      </div>
      <button @click="handleSearch" class="search-button">Cari</button>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data penerima...</p>
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
      <button @click="loadRecipients()" class="retry-button">Coba Lagi</button>
    </div>

    <div v-else>
      <div class="card-container">
        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>ID</th>
                <th>NIK</th>
                <th>Nama Penerima</th>
                <th>Alamat</th>
                <th>QR Code</th>
                <th>Aksi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="!recipients || recipients.length === 0">
                <td colspan="6" class="empty-state">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h6.5a.75.75 0 000-1.5h-6.5z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <p>Tidak ada data penerima ditemukan</p>
                </td>
              </tr>
              <tr v-for="recipient in recipients" :key="recipient.id">
                <td>{{ recipient.id }}</td>
                <td>{{ recipient.nik }}</td>
                <td>{{ recipient.name }}</td>
                <td>{{ recipient.address }}</td>
                <td>
                  <div @click="openQrModal(recipient.qr_code_identifier)" class="qr-code">
                    <vue-qrcode
                      v-if="recipient.qr_code_identifier"
                      :value="recipient.qr_code_identifier"
                      :options="{ width: 60 }"
                      tag="svg"
                    />
                    <span class="qr-hover-text">Klik untuk memperbesar</span>
                  </div>
                </td>
                <td>
                  <div class="actions">
                    <RouterLink
                      :to="{ name: 'recipient-edit', params: { id: recipient.id } }"
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
                      @click="deleteRecipient(recipient.id, recipient.name)"
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

        <div class="pagination" v-if="pagination.last_page > 1">
          <button
            @click="loadRecipients(pagination.current_page - 1)"
            :disabled="!pagination.prev_page_url"
            class="pagination-button prev"
          >
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path
                fill-rule="evenodd"
                d="M12.79 5.23a.75.75 0 01-.02 1.06L8.832 10l3.938 3.71a.75.75 0 11-1.04 1.08l-4.5-4.25a.75.75 0 010-1.08l4.5-4.25a.75.75 0 011.06.02z"
                clip-rule="evenodd"
              />
            </svg>
            Sebelumnya
          </button>
          <div class="page-info">
            Halaman {{ pagination.current_page }} dari {{ pagination.last_page }}
          </div>
          <button
            @click="loadRecipients(pagination.current_page + 1)"
            :disabled="!pagination.next_page_url"
            class="pagination-button next"
          >
            Berikutnya
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
              <path
                fill-rule="evenodd"
                d="M7.21 14.77a.75.75 0 01.02-1.06L11.168 10 7.23 6.29a.75.75 0 111.04-1.08l4.5 4.25a.75.75 0 010 1.08l-4.5 4.25a.75.75 0 01-1.06-.02z"
                clip-rule="evenodd"
              />
            </svg>
          </button>
        </div>
      </div>
    </div>

    <!-- QR Code Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-content">
        <button class="modal-close" @click="showModal = false">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              d="M6.28 5.22a.75.75 0 00-1.06 1.06L8.94 10l-3.72 3.72a.75.75 0 101.06 1.06L10 11.06l3.72 3.72a.75.75 0 101.06-1.06L11.06 10l3.72-3.72a.75.75 0 00-1.06-1.06L10 8.94 6.28 5.22z"
            />
          </svg>
        </button>
        <h3>QR Code Penerima</h3>
        <div class="qr-code-preview">
          <vue-qrcode
            id="modal-qr-code"
            :value="selectedQrValue"
            :options="{ width: 250 }"
            tag="svg"
          />
        </div>
        <button @click="downloadQr" class="download-button">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              d="M10.75 2.75a.75.75 0 00-1.5 0v8.614L6.295 8.235a.75.75 0 10-1.09 1.03l4.25 4.5a.75.75 0 001.09 0l4.25-4.5a.75.75 0 00-1.09-1.03l-2.955 3.129V2.75z"
            />
            <path
              d="M3.5 12.75a.75.75 0 00-1.5 0v2.5A2.75 2.75 0 004.75 18h10.5A2.75 2.75 0 0018 15.25v-2.5a.75.75 0 00-1.5 0v2.5c0 .69-.56 1.25-1.25 1.25H4.75c-.69 0-1.25-.56-1.25-1.25v-2.5z"
            />
          </svg>
          Download QR Code
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.recipients-view {
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

/* Search Styles */
.search-container {
  display: flex;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.search-input-container {
  flex: 1;
  position: relative;
}

.search-input-container svg {
  position: absolute;
  left: 0.875rem;
  top: 50%;
  transform: translateY(-50%);
  width: 1rem;
  height: 1rem;
  color: #94a3b8;
}

.search-input-container input {
  width: 100%;
  padding: 0.625rem 1rem 0.625rem 2.5rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.5rem;
  background-color: #f8fafc;
  font-size: 0.875rem;
  transition: border-color 0.2s;
}

.search-input-container input:focus {
  outline: none;
  border-color: #c7d2fe;
  box-shadow: 0 0 0 3px rgba(199, 210, 254, 0.5);
}

.search-button {
  padding: 0.625rem 1.25rem;
  background-color: #4f46e5;
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.search-button:hover {
  background-color: #4338ca;
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

/* QR Code Styles */
.qr-code {
  position: relative;
  cursor: pointer;
  display: inline-block;
}

.qr-hover-text {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.7);
  color: white;
  font-size: 0.625rem;
  padding: 0.25rem;
  text-align: center;
  opacity: 0;
  transition: opacity 0.2s;
}

.qr-code:hover .qr-hover-text {
  opacity: 1;
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

/* Pagination Styles */
.pagination {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem;
  border-top: 1px solid #e2e8f0;
}

.page-info {
  color: #64748b;
  font-size: 0.875rem;
}

.pagination-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 0.375rem;
  color: #475569;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
}

.pagination-button:hover:not(:disabled) {
  background-color: #f8fafc;
  border-color: #cbd5e1;
}

.pagination-button:disabled {
  color: #cbd5e1;
  cursor: not-allowed;
}

.pagination-button svg {
  width: 1rem;
  height: 1rem;
}

/* Modal Styles */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background: white;
  padding: 2rem;
  border-radius: 0.75rem;
  text-align: center;
  position: relative;
  max-width: 90%;
  width: 400px;
}

.modal-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: transparent;
  border: none;
  padding: 0.25rem;
  cursor: pointer;
  color: #64748b;
}

.modal-close svg {
  width: 1.25rem;
  height: 1.25rem;
}

.modal-content h3 {
  margin: 0 0 1.5rem;
  color: #1e293b;
  font-size: 1.25rem;
}

.qr-code-preview {
  margin: 0 auto 1.5rem;
  padding: 0.5rem;
  background-color: white;
  border: 1px solid #e2e8f0;
  border-radius: 0.5rem;
  display: inline-block;
}

.download-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1.25rem;
  background-color: #4f46e5;
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.download-button:hover {
  background-color: #4338ca;
}

.download-button svg {
  width: 1rem;
  height: 1rem;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .search-container {
    flex-direction: column;
  }

  th,
  td {
    padding: 0.75rem;
  }
}
</style>
