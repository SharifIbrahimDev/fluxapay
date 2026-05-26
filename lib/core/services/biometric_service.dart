import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final biometricServiceProvider = Provider((ref) => BiometricService());

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate = canAuthenticateWithBiometrics || await _auth.isDeviceSupported();
      return canAuthenticate;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access FluxaPay',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Allow PIN/Pattern fallback if needed, or set true for strict biometrics
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}
