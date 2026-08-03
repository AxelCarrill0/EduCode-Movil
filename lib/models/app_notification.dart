import 'package:flutter/material.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final DateTime createdAt;
  final bool read;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.createdAt,
    this.read = false,
  });

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      icon: icon,
      color: color,
      createdAt: createdAt,
      read: read ?? this.read,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'message': message,
    'icon': icon.codePoint,
    'iconFontFamily': icon.fontFamily,
    'color': color.toARGB32(),
    'createdAt': createdAt.toIso8601String(),
    'read': read,
  };

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final iconCodePoint = json['icon'] as int? ?? 0xE8AD;
    final iconFontFamily = json['iconFontFamily'] as String?;
    return AppNotification(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      icon: IconData(iconCodePoint, fontFamily: iconFontFamily),
      color: Color(json['color'] as int),
      createdAt: DateTime.parse(json['createdAt'] as String),
      read: json['read'] as bool? ?? false,
    );
  }
}