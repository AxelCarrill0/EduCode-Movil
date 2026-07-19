import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:educode_mobile/core/storage/storage_service.dart';
import 'package:educode_mobile/models/app_notification.dart';
import 'package:educode_mobile/core/constants/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  final StorageService _storage;
  List<AppNotification> _notifications = [];
  bool _notificationsEnabled = true;

  NotificationService({required this._storage});

  List<AppNotification> get notifications => List.unmodifiable(_notifications);
  List<AppNotification> get unread => _notifications.where((n) => !n.read).toList();
  int get unreadCount => unread.length;
  bool get enabled => _notificationsEnabled;

  Future<void> load() async {
    _notificationsEnabled = await _storage.getBool('notifications_enabled');
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('local_notifications');
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _notifications = list
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_notifications.map((n) => n.toJson()).toList());
    await prefs.setString('local_notifications', raw);
  }

  Future<void> setEnabled(bool value) async {
    _notificationsEnabled = value;
    await _storage.setBool('notifications_enabled', value);
    notifyListeners();
  }

  Future<bool> getEnabled() async {
    _notificationsEnabled = await _storage.getBool('notifications_enabled');
    return _notificationsEnabled;
  }

  Future<void> add({
    required String title,
    required String message,
    IconData? icon,
    Color? color,
  }) async {
    if (!_notificationsEnabled) return;
    final notif = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      icon: icon ?? Icons.notifications_rounded,
      color: color ?? AppColors.green,
      createdAt: DateTime.now(),
    );
    _notifications.insert(0, notif);
    if (_notifications.length > 50) _notifications = _notifications.sublist(0, 50);
    await _save();
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notifications[index] = _notifications[index].copyWith(read: true);
      await _save();
      notifyListeners();
    }
  }

  Future<void> markAllAsRead() async {
    _notifications = _notifications.map((n) => n.copyWith(read: true)).toList();
    await _save();
    notifyListeners();
  }

  // Notification generators
  Future<void> lessonCompleted(int xp, String lessonTitle) async {
    await add(
      title: 'Lección completada',
      message: 'Has completado "$lessonTitle" y ganaste $xp XP',
      icon: Icons.check_circle_rounded,
      color: AppColors.green,
    );
  }

  Future<void> moduleCompleted(String moduleName) async {
    await add(
      title: 'Módulo completado',
      message: '¡Felicidades! Completaste el módulo "$moduleName"',
      icon: Icons.emoji_events_rounded,
      color: AppColors.yellow,
    );
  }

  Future<void> streakMilestone(int streak) async {
    if (streak > 0 && streak % 3 == 0) {
      await add(
        title: 'Racha de $streak días',
        message: '¡Llevas $streak días seguidos aprendiendo! Sigue así.',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.red,
      );
    }
  }
}