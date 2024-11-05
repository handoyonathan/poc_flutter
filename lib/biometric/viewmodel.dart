import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AuthViewModel {
  final LocalAuthentication _auth = LocalAuthentication();

  final List<Map<String, dynamic>> dummyAccounts = [
    {'username': 'user1', 'password': 'password1', 'hasAllowedBiometric': false},
    {'username': 'user2', 'password': 'password2', 'hasAllowedBiometric': false},
  ];

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final account = dummyAccounts.firstWhere(
      (account) => account['username'] == username && account['password'] == password,
      orElse: () => {},
    );
    return account.isNotEmpty ? account : null;
  }

  Future<bool> showBiometricPrompt(BuildContext context, Map<String, dynamic> account) async {
    bool useBiometric = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Gunakan Biometrik?'),
        content: const Text('Apakah Anda ingin menggunakan autentikasi biometrik untuk login berikutnya?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya'),
          ),
        ],
      ),
    ) ?? false;

    if (useBiometric) {
      account['hasAllowedBiometric'] = true;
    }
    return useBiometric;
  }

  Future<void> requestBiometricAuthentication(Map<String, dynamic> account) async {
    try {
      bool isAuthenticated = await _auth.authenticate(
        localizedReason: 'Gunakan biometrik untuk login',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        // Navigate or perform actions after successful authentication
      } else {
        // Handle failed authentication
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<Map<String, dynamic>?> getAccount(String username, String password) async {
    return await login(username, password);
  }
}
