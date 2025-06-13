<?php
// FILE: app/Http/Controllers/Api/OfficerController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User; // Kita akan menggunakan model User
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class OfficerController extends Controller
{
    /**
     * Menampilkan daftar semua petugas.
     */
    public function index(Request $request)
    {
        // Hanya admin yang bisa melihat daftar petugas
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Ambil semua user dengan role 'petugas'
        $officers = User::where('role', 'petugas')->latest()->paginate(10);

        return response()->json(['status' => 'success', 'data' => $officers]);
    }

    /**
     * Menyimpan data petugas baru.
     */
    public function store(Request $request)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed', // 'confirmed' akan mencocokkan dengan 'password_confirmation'
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'petugas', // Otomatis set role sebagai 'petugas'
        ]);

        return response()->json(['status' => 'success', 'message' => 'Petugas berhasil ditambahkan.', 'data' => $user], 201);
    }

    /**
     * Menampilkan satu data petugas spesifik.
     */
    public function show(Request $request, User $officer)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Pastikan user yang diminta adalah seorang petugas
        if ($officer->role !== 'petugas') {
            return response()->json(['message' => 'Data tidak ditemukan.'], 404);
        }

        return response()->json(['status' => 'success', 'data' => $officer]);
    }

    /**
     * Memperbarui data petugas.
     */
    public function update(Request $request, User $officer)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($officer->id)],
            'password' => 'nullable|string|min:8|confirmed', // Password opsional saat update
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        // Update data utama
        $officer->name = $request->name;
        $officer->email = $request->email;

        // Jika ada password baru yang dikirim, update passwordnya
        if ($request->filled('password')) {
            $officer->password = Hash::make($request->password);
        }

        $officer->save();

        return response()->json(['status' => 'success', 'message' => 'Data petugas berhasil diperbarui.', 'data' => $officer]);
    }

    /**
     * Menghapus data petugas.
     */
    public function destroy(Request $request, User $officer)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Jangan hapus diri sendiri
        if ($request->user()->id === $officer->id) {
            return response()->json(['message' => 'Anda tidak bisa menghapus akun Anda sendiri.'], 403);
        }

        $officer->delete();

        return response()->json(['status' => 'success', 'message' => 'Data petugas berhasil dihapus.']);
    }
}
