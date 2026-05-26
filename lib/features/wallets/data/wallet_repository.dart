import 'package:fluxapay/core/api/api_client.dart';
import 'package:fluxapay/shared/models/wallet_model.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';

class WalletRepository {
  final ApiClient apiClient;

  WalletRepository(this.apiClient);

  Future<List<WalletModel>> getWallets() async {
    final response = await apiClient.get('/wallets');
    return (response.data as List).map((e) => WalletModel.fromJson(e)).toList();
  }

  Future<List<dynamic>> getRates() async {
    final response = await apiClient.get('/wallets/rates');
    return response.data as List;
  }

  Future<WalletModel> getWallet(String currency) async {
    final response = await apiClient.get('/wallets/$currency');
    return WalletModel.fromJson(response.data);
  }

  Future<void> convert({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
    required String pin,
  }) async {
    await apiClient.post('/wallets/convert', data: {
      'from_currency': fromCurrency,
      'to_currency': toCurrency,
      'amount': amount,
      'pin': pin,
    });
  }

  Future<void> transfer({
    required String recipient,
    required double amount,
    required String currency,
    required String pin,
  }) async {
    await apiClient.post('/wallets/transfer', data: {
      'recipient': recipient,
      'amount': amount,
      'currency': currency,
      'pin': pin,
    });
  }

  Future<String?> resolveUser(String accountNumber) async {
    try {
      final response = await apiClient.get('/wallets/resolve-account/$accountNumber');
      return response.data['name'];
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> resolveExternalAccount(String accountNumber) async {
    try {
      final response = await apiClient.get('/wallets/resolve-external-account/$accountNumber');
      return response.data;
    } catch (e) {
      return null;
    }
  }

  Future<List<TransactionModel>> getTransactions() async {
    final response = await apiClient.get('/wallets/transactions');
    return (response.data['data'] as List).map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<void> fund({
    required String currency,
    required double amount,
  }) async {
    await apiClient.post('/wallets/fund', data: {
      'currency': currency,
      'amount': amount,
    });
  }

  Future<void> withdraw({
    required String currency,
    required double amount,
    required String bankName,
    required String accountNumber,
    required String pin,
  }) async {
    await apiClient.post('/wallets/withdraw', data: {
      'currency': currency,
      'amount': amount,
      'bank_name': bankName,
      'account_number': accountNumber,
      'pin': pin,
    });
  }
}
