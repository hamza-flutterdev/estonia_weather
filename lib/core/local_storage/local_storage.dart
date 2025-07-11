import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  Future<String?> getString(String key) async {
    return await _secureStorage.read(key: key);
  }

  Future<void> setString(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
}
