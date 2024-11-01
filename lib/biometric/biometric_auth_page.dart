import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricAuthPage extends StatefulWidget {
  const BiometricAuthPage({super.key});

  @override
  _BiometricAuthPageState createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _message = 'Tekan button untuk autentikasi';
  

  Future<void> _authenticate(BiometricType type) async {
    try {
      // Memeriksa apakah device mendukung biometrik atau PIN
      bool isBiometricSupported = await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (!isBiometricSupported) {
        setState(() {
          _message = 'Device Anda tidak mendukung biometrik';
        });
        return;
      }

      // Menentukan tipe autentikasi yang diizinkan
      bool isAuthenticated = await auth.authenticate(
        localizedReason: 'Izinkan akses dengan ${type == BiometricType.face ? 'Face ID' : type == BiometricType.fingerprint ? 'Fingerprint' : 'PIN'}',
        options: AuthenticationOptions(
          sensitiveTransaction: isBiometricSupported,
          useErrorDialogs: false,
          stickyAuth: false,
          biometricOnly: true, // Menyediakan PIN untuk semua tipe biometrik
        ),
      );

      // Mengatur status autentikasi berdasarkan hasil
      setState(() {
        _isAuthenticated = isAuthenticated;
        _message = isAuthenticated ? 'Autentikasi berhasil!' : 'Autentikasi gagal atau dibatalkan';
      });
    } catch (e) {
      setState(() {
        _message = 'Terjadi kesalahan: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autentikasi Biometrik'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _authenticate(BiometricType.face),
              child: const Text('Autentikasi Face ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _authenticate(BiometricType.fingerprint),
              child: const Text('Autentikasi Fingerprint'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _authenticate(BiometricType.weak),
              child: const Text('Autentikasi dengan PIN'),
            ),
          ],
        ),
      ),
    );
  }
}
