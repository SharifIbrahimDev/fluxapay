<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('wallets', function (Blueprint $row) {
            $row->id();
            $row->foreignId('user_id')->constrained()->onDelete('cascade');
            $row->string('currency', 10); // NGN, USD, USDT
            $row->decimal('balance', 20, 8)->default(0);
            $row->string('status')->default('active'); // active, frozen
            $row->timestamps();
            $row->softDeletes();

            $row->unique(['user_id', 'currency']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('wallets');
    }
};
