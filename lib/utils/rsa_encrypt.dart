import 'dart:convert';
import 'package:encrypt/encrypt.dart';

/// RSA 公钥（与 web 前端保持一致）
const String _rsaPublicKey = '''-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEArq9XTUSeYr2+N1h3Afl/z8Dse/2yD0ZGrKwx+EEEcdsBLca9Ynmx3nIB5obmLlSfmskLpBo0UACBmB5rEjBp2Q2f3AG3Hjd4B+gNCG6BDaawuDlgANIhGnaTLrIqWrrcm4EMzJOnAOI1fgzJRsOOUEfaS318Eq9OVO3apEyCCt0lOQK6PuksduOjVxtltDav+guVAA068NrPYmRNabVKRNLJpL8w4D44sfth5RvZ3q9t+6RTArpEtc5sh5ChzvqPOzKGMXW83C95TxmXqpbK6olN4RevSfVjEAgCydH6HN6OhtOQEcnrU97r9H0iZOWwbw3pVrZiUkuRD1R56Wzs2wIDAQAB
-----END PUBLIC KEY-----''';

/// 使用 RSA 公钥加密密码
/// 流程：先 Base64 编码密码，然后使用 RSA 公钥加密
/// 与 web 前端的 rsaPsw 函数保持一致
String rsaEncryptPassword(String password) {
  try {
    // 1. 先对密码进行 Base64 编码
    final base64Encoded = base64Encode(utf8.encode(password));
    
    // 2. 创建 RSA 公钥对象
    final parser = RSAKeyParser();
    final key = parser.parse(_rsaPublicKey);
    
    // 3. 创建加密器
    // 由于类型系统的限制，使用 dynamic 来绕过类型检查
    // RSA 构造函数实际上可以接受 RSAAsymmetricKey 类型
    final rsa = RSA(publicKey: key as dynamic);
    final encrypter = Encrypter(rsa);
    
    // 4. 加密 Base64 编码后的密码
    final encrypted = encrypter.encrypt(base64Encoded);
    
    // 5. 返回 Base64 编码的加密结果
    return encrypted.base64;
  } catch (e) {
    // 如果加密失败，抛出异常
    throw Exception('密码加密失败: $e');
  }
}
