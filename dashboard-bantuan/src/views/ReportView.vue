<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api.js'

const history = ref([])
const isLoading = ref(true)
const error = ref(null)
const pagination = ref({})
const isExporting = ref(false)

// --- NEW STATE FOR DATE FILTERS ---
const startDate = ref('')
const endDate = ref('')

/**
 * Loads verification history data from the API.
 * Includes pagination and optional date filters.
 * @param {number} page The page number to load. Defaults to 1.
 */
async function loadHistory(page = 1) {
  isLoading.value = true
  error.value = null
  try {
    // Send selected dates to the API
    const response = await api.getVerificationHistory(page, startDate.value, endDate.value)
    history.value = response.data.data.data
    pagination.value = response.data.data
  } catch (err) {
    error.value = 'Gagal memuat riwayat verifikasi.'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

/**
 * Applies the date filter and reloads history from the first page.
 */
function applyFilter() {
  // Always start from page 1 when a new filter is applied
  loadHistory(1)
}

/**
 * Exports verification history data to CSV or PDF based on the selected format
 * and current date filters.
 * @param {'csv' | 'pdf'} format The desired export format.
 */
async function exportData(format) {
  isExporting.value = true
  try {
    // Send selected dates to the export API
    const response = await api.getVerificationHistoryForExport(startDate.value, endDate.value)
    const allData = response.data.data

    if (allData.length === 0) {
      alert('Tidak ada data untuk diekspor pada rentang tanggal ini.')
      return
    }

    if (format === 'csv') {
      exportToCSV(allData)
    } else if (format === 'pdf') {
      exportToPDF(allData)
    }
  } catch (err) {
    alert('Gagal mengambil data untuk ekspor.')
    console.error(err)
  } finally {
    isExporting.value = false
  }
}

/**
 * Exports the provided data to a CSV file.
 * @param {Array<Object>} data The array of objects to export.
 */
function exportToCSV(data) {
  const headers = [
    'ID Verifikasi',
    'Nama Penerima',
    'NIK Penerima',
    'Diverifikasi Oleh',
    'Status',
    'Waktu Verifikasi',
  ]
  const rows = data.map((item) => [
    `"${item.id}"`,
    `"${item.recipient?.name || 'N/A'}"`,
    `"'${item.recipient?.nik || 'N/A'}'"`, // Add single quote to NIK to prevent Excel auto-formatting
    `"${item.user?.name || 'N/A'}"`,
    `"${item.status}"`,
    `"${new Date(item.verified_at).toLocaleString('id-ID')}"`,
  ])
  let csvContent =
    'data:text/csv;charset=utf-8,' +
    headers.join(',') +
    '\n' +
    rows.map((e) => e.join(',')).join('\n')
  const encodedUri = encodeURI(csvContent)
  const link = document.createElement('a')
  link.setAttribute('href', encodedUri)
  link.setAttribute('download', 'laporan_verifikasi.csv')
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

/**
 * Exports the provided data to a PDF file using jsPDF (assumes jspdf is loaded globally).
 * @param {Array<Object>} data The array of objects to export.
 */
function exportToPDF(data) {
  // Ensure jsPDF library is available in the global scope
  const { jsPDF } = window.jspdf
  const doc = new jsPDF()

  // Set document title and font size
  doc.setFontSize(18)
  doc.text('Laporan Riwayat Verifikasi', 14, 22)

  // Define table columns and rows
  const tableColumn = ['ID', 'Nama Penerima', 'NIK', 'Petugas', 'Status', 'Waktu']
  const tableRows = []
  data.forEach((item) => {
    const rowData = [
      item.id,
      item.recipient?.name || 'N/A',
      item.recipient?.nik || 'N/A',
      item.user?.name || 'N/A',
      item.status,
      new Date(item.verified_at).toLocaleString('id-ID', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
      }),
    ]
    tableRows.push(rowData)
  })

  // Generate table using autoTable plugin (assumes jspdf-autotable is loaded)
  doc.autoTable(tableColumn, tableRows, { startY: 30 })

  // Save the PDF
  doc.save('laporan_verifikasi.pdf')
}

// Load history when the component is mounted
onMounted(loadHistory)
</script>

<template>
  <div class="report-view">
    <div class="page-header">
      <div class="header-content">
        <h1>Laporan Riwayat Verifikasi</h1>
        <p>Di bawah ini adalah catatan semua verifikasi yang telah dilakukan.</p>
      </div>
      <div class="export-buttons">
        <button @click="exportData('csv')" :disabled="isExporting" class="export-button csv">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M.75 6.75C.75 5.645 1.645 4.75 2.75 4.75h14.5c1.105 0 2 .895 2 2v6.5A2.75 2.75 0 0117.25 16h-14.5A2.75 2.75 0 01.75 13.25v-6.5zM17.25 6.25a.75.75 0 000 1.5h-.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75H9.75a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75H2.75a1.25 1.25 0 00-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h14.5c.69 0 1.25-.56 1.25-1.25v-6.5a1.25 1.25 0 00-1.25-1.25H17.25zM2.75 7.25a.75.75 0 000 1.5H.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75H2.75zM19.25 7.25a.75.75 0 000 1.5h-2a.75.75 0 000-1.5h2z"
              clip-rule="evenodd"
            />
          </svg>
          <span class="button-text">Ekspor CSV</span>
        </button>
        <button @click="exportData('pdf')" :disabled="isExporting" class="export-button pdf">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M.75 6.75C.75 5.645 1.645 4.75 2.75 4.75h14.5c1.105 0 2 .895 2 2v6.5A2.75 2.75 0 0117.25 16h-14.5A2.75 2.75 0 01.75 13.25v-6.5zM17.25 6.25a.75.75 0 000 1.5h-.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75v.008a.75.75 0 00-.75.75H9.75a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75H2.75a1.25 1.25 0 00-1.25 1.25v6.5c0 .69.56 1.25 1.25 1.25h14.5c.69 0 1.25-.56 1.25-1.25v-6.5a1.25 1.25 0 00-1.25-1.25H17.25zM2.75 7.25a.75.75 0 000 1.5H.75v-.008a.75.75 0 00-.75-.75v-.008a.75.75 0 00-.75-.75H2.75zM19.25 7.25a.75.75 0 000 1.5h-2a.75.75 0 000-1.5h2z"
              clip-rule="evenodd"
            />
          </svg>
          <span class="button-text">Ekspor PDF</span>
        </button>
      </div>
    </div>

    <div class="card-container filter-section">
      <div class="filter-group">
        <label for="start_date">Dari Tanggal</label>
        <input type="date" id="start_date" v-model="startDate" class="form-input date-input" />
      </div>
      <div class="filter-group">
        <label for="end_date">Sampai Tanggal</label>
        <input type="date" id="end_date" v-model="endDate" class="form-input date-input" />
      </div>
      <button @click="applyFilter" class="filter-button">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
          <path
            fill-rule="evenodd"
            d="M2.628 1.602A.75.75 0 013.5.75h13a.75.75 0 01.872.852l-2.428 8.163a4.5 4.5 0 00-.108.369c-.067.243-.16.48-.27.708a.75.75 0 01-.19.22l-4.225 4.225a.75.75 0 01-1.06 0L6.155 11.23a.75.75 0 01-.19-.22 4.5 4.5 0 00-.27-.708l-2.428-8.163zM1.872 1.602A2.25 2.25 0 013.5-.75h13a2.25 2.25 0 012.122 2.352l-2.428 8.163a6 6 0 01-.144.484 2.25 2.25 0 01-.365.719L11.53 16.89a2.25 2.25 0 01-3.182 0L3.063 11.084a2.25 2.25 0 01-.365-.72A6 6 0 012.628 9.765L.506 1.602z"
            clip-rule="evenodd"
          />
        </svg>
        <span>Terapkan Filter</span>
      </button>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat data...</p>
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
      <button @click="loadHistory()" class="retry-button">Coba Lagi</button>
    </div>
    <div v-else>
      <div class="card-container">
        <div class="table-responsive">
          <table>
            <thead>
              <tr>
                <th>ID Verifikasi</th>
                <th>Nama Penerima</th>
                <th>NIK Penerima</th>
                <th>Diverifikasi oleh (Petugas)</th>
                <th>Status</th>
                <th>Waktu Verifikasi</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="!history || history.length === 0">
                <td colspan="6" class="empty-state">
                  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                    <path
                      fill-rule="evenodd"
                      d="M10 18a8 8 0 100-16 8 8 0 000 16zM6.75 9.25a.75.75 0 000 1.5h6.5a.75.75 0 000-1.5h-6.5z"
                      clip-rule="evenodd"
                    />
                  </svg>
                  <p>Tidak ada riwayat verifikasi pada rentang tanggal ini.</p>
                </td>
              </tr>
              <tr v-for="item in history" :key="item.id">
                <td>{{ item.id }}</td>
                <td>{{ item.recipient ? item.recipient.name : 'Data Dihapus' }}</td>
                <td>{{ item.recipient ? item.recipient.nik : '-' }}</td>
                <td>{{ item.user ? item.user.name : 'Data Dihapus' }}</td>
                <td>
                  <span
                    class="status-badge"
                    :class="{
                      'status-granted': item.status === 'diberikan',
                      'status-rejected': item.status === 'ditolak',
                    }"
                  >
                    {{ item.status }}
                  </span>
                </td>
                <td>
                  {{
                    new Date(item.verified_at).toLocaleString('id-ID', {
                      dateStyle: 'long',
                      timeStyle: 'short',
                    })
                  }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="pagination-container" v-if="pagination.last_page > 1">
        <button
          @click="loadHistory(pagination.current_page - 1)"
          :disabled="!pagination.prev_page_url"
          class="pagination-button"
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M11.72 9.47a.75.75 0 010 1.06L7.439 15.25a.75.75 0 01-1.06-1.06l3.72-3.72L6.379 6.81a.75.75 0 111.06-1.06l4.281 4.28z"
              clip-rule="evenodd"
            />
          </svg>
          <span>Sebelumnya</span>
        </button>
        <span class="pagination-info"
          >Halaman {{ pagination.current_page }} dari {{ pagination.last_page }}</span
        >
        <button
          @click="loadHistory(pagination.current_page + 1)"
          :disabled="!pagination.next_page_url"
          class="pagination-button"
        >
          <span>Berikutnya</span>
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M8.28 9.47a.75.75 0 010 1.06l4.28 4.28a.75.75 0 11-1.06 1.06L7.16 10.53a.75.75 0 010-1.06l4.28-4.28a.75.75 0 011.06 1.06L8.28 9.47z"
              clip-rule="evenodd"
            />
          </svg>
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
.report-view {
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

/* Export Buttons */
.export-buttons {
  display: flex;
  gap: 0.75rem;
}

.export-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1rem;
  border-radius: 0.5rem;
  font-weight: 500;
  text-decoration: none;
  transition: background-color 0.2s;
  border: none;
  cursor: pointer;
  color: white;
}

.export-button svg {
  width: 1.125rem;
  height: 1.125rem;
}

.export-button.csv {
  background-color: #0d9488; /* Teal 600 */
}

.export-button.csv:hover:not(:disabled) {
  background-color: #0f766e; /* Darker Teal */
}

.export-button.pdf {
  background-color: #dc2626; /* Red 600 */
}

.export-button.pdf:hover:not(:disabled) {
  background-color: #b91c1c; /* Darker Red */
}

.export-button:disabled {
  background-color: #cbd5e1; /* Gray 300 */
  color: #94a3b8; /* Gray 400 */
  cursor: not-allowed;
  opacity: 0.8;
}

/* Filter Section */
.filter-section {
  display: flex;
  align-items: flex-end; /* Align button with input bottom */
  gap: 1rem; /* Space between filter groups and button */
  padding: 1.5rem; /* Consistent padding with card-container */
  margin-bottom: 1.5rem; /* Space below the filter section */
}

.filter-group {
  display: flex;
  flex-direction: column;
  flex-grow: 1; /* Allow groups to grow */
}

.filter-group label {
  font-size: 0.875rem;
  color: #475569;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.form-input {
  /* Re-use from other forms */
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

.form-input:focus {
  outline: none;
  border-color: #a78bfa;
  box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3);
}

.filter-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.25rem;
  background-color: #4f46e5; /* Primary purple */
  color: white;
  border: none;
  border-radius: 0.5rem;
  font-weight: 500;
  cursor: pointer;
  font-size: 0.9375rem;
  transition: background-color 0.2s ease;
}

.filter-button svg {
  width: 1rem;
  height: 1rem;
}

.filter-button:hover {
  background-color: #4338ca;
}

/* Loading & Error States (from other views) */
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

/* Table Styles (from other views) */
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

/* Status Badges */
.status-badge {
  display: inline-flex;
  align-items: center;
  padding: 0.3em 0.6em;
  border-radius: 9999px; /* Pill shape */
  font-weight: 600;
  color: white;
  font-size: 0.75em;
  text-transform: capitalize;
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
}

.status-granted {
  background-color: #10b981; /* Green 500 */
}

.status-rejected {
  background-color: #ef4444; /* Red 500 */
}

/* Pagination Styles (from other views) */
.pagination-container {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 1rem;
  margin-top: 1.5rem;
  padding: 1rem;
  background-color: white;
  border-radius: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.pagination-button {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.5rem 1rem;
  background-color: #f1f5f9; /* Slate 100 */
  color: #475569; /* Slate 600 */
  border: 1px solid #e2e8f0; /* Slate 200 */
  border-radius: 0.5rem;
  cursor: pointer;
  font-weight: 500;
  transition:
    background-color 0.2s,
    border-color 0.2s;
}

.pagination-button:hover:not(:disabled) {
  background-color: #e2e8f0; /* Slate 200 */
  border-color: #cbd5e1; /* Slate 300 */
}

.pagination-button:disabled {
  background-color: #f8fafc;
  color: #cbd5e1;
  cursor: not-allowed;
  opacity: 0.7;
}

.pagination-button svg {
  width: 1rem;
  height: 1rem;
}

.pagination-info {
  font-size: 0.875rem;
  color: #64748b;
}

/* Responsive Styles */
@media (max-width: 768px) {
  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 1rem;
  }

  .export-buttons {
    width: 100%;
    justify-content: stretch;
  }

  .export-button {
    flex-grow: 1;
    justify-content: center;
  }

  .filter-section {
    flex-direction: column;
    align-items: stretch;
  }

  .filter-button {
    width: 100%;
    justify-content: center;
  }

  th,
  td {
    padding: 0.75rem;
  }

  .button-text {
    display: inline; /* Show text on small screens */
  }
}

@media (max-width: 480px) {
  .export-button .button-text {
    display: none; /* Hide text, show only icon on very small screens */
  }
  .export-button svg {
    margin: 0;
  }
  .export-button {
    padding: 0.625rem; /* Smaller padding for icon-only buttons */
  }
}
</style>
