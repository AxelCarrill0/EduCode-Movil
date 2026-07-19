class AuthUser {
  final String id;
  final String name;
  final String email;
  final String? bio;
  final int xp;
  final int lessonsCompleted;
  final int modulesCompleted;
  final int? streak;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.bio,
    required this.xp,
    required this.lessonsCompleted,
    required this.modulesCompleted,
    this.streak,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final userMetadata = json['user_metadata'] as Map<String, dynamic>? ?? {};
    final now = DateTime.now();

    return AuthUser(
      id: json['id'] as String,
      name: (userMetadata['name'] as String?) ?? (json['name'] as String?) ?? 'Usuario',
      email: json['email'] as String,
      bio: json['bio'] as String?,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      lessonsCompleted: (json['lessons_completed'] as num?)?.toInt() ?? 0,
      modulesCompleted: (json['modules_completed'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt(),
      emailVerifiedAt: json['email_confirmed_at'] != null
          ? DateTime.parse(json['email_confirmed_at'] as String)
          : (json['email_verified_at'] != null
              ? DateTime.parse(json['email_verified_at'] as String)
              : null),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : now,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : now,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'xp': xp,
      'lessons_completed': lessonsCompleted,
      'modules_completed': modulesCompleted,
      'streak': streak,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  AuthUser copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    int? xp,
    int? lessonsCompleted,
    int? modulesCompleted,
    int? streak,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      xp: xp ?? this.xp,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      modulesCompleted: modulesCompleted ?? this.modulesCompleted,
      streak: streak ?? this.streak,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}