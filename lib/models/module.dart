import 'lesson.dart';

class Module {
  final int id;
  final String title;
  final String description;
  final String accent;
  final String difficulty;
  final int sortOrder;
  final List<Lesson>? lessons;

  const Module({
    required this.id,
    required this.title,
    required this.description,
    required this.accent,
    required this.difficulty,
    required this.sortOrder,
    this.lessons,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    final lessonsList = json['lessons'] as List<dynamic>?;
    return Module(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      accent: json['accent'] as String? ?? '#10B981',
      difficulty: json['difficulty'] as String? ?? 'Principiante',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      lessons: lessonsList
          ?.map((l) => Lesson.fromJson(l as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'accent': accent,
      'difficulty': difficulty,
      'sort_order': sortOrder,
    };
  }

  int get colorValue {
    final hex = accent.replaceAll('#', '');
    if (hex.length == 6) {
      return int.parse('FF$hex', radix: 16);
    } else if (hex.length == 8) {
      return int.parse(hex, radix: 16);
    }
    return 0xFF10B981;
  }

  int get lessonCount => lessons?.length ?? 0;

  Module copyWith({
    int? id,
    String? title,
    String? description,
    String? accent,
    String? difficulty,
    int? sortOrder,
    List<Lesson>? lessons,
  }) {
    return Module(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      accent: accent ?? this.accent,
      difficulty: difficulty ?? this.difficulty,
      sortOrder: sortOrder ?? this.sortOrder,
      lessons: lessons ?? this.lessons,
    );
  }
}