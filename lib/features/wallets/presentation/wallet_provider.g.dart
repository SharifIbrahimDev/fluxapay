// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$walletRepositoryHash() => r'd6aaed4aba4e800ebcc62915d0dc7b76b45625c6';

/// See also [walletRepository].
@ProviderFor(walletRepository)
final walletRepositoryProvider = Provider<WalletRepository>.internal(
  walletRepository,
  name: r'walletRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$walletRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WalletRepositoryRef = ProviderRef<WalletRepository>;
String _$transactionsHash() => r'91e438dfe84e6dbdb9d2c512a04e213f3222e9b4';

/// See also [transactions].
@ProviderFor(transactions)
final transactionsProvider =
    AutoDisposeFutureProvider<List<TransactionModel>>.internal(
      transactions,
      name: r'transactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$transactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TransactionsRef = AutoDisposeFutureProviderRef<List<TransactionModel>>;
String _$walletsStateHash() => r'9b51596ff0516883ef1923d7659a0c979f71cda8';

/// See also [WalletsState].
@ProviderFor(WalletsState)
final walletsStateProvider =
    AutoDisposeAsyncNotifierProvider<WalletsState, List<WalletModel>>.internal(
      WalletsState.new,
      name: r'walletsStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$walletsStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$WalletsState = AutoDisposeAsyncNotifier<List<WalletModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
