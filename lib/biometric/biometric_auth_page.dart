import 'package:flutter/material.dart';
import 'package:flutter_poc/biometric/home_page.dart';
import 'package:flutter_poc/biometric/viewmodel.dart';
class BiometricAuthPage extends StatefulWidget {
  const BiometricAuthPage({super.key});

  @override
  _BiometricAuthPageState createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends State<BiometricAuthPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = 'Masukkan email dan password untuk login';
  String? _currentUser;

  final AuthViewModel _viewModel = AuthViewModel();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final account = await _viewModel.login(username, password);

    if (account != null) {
      setState(() {
        _currentUser = username;
        _message = 'Login berhasil!';
      });

      if (!account['hasAllowedBiometric']) {
        bool allowBiometric = await _viewModel.showBiometricPrompt(context, account);
        if (allowBiometric) {
          await _viewModel.requestBiometricAuthentication(account);
        } 
        // else {
          _navigateToSecondPage(account);
        // }
      } else {
        _navigateToSecondPage(account);
      }
    } else {
      setState(() {
        _message = 'Username atau password salah';
      });
    }
  }

  Future<void> _authenticateWithBiometric() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final account = await _viewModel.getAccount(username, password);

    if (account == null) {
      setState(() {
        _message = 'Masukkan username dan password yang valid terlebih dahulu.';
      });
      return;
    }

    if (account['hasAllowedBiometric']) {
      await _viewModel.requestBiometricAuthentication(account);
      _navigateToSecondPage(account);
    } else {
      setState(() {
        _message = 'Biometrik belum diizinkan. Silakan login dengan email.';
      });
    }
  }

  void _navigateToSecondPage(Map<String, dynamic> account) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondPage(account: account),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login dengan Email'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _authenticateWithBiometric,
              child: const Text('Login dengan Biometrik'),
            ),
          ],
        ),
      ),
    );
  }
}
