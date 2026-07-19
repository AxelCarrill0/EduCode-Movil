import 'content_block.dart';

class Lesson {
  final int id;
  final String title;
  final List<ContentBlock> content;
  final String duration;
  final int sortOrder;
  final bool completed;

  const Lesson({
    required this.id,
    required this.title,
    required this.content,
    required this.duration,
    required this.sortOrder,
    this.completed = false,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final contentList = json['content'] as List<dynamic>? ?? [];
    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      content: contentList
          .map((c) => ContentBlock.fromJson(c as Map<String, dynamic>))
          .toList(),
      duration: json['duration'] as String? ?? '0 min',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content.map((c) => c.toJson()).toList(),
      'duration': duration,
      'sort_order': sortOrder,
      'completed': completed,
    };
  }

  Lesson copyWith({
    int? id,
    String? title,
    List<ContentBlock>? content,
    String? duration,
    int? sortOrder,
    bool? completed,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      duration: duration ?? this.duration,
      sortOrder: sortOrder ?? this.sortOrder,
      completed: completed ?? this.completed,
    );
  }
}