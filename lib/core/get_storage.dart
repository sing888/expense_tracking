import 'package:get_storage/get_storage.dart';

class TokenService {
  static final _storage = GetStorage();

  static String? getToken() => _storage.read('token');
  static String? getRefreshToken() => _storage.read('refreshToken');
  static void saveToken(String token) => _storage.write('token', token);
  static void saveRefreshToken(String refreshToken) => _storage.write('refreshToken', refreshToken);
  static void clearToken() {
    _storage.remove('token');
    _storage.remove('refreshToken');
  }
}
