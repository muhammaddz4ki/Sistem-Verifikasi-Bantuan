<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\RecipientController;
use App\Http\Controllers\Api\VerificationController;
use App\Http\Controllers\Api\OfficerController;
use App\Http\Controllers\Api\RecipientVerificationController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\AdminController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/logout', [AuthController::class, 'logout']);

    // Daftar semua penerima dengan fitur pencarian dan pagination
    Route::get('/recipients', [RecipientController::class, 'index']);

    // Menambah data penerima baru (hanya admin)
    Route::post('/recipients', [RecipientController::class, 'store']);

    // Mendapatkan data penerima berdasarkan ID (admin atau petugas)
    Route::get('/recipients/{id}', [RecipientController::class, 'show']);

    // Mengupdate data penerima berdasarkan ID (hanya admin)
    Route::put('/recipients/{id}', [RecipientController::class, 'update']);

    // Menghapus data penerima berdasarkan ID (hanya admin)
    Route::delete('/recipients/{recipient}', [RecipientController::class, 'destroy']);

    // Verifikasi dan Riwayat Verifikasi
    Route::apiResource('/verifications', VerificationController::class)->only(['index', 'store']);
    Route::get('/verifications/history', [VerificationController::class, 'history']);
    Route::get('/verifications/export', [VerificationController::class, 'export']);

    // Manajemen Petugas
    Route::apiResource('/officers', OfficerController::class);
    Route::get('/recipients/verify/{nik}', [RecipientVerificationController::class, 'showByNik']);

     // Manajemen dashboard admin
    Route::get('/dashboard-stats', [DashboardController::class, 'getStats']);

    // --- RUTE BARU UNTUK PROFIL ADMIN ---
    Route::get('/profile', [ProfileController::class, 'show']);
    Route::put('/profile', [ProfileController::class, 'update']);
    Route::put('/profile/password', [ProfileController::class, 'updatePassword']);

     // --- RUTE BARU UNTUK CRUD ADMIN ---
    Route::apiResource('/admins', AdminController::class)->except(['show']);
});
