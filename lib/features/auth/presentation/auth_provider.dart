import 'package:fluxapay/core/api/api_client.dart';
import 'package:fluxapay/features/auth/data/auth_repository.dart';
import 'package:fluxapay/shared/models/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  // Use your machine's LAN IP for physical device testing
  // IP found via ipconfig: 192.168.140.96
  final baseUrl = (defaultTargetPlatform == TargetPlatform.android)
      ? 'http://192.168.140.96:8000/api' // Updated for physical device/emulator
      : 'http://localhost:8000/api';
  
  // Note: For physical device testing, you might need to use your machine's LAN IP:
  // final baseUrl = 'http://192.168.140.96:8000/api'; 
  return ApiClient(baseUrl: baseUrl);
}

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepository(ref.watch(apiClientProvider));
}

@riverpod
class AuthState extends _$AuthState {
  @override
  FutureOr<UserModel?> build() async {
    return ref.read(authRepositoryProvider).getUser();
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      
      // Save credentials if biometric is enabled
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool('biometric_enabled') ?? false) {
        await ref.read(authRepositoryProvider).saveBiometricCredentials(email, password);
      }
      
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> enableBiometric(String password) async {
    final user = state.valueOrNull;
    if (user == null) throw Exception('User not logged in');
    await ref.read(authRepositoryProvider).saveBiometricCredentials(user.email, password);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometric_enabled', true);
  }

  Future<void> loginWithBiometrics() async {
    state = const AsyncLoading();
    try {
      final creds = await ref.read(authRepositoryProvider).getBiometricCredentials();
      if (creds == null) {
        throw Exception('No biometric credentials found. Please login manually first.');
      }
      
      final user = await ref.read(authRepositoryProvider).login(creds['email']!, creds['password']!);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> register(String name, String email, String phone, String password) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).register(name, email, phone, password);
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    // Optional: Clear biometric creds on explicit logout? 
    // Usually explicit logout means "forget me", but biometric often persists.
    // Let's keep it for convenience, or clear it if security is strict.
    // For MVP, we KEEP it so they can easily log back in.
    state = const AsyncValue.data(null);
  }
}
