import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:cryptography/cryptography.dart';

const int _keyLength = 32;
const int _ivLength = 12;
const int _tagLength = 16;
const int _saltLength = 16;
const int _keyIterationsCount = 10000;

class Aes256Gcm {
  /// Encrypts passed [cleartext] with key generated based on [password] argument
  static Future<String> encrypt(String cleartext, String password) async {
    final salt = randomBytes(_saltLength);
    final iv = randomBytes(_ivLength);
    final key = await deriveKey(password, salt);
    final algorithm = AesGcm.with256bits();

    final secretBox = await algorithm.encrypt(
      utf8.encode(cleartext),
      secretKey: key,
      nonce: iv,
    );

    final List<int> result =
        salt + secretBox.nonce + secretBox.cipherText + secretBox.mac.bytes;

    return hex.encode(result);
  }

  /// Decrypts passed [ciphertext] with key generated based on [password] argument
  static Future<String> decrypt(String cipherText, String password) async {
    final cText = hex.decode(cipherText);
    final salt = cText.sublist(0, _saltLength);
    final iv = cText.sublist(_saltLength, _saltLength + _ivLength);
    final mac = cText.sublist(cText.length - _tagLength);
    final text =
        cText.sublist(_saltLength + _ivLength, cText.length - _tagLength);

    final algorithm = AesGcm.with256bits();
    final key = await deriveKey(password, salt);

    final secretBox = SecretBox(text, nonce: iv, mac: Mac(mac));

    final cleartext = await algorithm.decrypt(
      secretBox,
      secretKey: key,
    );

    return utf8.decode(cleartext);
  }

  /// Password Based Key Deriviation function
  static Future<SecretKey> deriveKey(String password, List<int> salt) async {
    final pbkdf2 = Pbkdf2(
      macAlgorithm: Hmac.sha512(),
      iterations: _keyIterationsCount,
      bits: _keyLength * 8,
    );

    final SecretKey secret = await pbkdf2.deriveKey(
      secretKey: SecretKey(utf8.encode(password)),
      nonce: salt,
    );

    return secret;
  }

  /// Generates a random byte sequence of given [length]
  static Uint8List randomBytes(int length) {
    final Uint8List buffer = Uint8List(length);
    final Random range = Random.secure();

    for (int i = 0; i < length; i++) {
      buffer[i] = range.nextInt(256);
    }

    return buffer;
  }
}
