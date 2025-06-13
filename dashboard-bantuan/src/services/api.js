import axios from 'axios'

// Menggunakan konfigurasi Anda
const apiClient = axios.create({
  baseURL: 'http://192.168.100.41:8000/api',
  headers: { Accept: 'application/json', 'Content-Type': 'application/json' },
})

// Menggunakan interceptor Anda dengan key 'authToken'
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('authToken')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export default {
  // --- Fungsi yang sudah ada ---
  login(credentials) {
    return apiClient.post('/login', credentials)
  },
  getRecipients(page = 1, search = '') {
    // Kirim parameter sebagai query string di URL
    return apiClient.get(`/recipients?page=${page}&search=${search}`)
  },
  storeRecipient(data) {
    return apiClient.post('/recipients', data)
  },

  // --- FUNGSI BARU DITAMBAHKAN DI SINI ---

  // 1. Mengambil SATU data (untuk halaman Edit)
  getRecipient(id) {
    return apiClient.get(`/recipients/${id}`)
  },

  // 2. Mengirim PERUBAHAN data (untuk halaman Edit)
  updateRecipient(id, data) {
    return apiClient.put(`/recipients/${id}`, data)
  },

  // 3. MENGHAPUS data
  deleteRecipient(id) {
    return apiClient.delete(`/recipients/${id}`)
  },

  getOfficers(page = 1, search = '') {
    return apiClient.get(`/officers?page=${page}&search=${search}`)
  },
  getOfficer(id) {
    return apiClient.get(`/officers/${id}`)
  },
  createOfficer(data) {
    return apiClient.post('/officers', data)
  },
  updateOfficer(id, data) {
    // Di HTML form, method PUT kadang bermasalah, jadi kita pakai POST
    // dan tambahkan _method: 'PUT' di datanya. Laravel akan mengerti.
    const formData = new FormData()
    formData.append('name', data.name)
    formData.append('email', data.email)
    if (data.password) {
      formData.append('password', data.password)
      formData.append('password_confirmation', data.password_confirmation)
    }
    formData.append('_method', 'PUT') // Trik untuk form

    return apiClient.post(`/officers/${id}`, formData)
  },
  deleteOfficer(id) {
    return apiClient.delete(`/officers/${id}`)
  },
  getVerificationHistory(page = 1, startDate = '', endDate = '') {
    return apiClient.get(`/verifications?page=${page}&start_date=${startDate}&end_date=${endDate}`)
  },
  getVerificationHistoryForExport(startDate = '', endDate = '') {
    return apiClient.get(`/verifications/export?start_date=${startDate}&end_date=${endDate}`)
  },
  getDashboardStats() {
    return apiClient.get('/dashboard-stats')
  },
  getProfile() {
    return apiClient.get('/profile')
  },
  updateProfile(data) {
    return apiClient.put('/profile', data)
  },
  updatePassword(data) {
    return apiClient.put('/profile/password', data)
  },
  getAdmins(page = 1) {
    return apiClient.get(`/admins?page=${page}`)
  },
  createAdmin(data) {
    return apiClient.post('/admins', data)
  },
  updateAdmin(id, data) {
    // Sama seperti petugas, kita gunakan trik _method PUT
    const formData = new FormData()
    formData.append('name', data.name)
    formData.append('email', data.email)
    if (data.password) {
      formData.append('password', data.password)
      formData.append('password_confirmation', data.password_confirmation)
    }
    formData.append('_method', 'PUT')

    return apiClient.post(`/admins/${id}`, formData)
  },
  deleteAdmin(id) {
    return apiClient.delete(`/admins/${id}`)
  },
}
