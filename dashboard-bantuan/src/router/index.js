// FILE: src/router/index.js

import { createRouter, createWebHistory } from 'vue-router'
// Import view yang sudah ada
import LoginView from '../views/LoginView.vue'
import DashboardLayout from '../layouts/DashboardLayout.vue'
import DashboardView from '../views/DashboardView.vue'
import RecipientsView from '../views/RecipientsView.vue'
import RecipientFormView from '../views/RecipientForm.vue'
import RecipientEditView from '../views/RecipientEditView.vue'
import OfficersView from '../views/OfficersView.vue'
import OfficerCreateView from '../views/OfficerCreateView.vue'
import OfficerEditView from '../views/OfficerEditView.vue'
import ReportView from '../views/ReportView.vue'
import ProfileView from '../views/ProfileView.vue'
import AdminsView from '../views/AdminsView.vue'
import AdminCreateView from '../views/AdminCreateView.vue'
import AdminEditView from '../views/AdminEditView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'login',
      component: LoginView,
    },
    {
      path: '/dashboard',
      component: DashboardLayout,
      meta: { requiresAuth: true },
      children: [
        { path: '', name: 'dashboard', component: DashboardView },
        { path: 'penerima', name: 'recipients', component: RecipientsView },
        { path: 'penerima/tambah', name: 'recipient-add', component: RecipientFormView },

        // --- RUTE BARU DITAMBAHKAN DI SINI ---
        {
          path: 'penerima/edit/:id', // :id adalah parameter dinamis
          name: 'recipient-edit',
          component: RecipientEditView,
          props: true, // Mengirim :id dari URL sebagai 'props' ke komponen
        },

        {
          path: 'petugas',
          name: 'officers',
          component: OfficersView,
        },
        {
          path: 'petugas/tambah',
          name: 'officer-add',
          component: OfficerCreateView,
        },
        {
          path: 'petugas/edit/:id',
          name: 'officer-edit',
          component: OfficerEditView,
          props: true,
        },
        {
          path: 'laporan',
          name: 'reports',
          component: ReportView,
        },
        {
          path: 'profil',
          name: 'profile',
          component: ProfileView,
        },
        {
          path: 'admins',
          name: 'admins',
          component: AdminsView,
        },
        {
          path: 'admins/tambah',
          name: 'admin-add',
          component: AdminCreateView,
        },
        {
          path: 'admins/edit/:id',
          name: 'admin-edit',
          component: AdminEditView,
          props: true,
        },
      ],
    },
  ],
})

// Menggunakan beforeEach Anda
router.beforeEach((to, from, next) => {
  const isAuthenticated = !!localStorage.getItem('authToken')
  if (to.meta.requiresAuth && !isAuthenticated) {
    next({ name: 'login' })
  } else if (to.name === 'login' && isAuthenticated) {
    next({ name: 'dashboard' })
  } else {
    next()
  }
})

export default router
