import 'package:encrypt/encrypt.dart' as encrypt; // Menggunakan alias untuk menghindari konflik
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class EncryptionService {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String> _getOrGenerateKey() async {
    final key = await _secureStorage.read(key: 'encryption_key');
    if (key == null) {
      final newKey = encrypt.Key.fromSecureRandom(32); // 256-bit key
      await _secureStorage.write(key: 'encryption_key', value: base64UrlEncode(newKey.bytes));
      return base64UrlEncode(newKey.bytes);
    }
    return key;
  }

  Future<encrypt.IV> _getOrGenerateIV() async {
    final iv = await _secureStorage.read(key: 'encryption_iv');
    if (iv == null) {
      final newIV = encrypt.IV.fromSecureRandom(16); // 128-bit IV
      await _secureStorage.write(key: 'encryption_iv', value: base64UrlEncode(newIV.bytes));
      return newIV;
    }
    return encrypt.IV(base64Url.decode(iv));
  }

  Future<String> encryptTransactionData(String plainText) async {
    final key = encrypt.Key(base64Url.decode(await _getOrGenerateKey()));
    final iv = await _getOrGenerateIV();
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return encrypted.base64;
  }

  Future<String> decryptTransactionData(String encryptedText) async {
    final key = encrypt.Key(base64Url.decode(await _getOrGenerateKey()));
    final iv = await _getOrGenerateIV();
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
