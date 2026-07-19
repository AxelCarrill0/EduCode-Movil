import 'package:educode_mobile/core/storage/storage_service.dart';

class SettingsService {
  final StorageService _storage;

  SettingsService({required this._storage});

  Future<bool> getDarkMode() => _storage.getDarkMode();
  Future<void> setDarkMode(bool isDark) => _storage.setDarkMode(isDark);

  Future<bool> getNotifications() async {
    return _storage.getBool('notifications_enabled');
  }

  Future<void> setNotifications(bool enabled) async {
    await _storage.setBool('notifications_enabled', enabled);
  }
}