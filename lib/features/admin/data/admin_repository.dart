import 'package:fluxapay/core/api/api_client.dart';
import 'package:fluxapay/shared/models/user_model.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';

class AdminRepository {
  final ApiClient apiClient;

  AdminRepository(this.apiClient);

  Future<List<UserModel>> getUsers() async {
    final response = await apiClient.get('/admin/users');
    return (response.data['data'] as List).map((e) => UserModel.fromJson(e)).toList();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final response = await apiClient.get('/admin/transactions');
    return (response.data['data'] as List).map((e) => TransactionModel.fromJson(e)).toList();
  }

  Future<void> approveWithdrawal(String reference) async {
    await apiClient.post('/admin/withdrawals/$reference/approve');
  }

  Future<void> suspendUser(int userId) async {
    await apiClient.post('/admin/users/$userId/suspend');
  }

  Future<void> reactivateUser(int userId) async {
    await apiClient.post('/admin/users/$userId/reactivate');
  }
}
