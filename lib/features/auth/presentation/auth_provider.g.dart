// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiClientHash() => r'4887b6419395041040c7c9059e8e5ecdaa214fd0';

/// See also [apiClient].
@ProviderFor(apiClient)
final apiClientProvider = Provider<ApiClient>.internal(
  apiClient,
  name: r'apiClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiClientRef = ProviderRef<ApiClient>;
String _$authRepositoryHash() => r'79cd6f6b0f92f9024a804c141c8fbc10d12c2a51';

/// See also [authRepository].
@ProviderFor(authRepository)
final authRepositoryProvider = Provider<AuthRepository>.internal(
  authRepository,
  name: r'authRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$authRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AuthRepositoryRef = ProviderRef<AuthRepository>;
String _$authStateHash() => r'18279d5bc918971fbbaef61f982058e3d6813b4b';

/// See also [AuthState].
@ProviderFor(AuthState)
final authStateProvider =
    AutoDisposeAsyncNotifierProvider<AuthState, UserModel?>.internal(
      AuthState.new,
      name: r'authStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$authStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AuthState = AutoDisposeAsyncNotifier<UserModel?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
