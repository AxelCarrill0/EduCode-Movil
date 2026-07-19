class Progress {
  final List<ModuleProgress> modules;
  final ProgressStats stats;

  const Progress({
    required this.modules,
    required this.stats,
  });

  factory Progress.fromJson(Map<String, dynamic> json) {
    final modulesList = json['modules'] as List<dynamic>? ?? [];
    return Progress(
      modules: modulesList
          .map((m) => ModuleProgress.fromJson(m as Map<String, dynamic>))
          .toList(),
      stats: ProgressStats.fromJson(json['stats'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'modules': modules.map((m) => m.toJson()).toList(),
      'stats': stats.toJson(),
    };
  }
}

class ModuleProgress {
  final int moduleId;
  final String moduleName;
  final int completed;
  final int total;
  final int pct;
  final bool completedModule;

  const ModuleProgress({
    required this.moduleId,
    required this.moduleName,
    required this.completed,
    required this.total,
    required this.pct,
    required this.completedModule,
  });

  factory ModuleProgress.fromJson(Map<String, dynamic> json) {
    return ModuleProgress(
      moduleId: (json['moduleId'] as num?)?.toInt() ?? 0,
      moduleName: json['moduleName'] as String? ?? '',
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      pct: (json['pct'] as num?)?.toInt() ?? 0,
      completedModule: json['completedModule'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleId': moduleId,
      'moduleName': moduleName,
      'completed': completed,
      'total': total,
      'pct': pct,
      'completedModule': completedModule,
    };
  }

  bool get isInProgress => completed > 0 && !completedModule;
  bool get isNotStarted => completed == 0;
}

class ProgressStats {
  final int xp;
  final int streak;
  final int completedLessons;
  final int totalLessons;
  final int modulesCompleted;
  final int totalModules;
  final int inProgressLessons;
  final int pendingLessons;

  const ProgressStats({
    required this.xp,
    required this.streak,
    required this.completedLessons,
    required this.totalLessons,
    required this.modulesCompleted,
    required this.totalModules,
    required this.inProgressLessons,
    required this.pendingLessons,
  });

  factory ProgressStats.fromJson(Map<String, dynamic> json) {
    return ProgressStats(
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      completedLessons: (json['completedLessons'] as num?)?.toInt() ?? 0,
      totalLessons: (json['totalLessons'] as num?)?.toInt() ?? 0,
      modulesCompleted: (json['modulesCompleted'] as num?)?.toInt() ?? 0,
      totalModules: (json['totalModules'] as num?)?.toInt() ?? 0,
      inProgressLessons: (json['inProgressLessons'] as num?)?.toInt() ?? 0,
      pendingLessons: (json['pendingLessons'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'xp': xp,
      'streak': streak,
      'completedLessons': completedLessons,
      'totalLessons': totalLessons,
      'modulesCompleted': modulesCompleted,
      'totalModules': totalModules,
      'inProgressLessons': inProgressLessons,
      'pendingLessons': pendingLessons,
    };
  }

  double get overallPct {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons) * 100;
  }
}