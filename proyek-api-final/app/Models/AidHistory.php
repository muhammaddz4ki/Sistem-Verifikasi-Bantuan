<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo; // <-- Jangan lupa tambahkan ini

class AidHistory extends Model
{
    use HasFactory;
    public $timestamps = false;
    protected $fillable = ['recipient_id', 'user_id', 'status', 'verified_at'];

    /**
     * Mendefinisikan relasi ke model Recipient.
     * Setiap catatan riwayat dimiliki oleh satu penerima.
     */
    public function recipient(): BelongsTo
    {
        return $this->belongsTo(Recipient::class);
    }
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
