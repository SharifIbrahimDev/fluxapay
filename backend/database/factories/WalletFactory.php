<?php

namespace Database\Factories;

use App\Models\Wallet;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class WalletFactory extends Factory
{
    protected $model = Wallet::class;

    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'currency' => $this->faker->randomElement(['NGN', 'USD', 'USDT']),
            'balance' => $this->faker->randomFloat(8, 0, 1000000),
            'status' => 'active',
        ];
    }
}
