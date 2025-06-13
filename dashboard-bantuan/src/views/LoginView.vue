<script setup>
import { ref } from 'vue'
import api from '../services/api.js'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const errorMessage = ref('')
const isLoading = ref(false)

const router = useRouter()

async function handleLogin() {
  isLoading.value = true
  errorMessage.value = ''

  try {
    const response = await api.login({
      email: email.value,
      password: password.value,
    })
    const user = response.data.user

    console.log('Login Berhasil:', response.data)

    localStorage.setItem('authToken', response.data.access_token)
    localStorage.setItem('user', JSON.stringify(user))

    router.push('/dashboard')
  } catch (error) {
    console.error('Login Gagal:', error.response)
    if (error.response && error.response.data) {
      errorMessage.value = error.response.data.message || 'Terjadi kesalahan.'
    } else {
      errorMessage.value = 'Tidak dapat terhubung ke server.'
    }
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-header">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="currentColor"
          class="login-icon"
        >
          <path
            fill-rule="evenodd"
            d="M12 1.5a5.25 5.25 0 00-5.25 5.25v3a3 3 0 00-3 3v6.75a3 3 0 003 3h10.5a3 3 0 003-3v-6.75a3 3 0 00-3-3v-3c0-2.9-2.35-5.25-5.25-5.25zm3.75 8.25v-3a3.75 3.75 0 10-7.5 0v3h7.5z"
            clip-rule="evenodd"
          />
        </svg>
        <h1>Admin Portal</h1>
        <p>Please sign in to continue</p>
      </div>

      <form @submit.prevent="handleLogin">
        <div v-if="errorMessage" class="error-message">
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
            <path
              fill-rule="evenodd"
              d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-8-5a.75.75 0 01.75.75v4.5a.75.75 0 01-1.5 0v-4.5A.75.75 0 0110 5zm0 10a1 1 0 100-2 1 1 0 000 2z"
              clip-rule="evenodd"
            />
          </svg>
          {{ errorMessage }}
        </div>

        <div class="input-group">
          <input type="email" id="email" v-model="email" required placeholder=" " />
          <label for="email">Email</label>
          <div class="input-border"></div>
        </div>

        <div class="input-group">
          <input type="password" id="password" v-model="password" required placeholder=" " />
          <label for="password">Password</label>
          <div class="input-border"></div>
        </div>

        <button type="submit" :disabled="isLoading">
          <span v-if="!isLoading">Sign In</span>
          <div v-else class="spinner"></div>
        </button>
      </form>

      <div class="login-footer">
        <a href="#" class="forgot-password">Forgot password?</a>
      </div>
    </div>

    <div class="login-background">
      <div class="shape shape-1"></div>
      <div class="shape shape-2"></div>
    </div>
  </div>
</template>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f8fafc;
  position: relative;
  overflow: hidden;
  font-family:
    'Inter',
    -apple-system,
    BlinkMacSystemFont,
    sans-serif;
}

.login-box {
  padding: 2.5rem;
  background-color: white;
  border-radius: 1rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
  width: 100%;
  max-width: 420px;
  z-index: 10;
  position: relative;
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.login-icon {
  width: 3rem;
  height: 3rem;
  margin: 0 auto 1rem;
  color: #4f46e5;
}

.login-header h1 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #1e293b;
  margin-bottom: 0.5rem;
}

.login-header p {
  color: #64748b;
  font-size: 0.875rem;
}

.error-message {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: white;
  background-color: #ef4444;
  padding: 0.75rem 1rem;
  border-radius: 0.5rem;
  margin-bottom: 1.5rem;
  font-size: 0.875rem;
}

.error-message svg {
  width: 1rem;
  height: 1rem;
  flex-shrink: 0;
}

.input-group {
  position: relative;
  margin-bottom: 1.5rem;
}

.input-group label {
  position: absolute;
  top: 0.75rem;
  left: 1rem;
  color: #94a3b8;
  font-size: 0.875rem;
  pointer-events: none;
  transition: all 0.2s ease;
  transform-origin: left center;
}

.input-group input {
  width: 100%;
  padding: 0.75rem 1rem;
  border: 1px solid #e2e8f0;
  border-radius: 0.5rem;
  background-color: #f8fafc;
  font-size: 0.875rem;
  transition: all 0.2s ease;
}

.input-group input:focus {
  outline: none;
  border-color: #c7d2fe;
  background-color: white;
  box-shadow: 0 0 0 3px rgba(199, 210, 254, 0.5);
}

.input-group input:focus + label,
.input-group input:not(:placeholder-shown) + label {
  transform: translateY(-1.25rem) scale(0.85);
  color: #4f46e5;
}

.input-border {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background-color: #4f46e5;
  transition: width 0.3s ease;
}

.input-group input:focus ~ .input-border {
  width: 100%;
}

button {
  width: 100%;
  padding: 0.875rem;
  border: none;
  border-radius: 0.5rem;
  background-color: #4f46e5;
  color: white;
  font-size: 0.875rem;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s ease;
  margin-top: 0.5rem;
  display: flex;
  justify-content: center;
  align-items: center;
  height: 2.75rem;
}

button:hover {
  background-color: #4338ca;
}

button:disabled {
  background-color: #cbd5e1;
  cursor: not-allowed;
}

.spinner {
  width: 1.25rem;
  height: 1.25rem;
  border: 2px solid rgba(255, 255, 255, 0.3);
  border-radius: 50%;
  border-top-color: white;
  animation: spin 1s ease-in-out infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.login-footer {
  margin-top: 1.5rem;
  text-align: center;
}

.forgot-password {
  color: #64748b;
  font-size: 0.875rem;
  text-decoration: none;
  transition: color 0.2s ease;
}

.forgot-password:hover {
  color: #4f46e5;
}

.login-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
}

.shape {
  position: absolute;
  border-radius: 50%;
  background: linear-gradient(135deg, #6366f1, #a5b4fc);
  opacity: 0.1;
}

.shape-1 {
  width: 300px;
  height: 300px;
  top: -100px;
  left: -100px;
}

.shape-2 {
  width: 200px;
  height: 200px;
  bottom: -50px;
  right: -50px;
}

@media (max-width: 480px) {
  .login-box {
    padding: 1.5rem;
    margin: 0 1rem;
  }
}
</style>
