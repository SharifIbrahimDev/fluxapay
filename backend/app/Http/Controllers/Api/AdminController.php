<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\Transaction;
use App\Models\Wallet;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    public function users()
    {
        return response()->json(User::with('wallets')->paginate(20));
    }

    public function userStats($id)
    {
        $user = User::findOrFail($id);
        $wallets = $user->wallets;
        $transactions = Transaction::whereIn('wallet_id', $wallets->pluck('id'))->latest()->limit(50)->get();

        return response()->json([
            'user' => $user,
            'wallets' => $wallets,
            'recent_transactions' => $transactions
        ]);
    }

    public function suspendUser($id)
    {
        $user = User::findOrFail($id);
        $user->status = 'suspended';
        $user->save();

        return response()->json(['message' => 'User suspended successfully.']);
    }

    public function reactivateUser($id)
    {
        $user = User::findOrFail($id);
        $user->status = 'active';
        $user->save();

        return response()->json(['message' => 'User reactivated successfully.']);
    }

    public function allTransactions()
    {
        return response()->json(Transaction::with('wallet.user')->latest()->paginate(50));
    }

    public function approveWithdrawal($reference)
    {
        $transaction = Transaction::where('reference', $reference)->firstOrFail();
        if ($transaction->status !== 'pending') {
            return response()->json(['message' => 'Transaction already processed.'], 400);
        }

        $transaction->status = 'completed';
        $transaction->save();

        return response()->json(['message' => 'Withdrawal approved.']);
    }
}
