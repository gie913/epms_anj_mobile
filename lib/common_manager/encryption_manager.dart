import 'package:encrypt/encrypt.dart';

class EncryptionManager {
  static String encryptData(String data) {
    final key = Key.fromUtf8('epms123456789012');
    final iv = IV.fromUtf8('epms123456789012');
    final encryptor = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encryptor.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String data) {
    Encrypted encrypted = Encrypted.from64(data);
    final key = Key.fromUtf8('epms123456789012');
    final iv = IV.fromUtf8('epms123456789012');
    final encryptor = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encryptor.decrypt(encrypted, iv: iv);
    return decrypted;
  }
}
