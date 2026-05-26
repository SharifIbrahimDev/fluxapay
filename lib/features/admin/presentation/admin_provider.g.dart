// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$adminRepositoryHash() => r'f2f0ea1b844e9c3ad5e562dd8c89e24a2122aa3e';

/// See also [adminRepository].
@ProviderFor(adminRepository)
final adminRepositoryProvider = Provider<AdminRepository>.internal(
  adminRepository,
  name: r'adminRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$adminRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AdminRepositoryRef = ProviderRef<AdminRepository>;
String _$adminUsersHash() => r'bbe382a0d44616f161786eea7869e094824a1bb7';

/// See also [AdminUsers].
@ProviderFor(AdminUsers)
final adminUsersProvider =
    AutoDisposeAsyncNotifierProvider<AdminUsers, List<UserModel>>.internal(
      AdminUsers.new,
      name: r'adminUsersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminUsersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminUsers = AutoDisposeAsyncNotifier<List<UserModel>>;
String _$adminTransactionsHash() => r'74b125fc32bc86feb3b59314ed728d9ca838ea91';

/// See also [AdminTransactions].
@ProviderFor(AdminTransactions)
final adminTransactionsProvider =
    AutoDisposeAsyncNotifierProvider<
      AdminTransactions,
      List<TransactionModel>
    >.internal(
      AdminTransactions.new,
      name: r'adminTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$adminTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AdminTransactions = AutoDisposeAsyncNotifier<List<TransactionModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
