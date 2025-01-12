import 'package:cryptology/cryptology.dart';

class EncryptData {
  final passwordEncryption = PasswordEncryption.initial(difficulty: HashDifficulty.strong);

  Future<String> encryptPassword(String plainText) async {
    final hashedPwd = await passwordEncryption.hashB64(plainText);
    return hashedPwd;
  }

  Future<bool> verifyPassword(String plainText, String hashedPwd) async {
    final isVerified = await passwordEncryption.verifyB64(plainText, hashedPwd);
    return isVerified;
  }
}
