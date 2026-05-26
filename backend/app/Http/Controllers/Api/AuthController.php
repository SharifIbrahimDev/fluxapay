<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\WalletService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    protected $walletService;

    public function __construct(WalletService $walletService)
    {
        $this->walletService = $walletService;
    }

    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'email' => 'required|string|email|max:255|unique:users',
            'phone' => 'required|string|unique:users',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $accountNumber = $this->generateAccountNumber();

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'phone' => $request->phone,
            'password' => Hash::make($request->password),
            'account_number' => $accountNumber,
            'status' => 'active',
        ]);

        $this->walletService->ensureWalletsExist($user);

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user->load('wallets'),
        ]);
    }

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Invalid credentials.'],
            ]);
        }

        if ($user->status !== 'active') {
            return response()->json(['message' => 'Account is suspended.'], 403);
        }

        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user->load('wallets'),
        ]);
    }

    public function setPin(Request $request)
    {
        $request->validate([
            'pin' => 'required|string|size:4|confirmed',
        ]);

        $user = $request->user();
        $user->transaction_pin = Hash::make($request->pin);
        $user->save();

        return response()->json(['message' => 'Transaction PIN set successfully.']);
    }

    public function changePin(Request $request)
    {
        $request->validate([
            'old_pin' => 'required|string|size:4',
            'new_pin' => 'required|string|size:4|confirmed',
        ]);

        $user = $request->user();

        if (!Hash::check($request->old_pin, $user->transaction_pin)) {
            return response()->json(['message' => 'Old transaction PIN is incorrect.'], 403);
        }

        $user->transaction_pin = Hash::make($request->new_pin);
        $user->save();

        return response()->json(['message' => 'Transaction PIN updated successfully.']);
    }

    public function user(Request $request)
    {
        return response()->json($request->user()->load('wallets'));
    }

    public function logout(Request $request)
    {
        $request->user()->currentAccessToken()->delete();
        return response()->json(['message' => 'Logged out successfully.']);
    }

    public function forgotPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'Email address not found in our records.'], 404);
        }

        // In a real application, you would generate a unique token and send an email.
        // For this premium MVP, we'll simulate the process with a demo token.
        return response()->json([
            'message' => 'Password reset instructions have been sent to your email.',
            'reset_token' => 'PREMIUM_RESET_TOKEN_' . strtoupper(substr(md5($user->email), 0, 8))
        ]);
    }

    public function resetPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'token' => 'required|string',
            'password' => 'required|string|min:8|confirmed',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user) {
            return response()->json(['message' => 'User account not found.'], 404);
        }

        // Simulating token verification
        $expectedToken = 'PREMIUM_RESET_TOKEN_' . strtoupper(substr(md5($user->email), 0, 8));
        if ($request->token !== $expectedToken) {
            return response()->json(['message' => 'Invalid or expired reset token.'], 422);
        }

        $user->password = Hash::make($request->password);
        $user->save();

        return response()->json(['message' => 'Your password has been successfully reset.']);
    }

    private function generateAccountNumber()
    {
        do {
            $number = '20' . str_pad(mt_rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        } while (User::where('account_number', $number)->exists());
        
        return $number;
    }
}
