import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localStorageProvider = Provider((ref) => LocalStorage());

/// A wrapper around [SharedPreferences] to make it easier to use.
class LocalStorage {
  late final SharedPreferences storage;

  LocalStorage();

  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
  }

  Future<String?> getString(String key) async {
    return storage.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await storage.setString(key, value);
  }

  Future<bool?> getBool(String key) async {
    return storage.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await storage.setBool(key, value);
  }

  Future<int?> getInt(String key) async {
    return storage.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await storage.setInt(key, value);
  }

  Future<double?> getDouble(String key) async {
    return storage.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await storage.setDouble(key, value);
  }

  Future<Set<String>> getKeys() async {
    return storage.getKeys();
  }

  bool exists(String key) {
    return storage.containsKey(key);
  }

  Future<bool> delete(String key) async {
    return await storage.remove(key);
  }

  Future<bool> clear() async {
    return await storage.clear();
  }
}
