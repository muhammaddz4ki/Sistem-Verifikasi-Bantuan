<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Recipient;
use Illuminate\Support\Facades\Validator;

class RecipientController extends Controller
{

    public function index(Request $request)
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // Mulai query ke model Recipient
        $query = Recipient::query();

        // Cek apakah ada parameter 'search' yang dikirim dari frontend
        if ($request->has('search')) {
            $searchTerm = $request->search;
            // Tambahkan kondisi WHERE untuk mencari di kolom 'name' ATAU 'nik'
            $query->where(function($q) use ($searchTerm) {
                $q->where('name', 'like', '%' . $searchTerm . '%')
                  ->orWhere('nik', 'like', '%' . $searchTerm . '%');
            });
        }

        // Lanjutkan dengan mengurutkan dan paginasi
        $recipients = $query->latest()->paginate(10); // Kita batasi 10 data per halaman

        return response()->json([
            'status' => 'success',
            'data' => $recipients
        ]);
    }
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

    public function store(Request $request)
{
    // 1. Otorisasi: Periksa apakah user yang login adalah admin
    if ($request->user()->role !== 'admin') {
        return response()->json([
            'status' => 'error',
            'message' => 'Anda tidak memiliki hak akses untuk melakukan aksi ini.'
        ], 403);
    }

    // 2. Validasi: Periksa data yang dikirim
    $validator = Validator::make($request->all(), [
        'nik' => 'required|string|size:16|unique:recipients,nik',
        'name' => 'required|string|max:255',
        'address' => 'required|string',
    ]);

    if ($validator->fails()) {
        return response()->json([
            'status' => 'error',
            'message' => 'Data yang diberikan tidak valid.',
            'errors' => $validator->errors()
        ], 422);
    }

    // PERUBAHAN UTAMA DI SINI
    // Siapkan data yang akan disimpan
    $dataToCreate = $request->all();
    // Atur qr_code_identifier agar nilainya sama dengan NIK
    $dataToCreate['qr_code_identifier'] = $request->nik;

    // 3. Buat Data menggunakan data yang sudah kita siapkan
    $recipient = Recipient::create($dataToCreate);

    // 4. Beri Respons Sukses
    return response()->json([
        'status' => 'success',
        'message' => 'Data penerima berhasil ditambahkan.',
        'data' => $recipient
    ], 201);
}


    public function show(Request $request, $id) // Terima $id sebagai string
    {
        if (!$request->user() || !in_array($request->user()->role, ['admin', 'petugas'])) {
    return response()->json([
        'message' => 'Akses ditolak. Hanya admin dan petugas yang diizinkan.'
    ], 403);
}


        $recipient = Recipient::find($id); // Cari manual menggunakan Model::find()

        if (!$recipient) {
            return response()->json(['status' => 'error', 'message' => 'Data tidak ditemukan.'], 404);
        }

        return response()->json(['status' => 'success', 'data' => $recipient]);
    }

    /**
     * =======================================================
     * PERUBAHAN DI SINI: Mengambil data secara manual by ID
     * =======================================================
     */
    public function update(Request $request, $id) // Terima $id sebagai string
    {
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        $recipient = Recipient::find($id); // Cari manual
        if (!$recipient) {
            return response()->json(['status' => 'error', 'message' => 'Data yang akan diupdate tidak ditemukan.'], 404);
        }

        $validator = Validator::make($request->all(), [
            'nik' => 'required|string|size:16|unique:recipients,nik,'.$recipient->id,
            'name' => 'required|string|max:255',
            'address' => 'required|string',
        ]);

        if ($validator->fails()) {
            return response()->json(['status' => 'error', 'message' => 'Validasi gagal.', 'errors' => $validator->errors()], 422);
        }

        $dataToUpdate = $request->all();
        $dataToUpdate['qr_code_identifier'] = $request->nik;
        $recipient->update($dataToUpdate);
        return response()->json(['status' => 'success', 'message' => 'Data berhasil diperbarui.', 'data' => $recipient]);
    }


    public function destroy(Request $request, Recipient $recipient)
    {
        // 1. Otorisasi: Periksa apakah user adalah admin
        if ($request->user()->role !== 'admin') {
            return response()->json(['status' => 'error', 'message' => 'Anda tidak memiliki hak akses untuk melakukan aksi ini.'], 403);
        }

        // 2. Hapus Data
        $recipient->delete();

        // 3. Beri Respons Sukses
        return response()->json([
            'status' => 'success',
            'message' => 'Data penerima berhasil dihapus.'
        ], 200); // 200 OK
    }

}
