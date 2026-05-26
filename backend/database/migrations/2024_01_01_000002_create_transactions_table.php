<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transactions', function (Blueprint $row) {
            $row->id();
            $row->foreignId('wallet_id')->constrained()->onDelete('cascade');
            $row->decimal('amount', 20, 8);
            $row->string('type'); // credit, debit
            $row->string('category'); // deposit, withdrawal, conversion, transfer
            $row->string('reference')->unique();
            $row->string('status')->default('completed'); // pending, completed, failed
            $row->string('description')->nullable();
            $row->json('metadata')->nullable();
            $row->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
