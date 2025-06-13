<?php
// FILE: app/Http/Controllers/Api/ProfileController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;
// =======================================================
//   BARIS YANG HILANG ADA DI SINI: TAMBAHKAN INI
// =======================================================
use Illuminate\Support\Facades\Validator;

class ProfileController extends Controller
{
    /**
     * Mengambil data profil user yang sedang login.
     */
    public function show(Request $request)
    {
        return response()->json([
            'status' => 'success',
            'data' => $request->user()
        ]);
    }

    /**
     * Memperbarui data profil user yang sedang login.
     */
    public function update(Request $request)
    {
        $user = $request->user();

        // Sekarang Validator akan dikenali
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|max:255',
            'email' => ['required', 'string', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $user->name = $request->name;
        $user->email = $request->email;
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Profil berhasil diperbarui.',
            'data' => $user
        ]);
    }

    /**
     * Memperbarui password user yang sedang login.
     */
    public function updatePassword(Request $request)
    {
        $user = $request->user();

        // Dan di sini juga akan dikenali
        $validator = Validator::make($request->all(), [
            'current_password' => ['required', 'current_password'],
            'password' => ['required', 'min:8', 'confirmed', Password::defaults()],
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'errors' => $validator->errors()], 422);
        }

        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json([
            'status' => 'success',
            'message' => 'Password berhasil diperbarui.'
        ]);
    }
}
