<?php
// FILE: app/Http/Controllers/Api/AdminController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;

class AdminController extends Controller
{
    /**
     * Menampilkan daftar semua admin.
     */
    public function index(Request $request)
    {
        // Hanya admin yang bisa melihat daftar admin lain
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Ambil semua user dengan role 'admin'
        $admins = User::where('role', 'admin')->latest()->paginate(10);

        return response()->json(['status' => 'success', 'data' => $admins]);
    }

    /**
     * Menyimpan data admin baru.
     */
    public function store(Request $request)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'role' => 'admin', // Otomatis set role sebagai 'admin'
        ]);

        return response()->json(['status' => 'success', 'message' => 'Admin berhasil ditambahkan.', 'data' => $user], 201);
    }

    /**
     * Memperbarui data admin.
     */
    public function update(Request $request, User $admin)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($admin->id)],
            'password' => 'nullable|string|min:8|confirmed',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $admin->name = $request->name;
        $admin->email = $request->email;

        if ($request->filled('password')) {
            $admin->password = Hash::make($request->password);
        }

        $admin->save();

        return response()->json(['status' => 'success', 'message' => 'Data admin berhasil diperbarui.', 'data' => $admin]);
    }

    /**
     * Menghapus data admin.
     */
    public function destroy(Request $request, User $admin)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Mencegah admin menghapus akunnya sendiri
        if ($request->user()->id === $admin->id) {
            return response()->json(['message' => 'Anda tidak bisa menghapus akun Anda sendiri.'], 403);
        }

        $admin->delete();

        return response()->json(['status' => 'success', 'message' => 'Data admin berhasil dihapus.']);
    }
}
