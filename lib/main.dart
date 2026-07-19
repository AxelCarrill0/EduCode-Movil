import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/config/app_config.dart';
import 'core/network/api_client.dart';
import 'core/services/auth_service.dart';
import 'core/services/laboratory_service.dart';
import 'core/services/modules_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/progress_service.dart';
import 'core/services/settings_service.dart';
import 'core/storage/storage_service.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = await StorageService.create();
  final apiClient = ApiClient(baseUrl: AppConfig.productionApiBaseUrl, storage: storage);
  final authService = AuthService(api: apiClient, storage: storage);
  final modulesService = ModulesService(api: apiClient);
  final progressService = ProgressService(api: apiClient);
  final laboratoryService = LaboratoryService(api: apiClient);
  final notificationService = NotificationService(storage: storage);
  await notificationService.load();
  final themeNotifier = ThemeNotifier()..init(await storage.getDarkMode());
  final settingsService = SettingsService(storage: storage);

  setUnauthorizedHandler(() => authService.logout());

  runApp(
    MultiProvider(
      providers: [
        Provider<StorageService>.value(value: storage),
        Provider<ApiClient>.value(value: apiClient),
        Provider<AuthService>.value(value: authService),
        Provider<ModulesService>.value(value: modulesService),
        Provider<ProgressService>.value(value: progressService),
        Provider<LaboratoryService>.value(value: laboratoryService),
        ChangeNotifierProvider<NotificationService>.value(value: notificationService),
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
        Provider<SettingsService>.value(value: settingsService),
      ],
      child: const EduCodeApp(),
    ),
  );
}