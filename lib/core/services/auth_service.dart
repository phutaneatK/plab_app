import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // บันทึก token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // อ่าน token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // ลบ token (logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  // ตรวจสอบว่ามี token หรือไม่
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // ตรวจสอบว่า token ถูกต้องหรือไม่
  Future<bool> isValidToken() async {
    final token = await getToken();
    // ตรวจสอบว่า token = "admin:1234" หรือไม่
    return token == 'admin:1234';
  }
}
