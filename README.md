# Sistem Verifikasi Bantuan

Repositori ini berisi proyek sistem informasi **verifikasi penerima bantuan pangan** berbasis web dan mobile yang terdiri dari 3 bagian utama:

## 🧩 Struktur Folder

Project Verifikasi Bantuan/
├── proyek-api-final ← Backend Laravel 12 (REST API)
├── aplikasi_bantuan ← Aplikasi Flutter untuk petugas
└── dashboard-bantuan ← Dashboard Admin berbasis Vue.js (Vite)

## 📱 Aplikasi Mobile (Flutter)
Aplikasi untuk **petugas verifikasi** di lapangan dengan fitur:
- Login petugas
- Pindai QR atau input NIK penerima bantuan
- Verifikasi penerima secara real-time
- Menyimpan dan menampilkan riwayat verifikasi

## 🖥️ Dashboard Admin (Vue + Vite)
Antarmuka web untuk **admin pusat**:
- Login admin
- Kelola data admin & petugas
- Upload data penerima bantuan secara massal
- Statistik penerima dan verifikasi
- CRUD pengguna dan penerima bantuan

## 🔧 Backend API (Laravel 12)
API server sebagai pusat data dan komunikasi:
- Autentikasi Laravel Sanctum
- Endpoint RESTful: login, verifikasi NIK, histori
- Struktur database tersedia: `db_verifikasi_bantuan.sql`
- Role-based access untuk admin dan petugas

## ⚙️ Cara Menjalankan Proyek

### 1. Backend Laravel
cd proyek-api-final
cp .env.example .env
composer install
php artisan key:generate
php artisan migrate --seed
php artisan serve


**2. Frontend Dashboard (Vue + Vite)**
bash
Copy
Edit
cd dashboard-bantuan
npm install
npm run dev

**3. Aplikasi Mobile (Flutter)**
bash
Copy
Edit
cd aplikasi_bantuan
flutter pub get
flutter run


**🧪 Database**
File: db_verifikasi_bantuan.sql

Import ke MySQL via phpMyAdmin atau CLI

Sesuaikan konfigurasi .env di Laravel


**🔐 Role & Akses**
Role	Akses
Admin	Kelola petugas, laporan verifikasi, data penerima
Petugas	Verifikasi penerima, input NIK, simpan riwayat

**📊 Statistik & Laporan**
Grafik verifikasi per hari/minggu/bulan
Jumlah penerima valid/tidak valid
Riwayat verifikasi per petugas

**📃 Lisensi**
Dikembangkan oleh Muhammad Dzaki.
Bebas digunakan untuk pembelajaran atau pengembangan lebih lanjut.

**📬 Kontak**
GitHub: muhammaddz4ki
WhatsApp: 0852-6961-7993
