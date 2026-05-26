import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:fluxapay/features/admin/data/admin_repository.dart';
import 'package:fluxapay/shared/models/user_model.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_provider.g.dart';

@Riverpod(keepAlive: true)
AdminRepository adminRepository(Ref ref) {
  return AdminRepository(ref.watch(apiClientProvider));
}

@riverpod
class AdminUsers extends _$AdminUsers {
  @override
  FutureOr<List<UserModel>> build() async {
    return ref.read(adminRepositoryProvider).getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getUsers());
  }

  Future<void> suspendUser(int userId) async {
    await ref.read(adminRepositoryProvider).suspendUser(userId);
    ref.invalidateSelf();
  }

  Future<void> reactivateUser(int userId) async {
    await ref.read(adminRepositoryProvider).reactivateUser(userId);
    ref.invalidateSelf();
  }
}

@riverpod
class AdminTransactions extends _$AdminTransactions {
  @override
  FutureOr<List<TransactionModel>> build() async {
    return ref.read(adminRepositoryProvider).getAllTransactions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(adminRepositoryProvider).getAllTransactions());
  }

  Future<void> approveWithdrawal(String reference) async {
    await ref.read(adminRepositoryProvider).approveWithdrawal(reference);
    ref.invalidateSelf();
  }
}
