<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('exchange_rates', function (Blueprint $row) {
            $row->id();
            $row->string('from_currency', 10);
            $row->string('to_currency', 10);
            $row->decimal('rate', 20, 8);
            $row->decimal('fee_percentage', 5, 2)->default(0);
            $row->timestamps();

            $row->unique(['from_currency', 'to_currency']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('exchange_rates');
    }
};
