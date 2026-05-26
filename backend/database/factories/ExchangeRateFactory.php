<?php

namespace Database\Factories;

use App\Models\ExchangeRate;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExchangeRateFactory extends Factory
{
    protected $model = ExchangeRate::class;

    public function definition(): array
    {
        return [
            'from_currency' => 'NGN',
            'to_currency' => 'USD',
            'rate' => 0.000625,
            'fee_percentage' => 1.5,
        ];
    }
}
