<?php

namespace Database\Factories;

use App\Models\Transaction;
use App\Models\Wallet;
use Illuminate\Database\Eloquent\Factories\Factory;

class TransactionFactory extends Factory
{
    protected $model = Transaction::class;

    public function definition(): array
    {
        return [
            'wallet_id' => Wallet::factory(),
            'amount' => $this->faker->randomFloat(8, 10, 1000),
            'type' => $this->faker->randomElement(['credit', 'debit']),
            'category' => $this->faker->randomElement(['deposit', 'withdrawal', 'conversion']),
            'reference' => strtoupper($this->faker->unique()->bothify('TX-####-????')),
            'status' => 'completed',
            'description' => $this->faker->sentence(),
            'metadata' => null,
        ];
    }
}
