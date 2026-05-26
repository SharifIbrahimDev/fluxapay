<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('account_number', 10)->nullable()->after('email');
        });

        // Backfill existing users
        $users = DB::table('users')->whereNull('account_number')->get();
        foreach ($users as $user) {
            $accountNumber = $this->generateUniqueAccountNumber();
            DB::table('users')->where('id', $user->id)->update(['account_number' => $accountNumber]);
        }

        // Make it unique and required after backfill
        Schema::table('users', function (Blueprint $table) {
            $table->string('account_number', 10)->nullable(false)->unique()->change();
        });
    }

    private function generateUniqueAccountNumber()
    {
        do {
            $number = '20' . str_pad(mt_rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        } while (DB::table('users')->where('account_number', $number)->exists());
        
        return $number;
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('account_number');
        });
    }
};
