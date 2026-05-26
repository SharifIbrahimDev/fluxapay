<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\AdminUser;
use App\Models\Transaction;
use App\Models\Wallet;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class AdminTest extends TestCase
{
    use RefreshDatabase;

    protected $admin;

    protected function setUp(): void
    {
        parent::setUp();
        $this->admin = User::factory()->create(['status' => 'active']); // Using User for auth as simplified in routes
    }

    public function test_admin_can_list_users()
    {
        User::factory()->count(5)->create();

        $response = $this->actingAs($this->admin)
            ->getJson('/api/admin/users');

        $response->assertStatus(200)
            ->assertJsonStructure(['data', 'links', 'current_page', 'total']);
    }

    public function test_admin_can_suspend_user()
    {
        $user = User::factory()->create(['status' => 'active']);

        $response = $this->actingAs($this->admin)
            ->postJson("/api/admin/users/{$user->id}/suspend");

        $response->assertStatus(200)
            ->assertJsonPath('message', 'User suspended successfully.');

        $this->assertEquals('suspended', $user->fresh()->status);
    }

    public function test_suspended_user_cannot_login()
    {
        $user = User::factory()->create([
            'status' => 'suspended',
            'password' => Hash::make('password123')
        ]);

        $response = $this->postJson('/api/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertStatus(403)
            ->assertJsonPath('message', 'Account is suspended.');
    }
}
