import 'package:fluxapay/features/auth/presentation/auth_provider.dart';
import 'package:fluxapay/features/wallets/data/wallet_repository.dart';
import 'package:fluxapay/shared/models/wallet_model.dart';
import 'package:fluxapay/shared/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wallet_provider.g.dart';

@Riverpod(keepAlive: true)
WalletRepository walletRepository(Ref ref) {
  return WalletRepository(ref.watch(apiClientProvider));
}

@riverpod
class WalletsState extends _$WalletsState {
  @override
  FutureOr<List<WalletModel>> build() async {
    return ref.read(walletRepositoryProvider).getWallets();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref.read(walletRepositoryProvider).getWallets());
  }
}

@riverpod
Future<List<TransactionModel>> transactions(Ref ref) async {
  return ref.read(walletRepositoryProvider).getTransactions();
}
