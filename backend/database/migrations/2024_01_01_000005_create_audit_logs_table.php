<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('audit_logs', function (Blueprint $row) {
            $row->id();
            $row->foreignId('user_id')->nullable()->constrained()->onDelete('set null');
            $row->string('action');
            $row->json('context')->nullable();
            $row->string('ip_address')->nullable();
            $row->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('audit_logs');
    }
};
