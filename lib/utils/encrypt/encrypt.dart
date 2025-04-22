import 'package:waterbus_sdk/flutter_waterbus_sdk.dart';
import 'package:waterbus_sdk/utils/encrypt/aes_256_gcm.dart';

class EncryptAES {
  Future<String> encryptAES256({required String cleartext, String? key}) async {
    try {
      final String keyword = key ?? WaterbusSdk.messageEncryptionKey;

      if (keyword.isEmpty) return cleartext;
      final String message = await Aes256Gcm.encrypt(cleartext, keyword);

      return message;
    } catch (e) {
      return cleartext;
    }
  }

  Future<String> decryptAES256({
    required String cipherText,
    String? key,
  }) async {
    try {
      final String keyword = key ?? WaterbusSdk.messageEncryptionKey;

      if (keyword.isEmpty) return cipherText;

      final String message = await Aes256Gcm.decrypt(cipherText, keyword);

      return message;
    } catch (e) {
      return cipherText;
    }
  }
}
