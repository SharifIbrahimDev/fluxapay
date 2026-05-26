<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\AdminUser;
use App\Models\ExchangeRate;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Admin user
        AdminUser::updateOrCreate(
            ['email' => 'admin@fluxapay.com'],
            [
                'name' => 'FluxaPay Admin',
                'password' => Hash::make('password'),
                'role' => 'super_admin',
            ]
        );

        // Exchange rates
        $rates = [
            ['from' => 'NGN', 'to' => 'USD', 'rate' => 0.00062, 'fee' => 1.5],
            ['from' => 'USD', 'to' => 'NGN', 'rate' => 1600, 'fee' => 1.0],
            ['from' => 'NGN', 'to' => 'USDT', 'rate' => 0.00061, 'fee' => 2.0],
            ['from' => 'USDT', 'to' => 'NGN', 'rate' => 1630, 'fee' => 1.0],
            ['from' => 'USD', 'to' => 'USDT', 'rate' => 0.99, 'fee' => 0.5],
            ['from' => 'USDT', 'to' => 'USD', 'rate' => 1.01, 'fee' => 0.5],
        ];

        foreach ($rates as $r) {
            ExchangeRate::updateOrCreate(
                ['from_currency' => $r['from'], 'to_currency' => $r['to']],
                ['rate' => $r['rate'], 'fee_percentage' => $r['fee']]
            );
        }

        // Dummy user
        $user = User::updateOrCreate(
            ['email' => 'user@example.com'],
            [
                'name' => 'John Doe',
                'phone' => '08012345678',
                'password' => Hash::make('password'),
                'transaction_pin' => Hash::make('1234'),
                'account_number' => '2000000001',
                'status' => 'active',
            ]
        );

        // Initialize wallets for dummy user (only if they don't exist)
        if ($user->wallets()->count() === 0) {
            $user->wallets()->create(['currency' => 'NGN', 'balance' => 50000]);
            $user->wallets()->create(['currency' => 'USD', 'balance' => 100]);
            $user->wallets()->create(['currency' => 'USDT', 'balance' => 50]);
        }
    }
}
