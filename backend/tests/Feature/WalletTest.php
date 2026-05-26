<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Wallet;
use App\Models\ExchangeRate;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class WalletTest extends TestCase
{
    use RefreshDatabase;

    protected $user;

    protected function setUp(): void
    {
        parent::setUp();
        $this->user = User::factory()->create([
            'transaction_pin' => Hash::make('1234')
        ]);
        
        // Ensure wallets exist
        $this->user->wallets()->create(['currency' => 'NGN', 'balance' => 10000]);
        $this->user->wallets()->create(['currency' => 'USD', 'balance' => 0]);
        
        // Setup exchange rate
        ExchangeRate::create([
            'from_currency' => 'NGN',
            'to_currency' => 'USD',
            'rate' => 0.000625, // 1 NGN = 0.000625 USD
            'fee_percentage' => 2.0, // 2% fee
        ]);
    }

    public function test_user_can_view_wallets()
    {
        $response = $this->actingAs($this->user)
            ->getJson('/api/wallets');

        $response->assertStatus(200)
            ->assertJsonCount(2);
    }

    public function test_user_can_convert_currency()
    {
        // Convert 1000 NGN to USD
        // Fee = 2% of 1000 = 20 NGN. Net = 980 NGN.
        // Convert 980 NGN * 0.000625 = 0.6125 USD.

        $response = $this->actingAs($this->user)
            ->postJson('/api/wallets/convert', [
                'from_currency' => 'NGN',
                'to_currency' => 'USD',
                'amount' => 1000,
                'pin' => '1234',
            ]);

        $response->assertStatus(200)
            ->assertJsonPath('message', 'Conversion successful.');

        $this->assertEquals(9000, $this->user->wallets()->where('currency', 'NGN')->first()->balance);
        $this->assertEquals(0.6125, $this->user->wallets()->where('currency', 'USD')->first()->balance);
        
        // Verify ledger entries
        $this->assertDatabaseCount('transactions', 2);
    }

    public function test_conversion_fails_with_invalid_pin()
    {
        $response = $this->actingAs($this->user)
            ->postJson('/api/wallets/convert', [
                'from_currency' => 'NGN',
                'to_currency' => 'USD',
                'amount' => 1000,
                'pin' => '9999',
            ]);

        $response->assertStatus(403)
            ->assertJsonPath('message', 'Invalid transaction PIN.');
    }

    public function test_conversion_fails_with_insufficient_balance()
    {
        $response = $this->actingAs($this->user)
            ->postJson('/api/wallets/convert', [
                'from_currency' => 'NGN',
                'to_currency' => 'USD',
                'amount' => 1000000,
                'pin' => '1234',
            ]);

        $response->assertStatus(400)
            ->assertJsonPath('message', 'Insufficient balance.');
    }

    public function test_user_can_resolve_internal_account()
    {
        $otherUser = User::factory()->create([
            'name' => 'John Doe',
            'account_number' => '1234567890'
        ]);

        $response = $this->actingAs($this->user)
            ->getJson("/api/wallets/resolve-account/{$otherUser->account_number}");

        $response->assertStatus(200)
            ->assertJson([
                'name' => 'John Doe',
                'account_number' => '1234567890'
            ]);
    }

    public function test_resolve_internal_account_fails_if_not_found()
    {
        $response = $this->actingAs($this->user)
            ->getJson("/api/wallets/resolve-account/0000000000");

        $response->assertStatus(404);
    }

    public function test_user_can_resolve_external_account()
    {
        $response = $this->actingAs($this->user)
            ->getJson("/api/wallets/resolve-external-account/1000000000");

        $response->assertStatus(200)
            ->assertJsonStructure(['account_number', 'bank_name', 'account_name']);
    }

    public function test_resolve_external_account_fails_if_invalid_length()
    {
        $response = $this->actingAs($this->user)
            ->getJson("/api/wallets/resolve-external-account/123");

        $response->assertStatus(400);
    }
}
