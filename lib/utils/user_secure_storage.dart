import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flarelane_flutter/flarelane_flutter.dart';

class UserSecureStorage {
  static final _storage = FlutterSecureStorage();

  static Future setUserId(String userId) async {
    await _storage.write(key: 'userId', value: userId);
    FlareLane.shared.setUserId(userId);
  }
  static Future setJwt(String jwt) async =>
      await _storage.write(key: 'jwt', value: jwt);
  static Future setEarly(String earlyToken) async =>
      await _storage.write(key: 'earlyToken', value: earlyToken);

  static Future<String?> getUserId() async =>
    await _storage.read(key: 'userId');
  static Future<String?> getJwt() async =>
      await _storage.read(key: 'jwt');
  static Future<String?> getEarly() async =>
      await _storage.read(key: 'earlyToken');

  static Future<void> logout() async {
    await _storage.deleteAll();
    FlareLane.shared.setUserId(null);
  }
}
