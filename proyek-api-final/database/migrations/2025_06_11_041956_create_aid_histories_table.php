<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('aid_histories', function (Blueprint $table) {
            $table->id();
            $table->foreignId('recipient_id')->constrained('recipients')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->enum('status', ['diberikan', 'ditolak']);
            $table->text('remarks')->nullable();
            $table->timestamp('verified_at');
        });
    }
    public function down(): void {
        Schema::dropIfExists('aid_histories');
    }
};