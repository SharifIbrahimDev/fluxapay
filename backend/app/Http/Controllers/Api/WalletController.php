<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Wallet;
use App\Models\ExchangeRate;
use App\Models\Transaction;
use App\Services\WalletService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Exception;

class WalletController extends Controller
{
    protected $walletService;

    public function __construct(WalletService $walletService)
    {
        $this->walletService = $walletService;
    }

    public function index(Request $request)
    {
        return response()->json($request->user()->wallets()->with('transactions')->get());
    }

    public function show(Request $request, $currency)
    {
        $wallet = $request->user()->wallets()->where('currency', strtoupper($currency))->firstOrFail();
        return response()->json($wallet->load(['transactions' => function ($q) {
            $q->latest()->limit(20);
        }]));
    }

    public function convert(Request $request)
    {
        $request->validate([
            'from_currency' => 'required|string',
            'to_currency' => 'required|string',
            'amount' => 'required|numeric|min:0.01',
            'pin' => 'required|string',
        ]);

        $user = $request->user();

        if (!Hash::check($request->pin, $user->transaction_pin)) {
            return response()->json(['message' => 'Invalid transaction PIN.'], 403);
        }

        try {
            $result = $this->walletService->convert(
                $user,
                strtoupper($request->from_currency),
                strtoupper($request->to_currency),
                $request->amount
            );

            return response()->json([
                'message' => 'Conversion successful.',
                'data' => $result
            ]);
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    public function transfer(Request $request)
    {
        $request->validate([
            'recipient' => 'required|string', // Can be email or account number
            'amount' => 'required|numeric|min:0.01',
            'currency' => 'required|string|size:3',
            'pin' => 'required|string',
        ]);

        $user = $request->user();

        if (!Hash::check($request->pin, $user->transaction_pin)) {
            return response()->json(['message' => 'Invalid transaction PIN.'], 403);
        }

        try {
            $result = $this->walletService->transfer(
                $user,
                $request->recipient,
                $request->amount,
                strtoupper($request->currency)
            );

            return response()->json([
                'message' => 'Transfer successful.',
                'data' => $result
            ]);
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    public function getRates()
    {
        return response()->json(ExchangeRate::all());
    }

    public function fund(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1',
            'currency' => 'required|string|size:3',
        ]);

        try {
            $transaction = $this->walletService->fund(
                $request->user(),
                strtoupper($request->currency),
                $request->amount
            );

            return response()->json([
                'message' => 'Wallet funded successfully.',
                'transaction' => $transaction
            ]);
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    public function withdraw(Request $request)
    {
        $request->validate([
            'amount' => 'required|numeric|min:1',
            'currency' => 'required|string|size:3',
            'bank_name' => 'required|string',
            'account_number' => 'required|string',
            'pin' => 'required|string',
        ]);

        $user = $request->user();

        if (!Hash::check($request->pin, $user->transaction_pin)) {
            return response()->json(['message' => 'Invalid transaction PIN.'], 403);
        }

        try {
            $transaction = $this->walletService->withdraw(
                $user,
                strtoupper($request->currency),
                $request->amount,
                $request->only(['bank_name', 'account_number', 'account_name'])
            );

            return response()->json([
                'message' => 'Withdrawal request submitted.',
                'transaction' => $transaction
            ]);
        } catch (Exception $e) {
            return response()->json(['message' => $e->getMessage()], 400);
        }
    }

    public function transactions(Request $request)
    {
        $walletsIds = $request->user()->wallets()->pluck('id');
        $transactions = Transaction::whereIn('wallet_id', $walletsIds)
            ->with('wallet')
            ->latest()
            ->paginate(20);

        return response()->json($transactions);
    }

    public function resolveAccount($account_number)
    {
        $user = \App\Models\User::where('account_number', $account_number)->first();

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        return response()->json([
            'name' => $user->name,
            'account_number' => $user->account_number
        ]);
    }

    public function resolveExternalAccount($account_number)
    {
        if (strlen($account_number) !== 10) {
             return response()->json(['message' => 'Invalid account number'], 400);
        }

        $data = $this->walletService->resolveExternalAccount($account_number);
        return response()->json($data);
    }
}
