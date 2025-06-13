<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Recipient;

class RecipientVerificationController extends Controller
{
    public function showByNik(Request $request, $nik)
    {
        $user = $request->user();

        // Pastikan hanya admin atau petugas yang bisa mengakses
        if (!$user || !in_array($user->role, ['admin', 'petugas'])) {
            return response()->json([
                'status' => 'error',
                'message' => 'Anda tidak memiliki hak akses.'
            ], 403);
        }

        // Cari data berdasarkan qr_code_identifier (bisa berupa NIK)
        $recipient = Recipient::where('qr_code_identifier', $nik)->first();

        if (!$recipient) {
            return response()->json([
                'status' => 'error',
                'message' => 'Data penerima dengan NIK/QR Code tersebut tidak ditemukan.'
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $recipient
        ], 200);
    }
}
