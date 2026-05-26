<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\WalletController;
use App\Http\Controllers\Api\AdminController;
use Illuminate\Support\Facades\Route;

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login'])->name('login');
Route::post('/forgot-password', [AuthController::class, 'forgotPassword']);
Route::post('/reset-password', [AuthController::class, 'resetPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/set-pin', [AuthController::class, 'setPin']);
    Route::post('/change-pin', [AuthController::class, 'changePin']);

    Route::prefix('wallets')->group(function () {
        Route::get('/', [WalletController::class, 'index']);
        Route::get('/rates', [WalletController::class, 'getRates']);
        Route::get('/transactions', [WalletController::class, 'transactions']);
        Route::get('/{currency}', [WalletController::class, 'show']);
        Route::post('/convert', [WalletController::class, 'convert']);
        Route::post('/transfer', [WalletController::class, 'transfer']);
        Route::post('/fund', [WalletController::class, 'fund']);
        Route::post('/withdraw', [WalletController::class, 'withdraw']);
        Route::get('/resolve-account/{account_number}', [WalletController::class, 'resolveAccount']);
        Route::get('/resolve-external-account/{account_number}', [WalletController::class, 'resolveExternalAccount']);
    });

    Route::prefix('admin')->group(function () {
        Route::get('/users', [AdminController::class, 'users']);
        Route::get('/users/{id}', [AdminController::class, 'userStats']);
        Route::post('/users/{id}/suspend', [AdminController::class, 'suspendUser']);
        Route::post('/users/{id}/reactivate', [AdminController::class, 'reactivateUser']);
        Route::get('/transactions', [AdminController::class, 'allTransactions']);
        Route::post('/withdrawals/{reference}/approve', [AdminController::class, 'approveWithdrawal']);
    });
});
