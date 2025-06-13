<?php
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
return new class extends Migration {
    public function up(): void {
        Schema::create('recipients', function (Blueprint $table) {
            $table->id();
            $table->string('nik')->unique();
            $table->string('name');
            $table->text('address');
            $table->string('qr_code_identifier')->unique()->nullable();
            $table->timestamps();
        });
    }
    public function down(): void {
        Schema::dropIfExists('recipients');
    }
};