import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_poc/E2E_enrcryption/service.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final EncryptionService _encryptionService = EncryptionService();
  String? _encryptedData;
  String? _decryptedData;

  Future<void> _processTransaction() async {
    final accountNumber = _accountController.text;
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    // Data transaksi yang akan dienkripsi
    final transactionData = jsonEncode({
      'accountNumber': accountNumber,
      'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    });

    // Enkripsi data
    final encrypted = await _encryptionService.encryptTransactionData(transactionData);
    setState(() {
      _encryptedData = encrypted;
    });

    // Dekripsi data untuk memverifikasi
    final decrypted = await _encryptionService.decryptTransactionData(encrypted);
    setState(() {
      _decryptedData = decrypted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bank Transaction Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _accountController,
              decoration: InputDecoration(labelText: 'Account Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processTransaction,
              child: Text('Process Transaction'),
            ),
            SizedBox(height: 20),
            if (_encryptedData != null) ...[
              Text('Encrypted Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_encryptedData!, style: TextStyle(color: Colors.blue)),
            ],
            SizedBox(height: 20),
            if (_decryptedData != null) ...[
              Text('Decrypted Data:', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_decryptedData!, style: TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}
