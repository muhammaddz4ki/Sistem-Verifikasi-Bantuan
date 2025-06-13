<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router'

const router = useRouter()

function logout() {
  localStorage.removeItem('authToken')
  localStorage.removeItem('user')
  router.push({ name: 'login' })
}
</script>

<template>
  <div class="dashboard-layout">
    <!-- Mobile Sidebar Toggle -->
    <button class="mobile-menu-button" @click="isMobileMenuOpen = !isMobileMenuOpen">
      <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path
          stroke-linecap="round"
          stroke-linejoin="round"
          stroke-width="2"
          d="M4 6h16M4 12h16M4 18h16"
        />
      </svg>
    </button>

    <aside class="sidebar" :class="{ 'mobile-open': isMobileMenuOpen }">
      <div class="sidebar-header">
        <div class="logo">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M12.516 2.17a.75.75 0 00-1.032 0 11.209 11.209 0 01-7.877 3.08.75.75 0 00-.722.515A12.74 12.74 0 002.25 9.75c0 5.942 4.064 10.933 9.563 12.348a.749.749 0 00.374 0c5.499-1.415 9.563-6.406 9.563-12.348 0-1.39-.223-2.73-.635-3.985a.75.75 0 00-.722-.516l-.143.001c-2.996 0-5.717-1.17-7.734-3.08zm3.094 8.016a.75.75 0 10-1.22-.872l-3.236 4.53L9.53 12.22a.75.75 0 00-1.06 1.06l2.25 2.25a.75.75 0 001.14-.094l3.75-5.25z"
              clip-rule="evenodd"
            />
          </svg>
          <h3>Admin Portal</h3>
        </div>
      </div>

      <nav class="sidebar-nav">
        <RouterLink to="/dashboard" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              d="M11.47 3.84a.75.75 0 011.06 0l8.69 8.69a.75.75 0 101.06-1.06l-8.689-8.69a2.25 2.25 0 00-3.182 0l-8.69 8.69a.75.75 0 001.061 1.06l8.69-8.69z"
            />
            <path
              d="M12 5.432l8.159 8.159c.03.03.06.058.091.086v6.198c0 1.035-.84 1.875-1.875 1.875H15a.75.75 0 01-.75-.75v-4.5a.75.75 0 00-.75-.75h-3a.75.75 0 00-.75.75V21a.75.75 0 01-.75.75H5.625a1.875 1.875 0 01-1.875-1.875v-6.198a2.29 2.29 0 00.091-.086L12 5.43z"
            />
          </svg>
          <span>Dashboard</span>
        </RouterLink>

        <RouterLink to="/dashboard/penerima" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              d="M4.5 6.375a4.125 4.125 0 118.25 0 4.125 4.125 0 01-8.25 0zM14.25 8.625a3.375 3.375 0 116.75 0 3.375 3.375 0 01-6.75 0zM1.5 19.125a7.125 7.125 0 0114.25 0v.003l-.001.119a.75.75 0 01-.363.63 13.067 13.067 0 01-6.761 1.873c-2.472 0-4.786-.684-6.76-1.873a.75.75 0 01-.364-.63l-.001-.122zM17.25 19.128l-.001.144a2.25 2.25 0 01-.233.96 10.088 10.088 0 005.06-1.01.75.75 0 00.42-.643 4.875 4.875 0 00-6.957-4.611 8.586 8.586 0 011.71 5.157v.003z"
            />
          </svg>
          <span>Data Penerima</span>
        </RouterLink>

        <RouterLink to="/dashboard/petugas" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M8.25 6.75a3.75 3.75 0 117.5 0 3.75 3.75 0 01-7.5 0zM15.75 9.75a3 3 0 116 0 3 3 0 01-6 0zM2.25 9.75a3 3 0 116 0 3 3 0 01-6 0zM6.31 15.117A6.745 6.745 0 0112 12a6.745 6.745 0 016.709 7.498.75.75 0 01-.372.568A12.696 12.696 0 0112 21.75c-2.305 0-4.47-.612-6.337-1.684a.75.75 0 01-.372-.568 6.787 6.787 0 011.019-4.38z"
              clip-rule="evenodd"
            />
            <path
              d="M5.082 14.254a8.287 8.287 0 00-1.308 5.135 9.687 9.687 0 01-1.764-.44l-.115-.04a.563.563 0 01-.373-.487l-.01-.121a3.75 3.75 0 013.57-4.047zM20.226 19.389a8.287 8.287 0 00-1.308-5.135 3.75 3.75 0 013.57 4.047l-.01.121a.563.563 0 01-.373.486l-.115.04c-.567.2-1.156.349-1.764.441z"
            />
          </svg>
          <span>Data Petugas</span>
        </RouterLink>

        <RouterLink to="/dashboard/admins" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M15.75 1.5a6.75 6.75 0 00-6.651 7.906c.067.39-.032.717-.221.906l-6.5 6.499a3 3 0 00-.878 2.121v2.818c0 .414.336.75.75.75H6a.75.75 0 00.75-.75v-1.5h1.5A.75.75 0 009 19.5V18h1.5a.75.75 0 00.53-.22l2.658-2.658c.19-.189.517-.288.906-.22A6.75 6.75 0 1015.75 1.5zm0 3a.75.75 0 000 1.5A2.25 2.25 0 0118 8.25a.75.75 0 001.5 0 3.75 3.75 0 00-3.75-3.75z"
              clip-rule="evenodd"
            />
          </svg>
          <span>Manajemen Admin</span>
        </RouterLink>

        <RouterLink to="/dashboard/laporan" class="nav-item">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M3 2.25a.75.75 0 01.75.75v.54l1.838-.46a9.75 9.75 0 016.725.738l.108.054a8.25 8.25 0 005.58.652l3.109-.732a.75.75 0 01.917.81 47.784 47.784 0 00.005 10.337.75.75 0 01-.574.812l-3.114.733a9.75 9.75 0 01-6.594-.77l-.108-.054a8.25 8.25 0 00-5.69-.625l-2.202.55V21a.75.75 0 01-1.5 0V3A.75.75 0 013 2.25z"
              clip-rule="evenodd"
            />
          </svg>
          <span>Laporan</span>
        </RouterLink>
      </nav>

      <div class="sidebar-footer">
        <RouterLink to="/dashboard/profil" class="profile-link">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M7.5 6a4.5 4.5 0 119 0 4.5 4.5 0 01-9 0zM3.751 20.105a8.25 8.25 0 0116.498 0 .75.75 0 01-.437.695A18.683 18.683 0 0112 22.5c-2.786 0-5.433-.608-7.812-1.7a.75.75 0 01-.437-.695z"
              clip-rule="evenodd"
            />
          </svg>
          <span>Profil Saya</span>
        </RouterLink>

        <button @click="logout" class="logout-button">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M7.5 3.75A1.5 1.5 0 006 5.25v13.5a1.5 1.5 0 001.5 1.5h6a1.5 1.5 0 001.5-1.5V15a.75.75 0 011.5 0v3.75a3 3 0 01-3 3h-6a3 3 0 01-3-3V5.25a3 3 0 013-3h6a3 3 0 013 3V9A.75.75 0 0115 9V5.25a1.5 1.5 0 00-1.5-1.5h-6zm5.03 4.72a.75.75 0 010 1.06l-1.72 1.72h10.94a.75.75 0 010 1.5H10.81l1.72 1.72a.75.75 0 11-1.06 1.06l-3-3a.75.75 0 010-1.06l3-3a.75.75 0 011.06 0z"
              clip-rule="evenodd"
            />
          </svg>
          <span>Logout</span>
        </button>
      </div>
    </aside>

    <main class="main-content">
      <RouterView />
    </main>

    <ToastNotification />
  </div>
</template>

<style scoped>
.dashboard-layout {
  display: flex;
  min-height: 100vh;
  background-color: #f8fafc;
  position: relative;
}

/* Mobile Menu Button */
.mobile-menu-button {
  display: none;
  position: fixed;
  top: 1rem;
  left: 1rem;
  z-index: 100;
  background: #4f46e5;
  color: white;
  border: none;
  border-radius: 0.375rem;
  padding: 0.5rem;
  cursor: pointer;
}

.mobile-menu-button svg {
  width: 1.5rem;
  height: 1.5rem;
}

/* Sidebar Styles */
.sidebar {
  width: 280px;
  background: linear-gradient(180deg, #1e293b 0%, #0f172a 100%);
  color: white;
  display: flex;
  flex-direction: column;
  transition: transform 0.3s ease;
  z-index: 50;
  box-shadow: 4px 0 10px rgba(0, 0, 0, 0.1);
}

.sidebar-header {
  padding: 1.5rem;
  border-bottom: 1px solid #334155;
}

.logo {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.logo svg {
  width: 2rem;
  height: 2rem;
  color: #818cf8;
}

.logo h3 {
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0;
}

.sidebar-nav {
  flex-grow: 1;
  padding: 1rem 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.nav-item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.5rem;
  color: #e2e8f0;
  text-decoration: none;
  font-size: 0.9375rem;
  font-weight: 500;
  transition: all 0.2s ease;
  margin: 0 0.5rem;
  border-radius: 0.375rem;
}

.nav-item svg {
  width: 1.25rem;
  height: 1.25rem;
  color: #94a3b8;
}

.nav-item:hover {
  background-color: #334155;
  color: white;
}

.nav-item:hover svg {
  color: #818cf8;
}

.nav-item.router-link-exact-active {
  background-color: #4f46e5;
  color: white;
}

.nav-item.router-link-exact-active svg {
  color: white;
}

.sidebar-footer {
  padding: 1rem;
  border-top: 1px solid #334155;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.profile-link {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1rem;
  background-color: #334155;
  color: #e2e8f0;
  text-decoration: none;
  border-radius: 0.375rem;
  font-size: 0.9375rem;
  font-weight: 500;
  transition: all 0.2s ease;
}

.profile-link svg {
  width: 1.25rem;
  height: 1.25rem;
}

.profile-link:hover {
  background-color: #4f46e5;
  color: white;
}

.profile-link.router-link-exact-active {
  background-color: #4f46e5;
  color: white;
}

.logout-button {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  width: 100%;
  padding: 0.75rem 1rem;
  background-color: #dc2626;
  color: white;
  border: none;
  border-radius: 0.375rem;
  font-size: 0.9375rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.logout-button svg {
  width: 1.25rem;
  height: 1.25rem;
}

.logout-button:hover {
  background-color: #b91c1c;
}

.main-content {
  flex-grow: 1;
  padding: 2rem;
  background-color: #f8fafc;
  overflow-y: auto;
  min-height: 100vh;
}

/* Responsive Styles */
@media (max-width: 1024px) {
  .sidebar {
    position: fixed;
    height: 100vh;
    transform: translateX(-100%);
  }

  .sidebar.mobile-open {
    transform: translateX(0);
  }

  .mobile-menu-button {
    display: block;
  }

  .main-content {
    margin-left: 0;
    width: 100%;
  }
}

@media (min-width: 1025px) {
  .sidebar {
    position: sticky;
    top: 0;
    height: 100vh;
  }
}
</style>
