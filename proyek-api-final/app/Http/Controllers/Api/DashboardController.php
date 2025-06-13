<?php
// FILE: app/Http/Controllers/Api/DashboardController.php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\AidHistory;
use App\Models\Recipient;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Menyediakan semua data statistik untuk halaman dashboard.
     */
    public function getStats(Request $request)
    {
        // Hanya admin yang bisa melihat statistik
        if (!$request->user() || $request->user()->role !== 'admin') {
            return response()->json(['message' => 'Anda tidak memiliki hak akses.'], 403);
        }

        // 1. Statistik Kartu Ringkasan
        $totalRecipients = Recipient::count();
        $totalOfficers = User::where('role', 'petugas')->count();
        $totalVerified = AidHistory::where('status', 'diberikan')->count();
        $todayVerified = AidHistory::where('status', 'diberikan')->whereDate('verified_at', Carbon::today())->count();

        // 2. Statistik untuk Grafik Pie (Telah & Belum Diverifikasi)
        $verifiedRecipientIds = AidHistory::where('status', 'diberikan')->distinct()->pluck('recipient_id');
        $countVerifiedUnique = $verifiedRecipientIds->count();
        $countNotVerified = $totalRecipients - $countVerifiedUnique;

        // 3. Statistik untuk Grafik Verifikasi 7 Hari Terakhir
        $verificationLast7Days = AidHistory::select(
                DB::raw('DATE(verified_at) as date'),
                DB::raw('count(*) as count')
            )
            ->where('verified_at', '>=', Carbon::now()->subDays(7))
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->get()
            ->pluck('count', 'date');

        // 4. Statistik untuk Lokasi Distribusi (Top 5)
        $topLocations = Recipient::join('aid_histories', 'recipients.id', '=', 'aid_histories.recipient_id')
            ->select('recipients.address', DB::raw('count(*) as count'))
            ->where('aid_histories.status', 'diberikan')
            ->groupBy('recipients.address')
            ->orderBy('count', 'desc')
            ->limit(5)
            ->get();


        // Gabungkan semua data menjadi satu respons
        return response()->json([
            'status' => 'success',
            'data' => [
                'summary' => [
                    'total_recipients' => $totalRecipients,
                    'total_officers' => $totalOfficers,
                    'total_verified' => $totalVerified,
                    'today_verified' => $todayVerified,
                ],
                'verification_status' => [
                    'verified' => $countVerifiedUnique,
                    'not_verified' => $countNotVerified,
                ],
                'daily_verification_chart' => $verificationLast7Days,
                'location_distribution_chart' => $topLocations,
            ]
        ]);
    }
}
