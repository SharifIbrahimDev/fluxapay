import 'package:fluxapay/core/api/api_client.dart';
import 'package:fluxapay/shared/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final ApiClient apiClient;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  AuthRepository(this.apiClient);

  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', data: {
      'email': email,
      'password': password,
    });
    
    final token = response.data['access_token'];
    await storage.write(key: 'auth_token', value: token);
    
    return UserModel.fromJson(response.data['user']);
  }

  Future<UserModel> register(String name, String email, String phone, String password) async {
    final response = await apiClient.post('/register', data: {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': password,
    });
    
    final token = response.data['access_token'];
    await storage.write(key: 'auth_token', value: token);
    
    return UserModel.fromJson(response.data['user']);
  }

  Future<void> logout() async {
    await apiClient.post('/logout');
    await storage.delete(key: 'auth_token');
  }

  Future<UserModel?> getUser() async {
    final token = await storage.read(key: 'auth_token');
    if (token == null) return null;
    
    try {
      final response = await apiClient.get('/user');
      return UserModel.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<void> setPin(String pin) async {
    await apiClient.post('/set-pin', data: {
      'pin': pin,
      'pin_confirmation': pin,
    });
  }

  Future<void> changePin(String oldPin, String newPin) async {
    await apiClient.post('/change-pin', data: {
      'old_pin': oldPin,
      'new_pin': newPin,
      'new_pin_confirmation': newPin,
    });
  }

  Future<void> saveBiometricCredentials(String email, String password) async {
    await storage.write(key: 'biometric_email', value: email);
    await storage.write(key: 'biometric_password', value: password);
  }

  Future<Map<String, String>?> getBiometricCredentials() async {
    final email = await storage.read(key: 'biometric_email');
    final password = await storage.read(key: 'biometric_password');
    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }

  Future<void> clearBiometricCredentials() async {
    await storage.delete(key: 'biometric_email');
    await storage.delete(key: 'biometric_password');
  }

  Future<String> forgotPassword(String email) async {
    final response = await apiClient.post('/forgot-password', data: {'email': email});
    return response.data['reset_token'];
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    await apiClient.post('/reset-password', data: {
      'email': email,
      'token': token,
      'password': password,
      'password_confirmation': password,
    });
  }
}
