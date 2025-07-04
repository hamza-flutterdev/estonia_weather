import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static Future<String?> getString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      debugPrint('Error reading string from storage: $e');
      return null;
    }
  }

  static Future<void> setString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      debugPrint('Error writing string to storage: $e');
    }
  }

  static Future<int?> getInt(String key) async {
    try {
      final String? value = await _secureStorage.read(key: key);
      return value != null ? int.tryParse(value) : null;
    } catch (e) {
      debugPrint('Error reading int from storage: $e');
      return null;
    }
  }

  static Future<void> setInt(String key, int value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
    } catch (e) {
      debugPrint('Error writing int to storage: $e');
    }
  }

  static Future<bool?> getBool(String key) async {
    try {
      final String? value = await _secureStorage.read(key: key);
      return value != null ? value.toLowerCase() == 'true' : null;
    } catch (e) {
      debugPrint('Error reading bool from storage: $e');
      return null;
    }
  }

  static Future<void> setBool(String key, bool value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
    } catch (e) {
      debugPrint('Error writing bool to storage: $e');
    }
  }

  static Future<double?> getDouble(String key) async {
    try {
      final String? value = await _secureStorage.read(key: key);
      return value != null ? double.tryParse(value) : null;
    } catch (e) {
      debugPrint('Error reading double from storage: $e');
      return null;
    }
  }

  static Future<void> setDouble(String key, double value) async {
    try {
      await _secureStorage.write(key: key, value: value.toString());
    } catch (e) {
      debugPrint('Error writing double to storage: $e');
    }
  }

  static Future<void> remove(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      debugPrint('Error removing key from storage: $e');
    }
  }

  static Future<void> clear() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      debugPrint('Error clearing storage: $e');
    }
  }

  static Future<bool> containsKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      debugPrint('Error checking key existence: $e');
      return false;
    }
  }

  static Future<Map<String, String>> getAll() async {
    try {
      return await _secureStorage.readAll();
    } catch (e) {
      debugPrint('Error reading all from storage: $e');
      return {};
    }
  }

  // Specific methods for your app's data
  static Future<String?> getSelectedCities() async {
    return await getString('selected_cities');
  }

  static Future<void> setSelectedCities(String citiesJson) async {
    await setString('selected_cities', citiesJson);
  }

  static Future<int?> getMainCityIndex() async {
    return await getInt('main_city_index');
  }

  static Future<void> setMainCityIndex(int index) async {
    await setInt('main_city_index', index);
  }

  // Add more app-specific methods as needed
  static Future<String?> getUserPreferences() async {
    return await getString('user_preferences');
  }

  static Future<void> setUserPreferences(String preferencesJson) async {
    await setString('user_preferences', preferencesJson);
  }
}
