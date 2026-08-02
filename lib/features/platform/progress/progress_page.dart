import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/progress_service.dart';
import '../../../models/progress.dart';
import '../../../models/achievement.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../../shared/widgets/traffic_light_progress_bar.dart';
import '../../shell/mobile_shell.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  Progress? _progress;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProgress();
    MobileShell.refreshNotifier.addListener(_silentRefresh);
  }

  @override
  void dispose() {
    MobileShell.refreshNotifier.removeListener(_silentRefresh);
    super.dispose();
  }

  Future<void> _silentRefresh() async {
    try {
      final progress = await context.read<ProgressService>().getProgress();
      if (mounted) setState(() => _progress = progress);
    } catch (_) {}
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final service = context.read<ProgressService>();
      final progress = await service.getProgress();
      if (mounted) {
        setState(() {
          _progress = progress;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar el progreso';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Progreso')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const SkeletonLoading();
    if (_error != null) return ErrorView(message: _error!, onRetry: _loadProgress);
    return RefreshIndicator(
      onRefresh: _loadProgress,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.pageHorizontalPadding, 8,
          AppConstants.pageHorizontalPadding, 24,
        ),
        children: [
          _StatsSection(stats: _progress!.stats),
          const SizedBox(height: 24),
          _ProgressByModule(modules: _progress!.modules),
          const SizedBox(height: 24),
          _AchievementsSection(stats: _progress!.stats),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final ProgressStats stats;

  const _StatsSection({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Resumen general',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.xp}',
                    label: 'XP',
                    icon: Icons.auto_awesome_rounded,
                    color: AppColors.yellow,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.completedLessons}',
                    label: 'Lecciones completadas',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.green,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.modulesCompleted}/${stats.totalModules}',
                    label: 'Módulos completados',
                    icon: Icons.school_rounded,
                    color: AppColors.blue,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.streak}',
                    label: 'Racha (días)',
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.red,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.pendingLessons}',
                    label: 'Pendientes',
                    icon: Icons.pending_rounded,
                    color: AppColors.cyan,
                  ),
                ),
                SizedBox(
                  width: cardWidth,
                  child: _StatCard(
                    value: '${stats.inProgressLessons}',
                    label: 'En progreso',
                    icon: Icons.trending_up_rounded,
                    color: AppColors.purple,
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        _OverallProgressBar(stats: stats),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : const Color(0x0A000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 2),
          Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverallProgressBar extends StatelessWidget {
  final ProgressStats stats;

  const _OverallProgressBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = stats.overallPct;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : const Color(0x0A000000),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progreso general',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              Text('${pct.toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: TrafficLightProgressBar(
              value: pct / 100,
              minHeight: 10,
              backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            ),
          ),
          const SizedBox(height: 6),
          Text('${stats.completedLessons} de ${stats.totalLessons} lecciones',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressByModule extends StatelessWidget {
  final List<ModuleProgress> modules;

  const _ProgressByModule({required this.modules});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moduleColors = [
      AppColors.green, AppColors.blue, AppColors.purple,
      AppColors.yellow, AppColors.red, AppColors.cyan,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Avance por módulo',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
        ...modules.asMap().entries.map((entry) {
          final index = entry.key;
          final mp = entry.value;
          final color = moduleColors[index % moduleColors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withAlpha(40) : const Color(0x0A000000),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color.withAlpha(26),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text('${index + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: color,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(mp.moduleName,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : AppColors.textDark,
                              ),
                            ),
                            Text('${mp.completed}/${mp.total} · ${mp.pct}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isDark ? Colors.white60 : AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (mp.completedModule)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.green.withAlpha(26),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Completado',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
if (mp.pct > 0) ...[
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: TrafficLightProgressBar(
                          value: mp.pct / 100,
                          minHeight: 6,
                          backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ],
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  final ProgressStats stats;

  const _AchievementsSection({required this.stats});

  List<Achievement> _getAchievements() {
    return [
      Achievement(
        id: 'first_lesson',
        title: 'Primer paso',
        description: 'Completa tu primera lección',
        icon: Icons.touch_app_rounded,
        color: AppColors.green,
        unlocked: stats.completedLessons >= 1,
      ),
      Achievement(
        id: 'dedicated',
        title: 'Estudiante dedicado',
        description: 'Completa 10 lecciones',
        icon: Icons.menu_book_rounded,
        color: AppColors.blue,
        unlocked: stats.completedLessons >= 10,
      ),
      Achievement(
        id: 'first_module',
        title: 'Primer módulo',
        description: 'Completa un módulo completo',
        icon: Icons.school_rounded,
        color: AppColors.purple,
        unlocked: stats.modulesCompleted >= 1,
      ),
      Achievement(
        id: 'half_way',
        title: 'Mitad del camino',
        description: 'Completa el 50% del curso',
        icon: Icons.directions_run_rounded,
        color: AppColors.yellow,
        unlocked: stats.overallPct >= 50,
      ),
      Achievement(
        id: 'master',
        title: 'Maestro Python',
        description: 'Completa todos los módulos',
        icon: Icons.emoji_events_rounded,
        color: AppColors.red,
        unlocked: stats.modulesCompleted >= stats.totalModules && stats.totalModules > 0,
      ),
      Achievement(
        id: 'streak_3',
        title: 'Racha de 3 días',
        description: 'Mantén una racha de 3 días',
        icon: Icons.local_fire_department_rounded,
        color: AppColors.cyan,
        unlocked: stats.streak >= 3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final achievements = _getAchievements();
    final unlocked = achievements.where((a) => a.unlocked).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Logros',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            Text('$unlocked/${achievements.length}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...achievements.map((a) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: a.unlocked ? [
                BoxShadow(
                  color: a.color.withAlpha(20),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: a.unlocked
                        ? a.color.withAlpha(26)
                        : (isDark ? Colors.white10 : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    a.icon,
                    color: a.unlocked ? a.color : (isDark ? Colors.white30 : AppColors.textSecondary),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(a.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: a.unlocked
                              ? (isDark ? Colors.white : AppColors.textDark)
                              : (isDark ? Colors.white30 : AppColors.textSecondary),
                        ),
                      ),
                      Text(a.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: a.unlocked
                              ? AppColors.textSecondary
                              : (isDark ? Colors.white.withAlpha(51) : AppColors.textSecondary.withAlpha(150)),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  a.unlocked ? Icons.check_circle_rounded : Icons.lock_rounded,
                  color: a.unlocked ? a.color : (isDark ? Colors.white.withAlpha(51) : AppColors.textSecondary.withAlpha(120)),
                  size: 22,
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}