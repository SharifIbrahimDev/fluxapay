<?php

namespace App\Services;

use App\Models\Wallet;
use App\Models\Transaction;
use App\Models\User;
use App\Models\ExchangeRate;
use Illuminate\Support\Facades\DB;
use Exception;

class WalletService
{
    /**
     * Get or create wallets for a user.
     */
    public function ensureWalletsExist($user)
    {
        $currencies = ['NGN', 'USD', 'USDT'];
        foreach ($currencies as $currency) {
            Wallet::firstOrCreate(
                ['user_id' => $user->id, 'currency' => $currency],
                ['balance' => 0, 'status' => 'active']
            );
        }
    }

    /**
     * Perform currency conversion between user wallets.
     */
    public function convert($user, $fromCurrency, $toCurrency, $amount)
    {
        return DB::transaction(function () use ($user, $fromCurrency, $toCurrency, $amount) {
            $fromWallet = $user->wallets()->where('currency', $fromCurrency)->first();
            $toWallet = $user->wallets()->where('currency', $toCurrency)->first();

            if (!$fromWallet || !$toWallet) {
                throw new Exception("One or more wallets not found.");
            }

            if ($fromWallet->balance < $amount) {
                throw new Exception("Insufficient balance.");
            }

            $rateRecord = ExchangeRate::where('from_currency', $fromCurrency)
                ->where('to_currency', $toCurrency)
                ->first();

            if (!$rateRecord) {
                throw new Exception("Exchange rate not found for $fromCurrency to $toCurrency.");
            }

            $fee = ($rateRecord->fee_percentage / 100) * $amount;
            $netAmount = $amount - $fee;
            $convertedAmount = $netAmount * $rateRecord->rate;

            // Debit from source
            $fromWallet->decrement('balance', $amount);
            Transaction::create([
                'wallet_id' => $fromWallet->id,
                'amount' => $amount,
                'type' => 'debit',
                'category' => 'conversion',
                'reference' => 'CNV-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => "Conversion to $toCurrency",
                'metadata' => ['rate' => $rateRecord->rate, 'fee' => $fee, 'target_currency' => $toCurrency]
            ]);

            // Credit to destination
            $toWallet->increment('balance', $convertedAmount);
            Transaction::create([
                'wallet_id' => $toWallet->id,
                'amount' => $convertedAmount,
                'type' => 'credit',
                'category' => 'conversion',
                'reference' => 'CNV-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => "Conversion from $fromCurrency",
                'metadata' => ['rate' => $rateRecord->rate, 'source_amount' => $amount, 'source_currency' => $fromCurrency]
            ]);

            return [
                'from_wallet' => $fromWallet,
                'to_wallet' => $toWallet,
                'converted_amount' => $convertedAmount
            ];
        });
    }

    /**
     * Generic credit operation.
     */
    public function credit($wallet, $amount, $category, $description = null, $metadata = [])
    {
        return DB::transaction(function () use ($wallet, $amount, $category, $description, $metadata) {
            $wallet->increment('balance', $amount);
            return Transaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'credit',
                'category' => $category,
                'reference' => strtoupper($category[0]) . 'CR-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => $description,
                'metadata' => $metadata
            ]);
        });
    }

    /**
     * Generic debit operation.
     */
    public function debit($wallet, $amount, $category, $description = null, $metadata = [])
    {
        return DB::transaction(function () use ($wallet, $amount, $category, $description, $metadata) {
            if ($wallet->balance < $amount) {
                throw new Exception("Insufficient balance.");
            }
            $wallet->decrement('balance', $amount);
            return Transaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'debit',
                'category' => $category,
                'reference' => strtoupper($category[0]) . 'DB-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => $description,
                'metadata' => $metadata
            ]);
        });
    }

    /**
     * Fund a wallet (Deposit).
     */
    public function fund($user, $currency, $amount)
    {
        return DB::transaction(function () use ($user, $currency, $amount) {
            $wallet = $user->wallets()->where('currency', $currency)->first();
            if (!$wallet) {
                throw new Exception("Wallet not found.");
            }

            $wallet->increment('balance', $amount);
            return Transaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'credit',
                'category' => 'funding',
                'reference' => 'FND-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => "Wallet Funded",
                'metadata' => ['method' => 'card']
            ]);
        });
    }

    /**
     * Withdraw from wallet.
     */
    public function withdraw($user, $currency, $amount, $bankDetails)
    {
        return DB::transaction(function () use ($user, $currency, $amount, $bankDetails) {
            $wallet = $user->wallets()->where('currency', $currency)->first();
            if (!$wallet) {
                throw new Exception("Wallet not found.");
            }

            if ($wallet->balance < $amount) {
                throw new Exception("Insufficient balance.");
            }

            $wallet->decrement('balance', $amount);
            return Transaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'debit',
                'category' => 'withdrawal',
                'reference' => 'WTH-' . strtoupper(uniqid()),
                'status' => 'pending',
                'description' => "Withdrawal to " . ($bankDetails['bank_name'] ?? 'Bank'),
                'metadata' => $bankDetails
            ]);
        });
    }

    /**
     * Perform P2P transfer between users.
     */
    public function transfer($sender, $recipientIdentifier, $amount, $currency)
    {
        return DB::transaction(function () use ($sender, $recipientIdentifier, $amount, $currency) {
            
            // Check if identifier is email or account number
            $recipient = User::where('email', $recipientIdentifier)
                           ->orWhere('account_number', $recipientIdentifier)
                           ->first();
                           
            if (!$recipient) {
                throw new Exception("Recipient not found.");
            }

            if ($sender->id === $recipient->id) {
                throw new Exception("Cannot send money to yourself.");
            }

            $senderWallet = $sender->wallets()->where('currency', $currency)->first();
            // Ensure recipient has wallet
            $recipientWallet = $recipient->wallets()->where('currency', $currency)->first();
            if (!$recipientWallet) {
                 $recipientWallet = Wallet::create([
                    'user_id' => $recipient->id, 
                    'currency' => $currency,
                    'balance' => 0, 
                    'status' => 'active'
                ]);
            }
            
            if (!$senderWallet) {
                throw new Exception("Sender wallet not found for $currency.");
            }

            if ($senderWallet->balance < $amount) {
                throw new Exception("Insufficient balance.");
            }

            // Debit Sender
            $senderWallet->decrement('balance', $amount);
            Transaction::create([
                'wallet_id' => $senderWallet->id,
                'amount' => $amount,
                'type' => 'debit',
                'category' => 'transfer',
                'reference' => 'TRF-OUT-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => "Transfer to {$recipient->name}",
                'metadata' => ['recipient_id' => $recipient->account_number, 'recipient_name' => $recipient->name]
            ]);

            // Credit Recipient
            $recipientWallet->increment('balance', $amount);
            Transaction::create([
                'wallet_id' => $recipientWallet->id,
                'amount' => $amount,
                'type' => 'credit',
                'category' => 'transfer',
                'reference' => 'TRF-IN-' . strtoupper(uniqid()),
                'status' => 'completed',
                'description' => "Transfer from {$sender->name}",
                'metadata' => ['sender_id' => $sender->account_number, 'sender_name' => $sender->name]
            ]);

            return [
                'sender_wallet' => $senderWallet,
                'amount' => $amount
            ];
        });
    }

    public function resolveExternalAccount($accountNumber)
    {
        // Mock Implementation for External Banks
        // In a real app, this would query a banking provider API (like Paystack/Flutterwave)
        
        $banks = ['Access Bank', 'GTBank', 'Zenith Bank', 'UBA', 'First Bank'];
        $firstDigit = (int) substr($accountNumber, 0, 1);
        $bankName = $banks[$firstDigit % count($banks)];
        
        return [
            'account_number' => $accountNumber,
            'bank_name' => $bankName,
            'account_name' => 'Mock User ' . substr($accountNumber, -4)
        ];
    }
}
