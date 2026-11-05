import 'dart:convert';
import 'package:encrypt/encrypt.dart';

class WorldlineEncryption {
  // static const String keyString = 'X5mUl3J1jneCd0adISoHWDTj7U8Rnhvd';
  static const String keyString = '0vHXVAke4JDi6xhvPPOk1kk5szKBueh6';

   //static const String ivString = '1111111245683783';
  static const String ivString = 'ccvObLkKrnYNUHyw';

  static String encryptRequest(Map<String, dynamic> request) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(jsonEncode(request), iv: iv);
    print('Encrypted Request: ${encrypted.base64}');
    return encrypted.base64;
  }

  static String decryptResponse(String encryptedText) {
    final key = Key.fromUtf8(keyString);
    final iv = IV.fromUtf8(ivString);

    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));

    return encrypter.decrypt64(encryptedText, iv: iv);
  }
}
