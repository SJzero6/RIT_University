import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class FingerprintProvider with ChangeNotifier {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isFingerprintSupported = false;

  bool get isAuthenticated => _isAuthenticated;
  bool get isFingerprintSupported => _isFingerprintSupported;

  FingerprintProvider() {
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    try {
      _isFingerprintSupported = await auth.canCheckBiometrics;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> authenticate() async {
    try {
      _isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          biometricOnly: true,
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void resetAuthentication() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
