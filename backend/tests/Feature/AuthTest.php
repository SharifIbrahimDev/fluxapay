<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_register()
    {
        $response = $this->postJson('/api/register', [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'phone' => '08000000000',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure(['access_token', 'token_type', 'user'])
            ->assertJsonPath('user.email', 'test@example.com');

        $this->assertDatabaseHas('users', ['email' => 'test@example.com']);
        $this->assertDatabaseCount('wallets', 3); // NGN, USD, USDT
    }

    public function test_user_can_login()
    {
        $user = User::factory()->create([
            'password' => Hash::make('password123'),
        ]);

        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(200)
            ->assertJsonStructure(['access_token', 'token_type', 'user']);
    }

    public function test_user_can_set_pin()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->postJson('/api/set-pin', [
                'pin' => '1234',
                'pin_confirmation' => '1234',
            ]);

        $response->assertStatus(200)
            ->assertJson(['message' => 'Transaction PIN set successfully.']);

        $user->refresh();
        $this->assertTrue(Hash::check('1234', $user->transaction_pin));
    }
}
