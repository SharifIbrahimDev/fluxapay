<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('admin_users', function (Blueprint $row) {
            $row->id();
            $row->string('name');
            $row->string('email')->unique();
            $row->string('password');
            $row->string('role')->default('admin');
            $row->rememberToken();
            $row->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('admin_users');
    }
};
