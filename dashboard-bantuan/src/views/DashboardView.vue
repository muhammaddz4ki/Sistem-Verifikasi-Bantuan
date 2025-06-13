<!-- eslint-disable no-undef -->
<!-- FILE: src/views/DashboardView.vue -->
<script setup>
import { ref, onMounted, onUnmounted, nextTick } from 'vue'
import api from '../services/api.js'

const stats = ref(null)
const isLoading = ref(true)
const error = ref(null)

// Variabel untuk menyimpan instance chart
let dailyChartInstance = null
let statusChartInstance = null
let locationChartInstance = null

// Fungsi untuk membuat grafik
function createCharts() {
  if (!stats.value) return

  // Hancurkan chart lama jika ada, untuk mencegah duplikasi
  if (dailyChartInstance) dailyChartInstance.destroy()
  if (statusChartInstance) statusChartInstance.destroy()
  if (locationChartInstance) locationChartInstance.destroy()

  // 1. Grafik Verifikasi Harian (Bar Chart)
  const dailyCtx = document.getElementById('dailyVerificationChart').getContext('2d')
  const dailyLabels = Object.keys(stats.value.daily_verification_chart)
  const dailyData = Object.values(stats.value.daily_verification_chart)
  dailyChartInstance = new Chart(dailyCtx, {
    type: 'bar',
    data: {
      labels: dailyLabels,
      datasets: [
        {
          label: 'Jumlah Verifikasi',
          data: dailyData,
          backgroundColor: 'rgba(99, 102, 241, 0.7)',
          borderColor: 'rgba(79, 70, 229, 1)',
          borderWidth: 1,
          borderRadius: 4,
        },
      ],
    },
    options: {
      scales: {
        y: {
          beginAtZero: true,
          grid: {
            drawBorder: false,
            color: 'rgba(226, 232, 240, 0.5)',
          },
        },
        x: {
          grid: {
            display: false,
          },
        },
      },
      responsive: true,
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  })

  // 2. Grafik Status Verifikasi (Doughnut/Pie Chart)
  const statusCtx = document.getElementById('statusChart').getContext('2d')
  statusChartInstance = new Chart(statusCtx, {
    type: 'doughnut',
    data: {
      labels: ['Sudah Diverifikasi', 'Belum Diverifikasi'],
      datasets: [
        {
          data: [
            stats.value.verification_status.verified,
            stats.value.verification_status.not_verified,
          ],
          backgroundColor: ['rgba(16, 185, 129, 0.7)', 'rgba(239, 68, 68, 0.7)'],
          borderColor: ['#f8fafc', '#f8fafc'],
          borderWidth: 2,
        },
      ],
    },
    options: {
      responsive: true,
      cutout: '75%',
      plugins: {
        legend: {
          position: 'bottom',
          labels: {
            boxWidth: 12,
            padding: 20,
          },
        },
      },
    },
  })

  // 3. Grafik Lokasi Distribusi (Horizontal Bar Chart)
  const locationCtx = document.getElementById('locationChart').getContext('2d')
  const locationLabels = stats.value.location_distribution_chart.map((loc) => loc.address)
  const locationData = stats.value.location_distribution_chart.map((loc) => loc.count)
  locationChartInstance = new Chart(locationCtx, {
    type: 'bar',
    data: {
      labels: locationLabels,
      datasets: [
        {
          label: 'Jumlah Bantuan Diberikan',
          data: locationData,
          backgroundColor: 'rgba(245, 158, 11, 0.7)',
          borderColor: 'rgba(217, 119, 6, 1)',
          borderWidth: 1,
          borderRadius: 4,
        },
      ],
    },
    options: {
      indexAxis: 'y',
      responsive: true,
      scales: {
        x: {
          grid: {
            drawBorder: false,
            color: 'rgba(226, 232, 240, 0.5)',
          },
        },
        y: {
          grid: {
            display: false,
          },
        },
      },
      plugins: {
        legend: {
          display: false,
        },
      },
    },
  })
}

// Fungsi untuk memuat data statistik
async function loadStats() {
  isLoading.value = true
  error.value = null
  try {
    const response = await api.getDashboardStats()
    stats.value = response.data.data
    // Tunggu DOM update, baru buat chart
    await nextTick()
    createCharts()
  } catch (err) {
    error.value = 'Gagal memuat data dashboard.'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

onMounted(loadStats)

// Hancurkan chart saat komponen dibongkar untuk mencegah memory leak
onUnmounted(() => {
  if (dailyChartInstance) dailyChartInstance.destroy()
  if (statusChartInstance) statusChartInstance.destroy()
  if (locationChartInstance) locationChartInstance.destroy()
})
</script>

<template>
  <div class="dashboard-view">
    <div class="dashboard-header">
      <h1>Dashboard Overview</h1>
      <p class="subtitle">Ringkasan aktivitas dan statistik terbaru</p>
    </div>

    <div v-if="isLoading" class="loading-state">
      <div class="spinner"></div>
      <p>Memuat statistik...</p>
    </div>

    <div v-else-if="error" class="error-state">
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
        <path
          fill-rule="evenodd"
          d="M9.401 3.003c1.155-2 4.043-2 5.197 0l7.355 12.748c1.154 2-.29 4.5-2.599 4.5H4.645c-2.309 0-3.752-2.5-2.598-4.5L9.4 3.003zM12 8.25a.75.75 0 01.75.75v3.75a.75.75 0 01-1.5 0V9a.75.75 0 01.75-.75zm0 8.25a.75.75 0 100-1.5.75.75 0 000 1.5z"
          clip-rule="evenodd"
        />
      </svg>
      <p>{{ error }}</p>
      <button @click="loadStats" class="retry-button">Coba Lagi</button>
    </div>

    <div v-if="stats">
      <!-- Kartu Ringkasan Statistik -->
      <div class="stats-grid">
        <div class="stat-card">
          <div class="stat-icon" style="background-color: #e0f2fe">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#0369a1">
              <path
                d="M4.5 6.375a4.125 4.125 0 118.25 0 4.125 4.125 0 01-8.25 0zM14.25 8.625a3.375 3.375 0 116.75 0 3.375 3.375 0 01-6.75 0zM1.5 19.125a7.125 7.125 0 0114.25 0v.003l-.001.119a.75.75 0 01-.363.63 13.067 13.067 0 01-6.761 1.873c-2.472 0-4.786-.684-6.76-1.873a.75.75 0 01-.364-.63l-.001-.122zM17.25 19.128l-.001.144a2.25 2.25 0 01-.233.96 10.088 10.088 0 005.06-1.01.75.75 0 00.42-.643 4.875 4.875 0 00-6.957-4.611 8.586 8.586 0 011.71 5.157v.003z"
              />
            </svg>
          </div>
          <div class="stat-content">
            <span class="stat-label">Total Penerima</span>
            <span class="stat-value">{{ stats.summary.total_recipients }}</span>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background-color: #f0fdf4">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#15803d">
              <path
                fill-rule="evenodd"
                d="M8.25 6.75a3.75 3.75 0 117.5 0 3.75 3.75 0 01-7.5 0zM15.75 9.75a3 3 0 116 0 3 3 0 01-6 0zM2.25 9.75a3 3 0 116 0 3 3 0 01-6 0zM6.31 15.117A6.745 6.745 0 0112 12a6.745 6.745 0 016.709 7.498.75.75 0 01-.372.568A12.696 12.696 0 0112 21.75c-2.305 0-4.47-.612-6.337-1.684a.75.75 0 01-.372-.568 6.787 6.787 0 011.019-4.38z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <div class="stat-content">
            <span class="stat-label">Total Petugas</span>
            <span class="stat-value">{{ stats.summary.total_officers }}</span>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background-color: #fef2f2">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#b91c1c">
              <path
                fill-rule="evenodd"
                d="M9.568 3H5.25A2.25 2.25 0 003 5.25v4.318c0 .597.237 1.17.659 1.591l9.581 9.581c.699.699 1.78.872 2.607.33a18.095 18.095 0 005.223-5.223c.542-.827.369-1.908-.33-2.607L11.16 3.66A2.25 2.25 0 009.568 3z"
                clip-rule="evenodd"
              />
              <path d="M6 6h.008v.008H6V6z" />
            </svg>
          </div>
          <div class="stat-content">
            <span class="stat-label">Total Bantuan</span>
            <span class="stat-value">{{ stats.summary.total_verified }}</span>
          </div>
        </div>

        <div class="stat-card">
          <div class="stat-icon" style="background-color: #fff7ed">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="#c2410c">
              <path
                fill-rule="evenodd"
                d="M6.75 2.25A.75.75 0 017.5 3v1.5h9V3A.75.75 0 0118 3v1.5h.75a3 3 0 013 3v11.25a3 3 0 01-3 3H5.25a3 3 0 01-3-3V7.5a3 3 0 013-3H6V3a.75.75 0 01.75-.75zm13.5 9a1.5 1.5 0 00-1.5-1.5H5.25a1.5 1.5 0 00-1.5 1.5v7.5a1.5 1.5 0 001.5 1.5h13.5a1.5 1.5 0 001.5-1.5v-7.5z"
                clip-rule="evenodd"
              />
            </svg>
          </div>
          <div class="stat-content">
            <span class="stat-label">Verifikasi Hari Ini</span>
            <span class="stat-value">{{ stats.summary.today_verified }}</span>
          </div>
        </div>
      </div>

      <!-- Container untuk Grafik -->
      <div class="charts-grid">
        <div class="chart-container">
          <div class="chart-header">
            <h3>Verifikasi 7 Hari Terakhir</h3>
            <span class="chart-subtitle">Jumlah verifikasi per hari</span>
          </div>
          <div class="chart-wrapper">
            <canvas id="dailyVerificationChart"></canvas>
          </div>
        </div>

        <div class="chart-container">
          <div class="chart-header">
            <h3>Status Penerima</h3>
            <span class="chart-subtitle">Perbandingan status verifikasi</span>
          </div>
          <div class="chart-wrapper">
            <canvas id="statusChart"></canvas>
          </div>
        </div>

        <div class="chart-container wide">
          <div class="chart-header">
            <h3>Top 5 Lokasi Distribusi</h3>
            <span class="chart-subtitle">Distribusi berdasarkan lokasi</span>
          </div>
          <div class="chart-wrapper">
            <canvas id="locationChart"></canvas>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.dashboard-view {
  padding: 1.5rem;
}

.dashboard-header {
  margin-bottom: 2rem;
}

.dashboard-header h1 {
  font-size: 1.75rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0;
}

.dashboard-header .subtitle {
  color: #64748b;
  margin: 0.5rem 0 0;
  font-size: 0.9375rem;
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
  width: 3rem;
  height: 3rem;
  border: 4px solid rgba(99, 102, 241, 0.2);
  border-radius: 50%;
  border-top-color: #6366f1;
  animation: spin 1s linear infinite;
  margin-bottom: 1rem;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.loading-state p {
  color: #64748b;
  font-size: 0.9375rem;
}

/* Error State */
.error-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 3rem 0;
  text-align: center;
}

.error-state svg {
  width: 3rem;
  height: 3rem;
  color: #ef4444;
  margin-bottom: 1rem;
}

.error-state p {
  color: #64748b;
  font-size: 0.9375rem;
  margin-bottom: 1.5rem;
}

.error-state .retry-button {
  background-color: #6366f1;
  color: white;
  border: none;
  border-radius: 0.375rem;
  padding: 0.5rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s;
}

.error-state .retry-button:hover {
  background-color: #4f46e5;
}

/* Stats Grid */
.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1.25rem;
  margin-bottom: 2rem;
}

.stat-card {
  background-color: white;
  border-radius: 0.75rem;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  display: flex;
  align-items: center;
  gap: 1rem;
  transition:
    transform 0.2s,
    box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

.stat-icon {
  width: 3rem;
  height: 3rem;
  border-radius: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.stat-icon svg {
  width: 1.5rem;
  height: 1.5rem;
}

.stat-content {
  display: flex;
  flex-direction: column;
}

.stat-label {
  color: #64748b;
  font-size: 0.875rem;
  font-weight: 500;
}

.stat-value {
  color: #1e293b;
  font-size: 1.5rem;
  font-weight: 700;
  line-height: 1.2;
}

/* Charts Grid */
.charts-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.25rem;
}

.chart-container {
  background-color: white;
  border-radius: 0.75rem;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

.chart-container.wide {
  grid-column: span 3;
}

.chart-header {
  margin-bottom: 1.5rem;
}

.chart-header h3 {
  font-size: 1.125rem;
  font-weight: 600;
  color: #1e293b;
  margin: 0 0 0.25rem;
}

.chart-subtitle {
  color: #64748b;
  font-size: 0.8125rem;
}

.chart-wrapper {
  position: relative;
  height: 300px;
}

/* Responsive Styles */
@media (max-width: 1024px) {
  .charts-grid {
    grid-template-columns: 1fr 1fr;
  }

  .chart-container.wide {
    grid-column: span 2;
  }
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr 1fr;
  }

  .charts-grid {
    grid-template-columns: 1fr;
  }

  .chart-container.wide {
    grid-column: span 1;
  }
}

@media (max-width: 480px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
