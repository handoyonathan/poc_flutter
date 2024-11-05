import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class SecondPage extends StatefulWidget {
  final Map<String, dynamic> account;

  const SecondPage({super.key, required this.account});

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _isBiometricEnabled = widget.account['hasAllowedBiometric'];
  }

  Future<void> _enableBiometric() async {
    bool isAuthenticated = await _requestBiometricAuthentication();
    if (isAuthenticated) {
      setState(() {
        _isBiometricEnabled = true;
        widget.account['hasAllowedBiometric'] = true;
      });
    }
  }

  Future<void> _disableBiometric() async {
    final passwordController = TextEditingController();
    String errorMessage = '';

    bool isPasswordCorrect = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masukkan Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (passwordController.text == widget.account['password']) {
                Navigator.of(context).pop(true);
              } else {
                setState(() {
                  errorMessage = 'Password salah. Silakan coba lagi.';
                });
                // Do not dismiss the dialog if password is incorrect
              }
            },
            child: const Text('Konfirmasi'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
        ],
      ),
    ) ?? false;

    if (isPasswordCorrect) {
      setState(() {
        _isBiometricEnabled = false;
        widget.account['hasAllowedBiometric'] = false;
      });
    }
  }

  Future<bool> _requestBiometricAuthentication() async {
    try {
      bool isAuthenticated = await LocalAuthentication().authenticate(
        localizedReason: 'Gunakan biometrik untuk mengaktifkan',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Kedua'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Biometrik ${_isBiometricEnabled ? "Diizinkan" : "Tidak Diizinkan"}'),
            SwitchListTile(
              title: const Text('Izinkan Autentikasi Biometrik'),
              value: _isBiometricEnabled,
              onChanged: (value) {
                if (value) {
                  _enableBiometric();
                } else {
                  _disableBiometric();
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('Selamat datang di Halaman Kedua!'),
          ],
        ),
      ),
    );
  }
}
