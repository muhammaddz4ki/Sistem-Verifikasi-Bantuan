<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AidHistory;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\Verification;

class VerificationController extends Controller
{


 public function index(Request $request)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $query = AidHistory::with(['user', 'recipient']);

        // --- PENAMBAHAN LOGIKA FILTER TANGGAL ---
        if ($request->filled('start_date')) {
            $query->whereDate('verified_at', '>=', $request->start_date);
        }
        if ($request->filled('end_date')) {
            $query->whereDate('verified_at', '<=', $request->end_date);
        }
        // -----------------------------------------

        $history = $query->latest('verified_at')->paginate(15);

        return response()->json(['status' => 'success', 'data' => $history]);
    }
public function store(Request $request)

    {
        $user = $request->user();

        // Pastikan hanya admin atau petugas yang bisa melakukan verifikasi
        if ($user->role !== 'admin' && $user->role !== 'petugas') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }
    $validator = Validator::make($request->all(), [
        'recipient_id' => 'required|integer|exists:recipients,id',
        'status' => 'required|string|in:diberikan,ditolak', // Hanya boleh diisi 'diberikan' atau 'ditolak'
        'remarks' => 'nullable|string|max:255', // Alasan, boleh kosong
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 422);
    }

    // 2. Cek duplikat verifikasi (logika ini tetap sama)
    $existingVerification = AidHistory::where('recipient_id', $request->recipient_id)->first();
    if ($existingVerification) {
        return response()->json([
            'status' => 'error',
            'message' => 'Penerima ini sudah pernah diverifikasi sebelumnya.'
        ], 409); // 409 Conflict
    }

    // 3. Buat catatan baru dengan data dari request
    $history = AidHistory::create([
        'recipient_id' => $request->recipient_id,
        'user_id' => $request->user()->id,
        'status' => $request->status, // <-- Ambil status dari request
        'remarks' => $request->remarks, // <-- Ambil alasan dari request
        'verified_at' => now(),
    ]);

    // 4. Beri respons sukses
    return response()->json([
        'status' => 'success',
        'message' => 'Verifikasi berhasil disimpan.',
        'data' => $history
    ], 201);
}

    /**
     * Mengambil riwayat verifikasi untuk user yang sedang login.
     */
    public function history(Request $request)
    {
        // Ambil data dari tabel aid_histories...
        $histories = AidHistory::with('recipient:id,name,nik') // ... beserta data nama & nik dari tabel recipients
            ->where('user_id', $request->user()->id) // ... hanya untuk petugas yang sedang login
            ->latest('verified_at') // ... diurutkan dari yang paling baru
            ->paginate(20); // ... dibatasi 20 data per halaman

        return response()->json([
            'status' => 'success',
            'data' => $histories
        ]);
    }

    public function export(Request $request)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $query = AidHistory::with(['user', 'recipient']);

        // --- PENAMBAHAN LOGIKA FILTER TANGGAL ---
        if ($request->filled('start_date')) {
            $query->whereDate('verified_at', '>=', $request->start_date);
        }
        if ($request->filled('end_date')) {
            $query->whereDate('verified_at', '<=', $request->end_date);
        }
        // -----------------------------------------

        $history = $query->latest('verified_at')->get();

        return response()->json(['status' => 'success', 'data' => $history]);
    }
}
