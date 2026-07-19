import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/modules_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../models/module.dart';
import '../../../models/progress.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../shell/mobile_shell.dart';
import 'lesson_page.dart';

class ModuleDetailPage extends StatefulWidget {
  final int moduleId;

  const ModuleDetailPage({super.key, required this.moduleId});

  @override
  State<ModuleDetailPage> createState() => _ModuleDetailPageState();
}

class _ModuleDetailPageState extends State<ModuleDetailPage> {
  Module? _module;
  ModuleProgress? _moduleProgress;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadModule();
  }

  void _showCompleteAnimation(BuildContext context, String lessonTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _LessonCompleteDialog(lessonTitle: lessonTitle),
    );
  }

  Future<void> _loadModule({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _error = null;
      });
    }
    try {
      final modulesService = context.read<ModulesService>();
      final progressService = context.read<ProgressService>();
      final results = await Future.wait([
        modulesService.getModule(widget.moduleId),
        progressService.getProgress(),
      ]);
      if (!mounted) return;
      final module = results[0] as Module;
      final progressList = (results[1] as Progress).modules;
      setState(() {
        _module = module;
        _moduleProgress = progressList.firstWhere(
          (m) => m.moduleId == widget.moduleId,
          orElse: () => ModuleProgress(
            moduleId: widget.moduleId,
            moduleName: module.title,
            completed: 0,
            total: module.lessons?.length ?? 0,
            pct: 0,
            completedModule: false,
          ),
        );
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar el módulo';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const SkeletonLoading();
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(message: _error!, onRetry: _loadModule),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadModule,
      child: CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 200,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(_module!.colorValue).withAlpha(40),
                    AppColors.lightBackground,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, kToolbarHeight + 24, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_module!.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_module!.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _InfoChip(
                        label: _module!.difficulty,
                        color: Color(_module!.colorValue),
                        icon: Icons.signal_cellular_alt_rounded,
                      ),
                      _InfoChip(
                        label: '${_moduleProgress?.total ?? 0} lecciones',
                        color: AppColors.textSecondary,
                        icon: Icons.menu_book_rounded,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_moduleProgress != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: _ProgressHeader(progress: _moduleProgress!),
            ),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final lesson = _module!.lessons![index];
              final isCompleted = index < (_moduleProgress?.completed ?? 0);
              return _LessonTile(
                lesson: lesson,
                index: index + 1,
                isCompleted: isCompleted,
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonPage(
                        lesson: lesson,
                        moduleTitle: _module!.title,
                        moduleAccent: _module!.accent,
                        isCompleted: isCompleted,
                        onMarkComplete: () async {
                          final progressService = context.read<ProgressService>();
                          final notifService = context.read<NotificationService>();
                          await progressService.completeLesson(_module!.id, lesson.id);
                          await notifService.lessonCompleted(25, lesson.title);
                          MobileShell.notifyDataChanged();
                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            _showCompleteAnimation(context, lesson.title);
                          }
                          await _loadModule(silent: true);
                        },
                      ),
                    ),
                  );
                },
              );
            },
            childCount: _module?.lessons?.length ?? 0,
          ),
        ),
        SliverToBoxAdapter(child: const SizedBox(height: 24)),
      ],
    ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _InfoChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(
            fontSize: 12, fontWeight: FontWeight.w600, color: color,
          )),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final ModuleProgress progress;

  const _ProgressHeader({required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pct = progress.pct;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progreso', style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            )),
            Text('$pct% · ${progress.completed}/${progress.total}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary, fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: pct / 100, minHeight: 8,
            backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
            valueColor: AlwaysStoppedAnimation<Color>(progress.completedModule
                ? AppColors.green : AppColors.green),
          ),
        ),
      ],
    );
  }
}

class _LessonTile extends StatelessWidget {
  final dynamic lesson;
  final int index;
  final bool isCompleted;
  final VoidCallback onTap;

  const _LessonTile({
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? AppColors.green
                        : (isDark ? Colors.white12 : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCompleted ? Icons.check_rounded : Icons.play_arrow_rounded,
                    color: isCompleted ? Colors.white : (isDark ? Colors.white54 : AppColors.textSecondary),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lección $index',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(lesson.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isCompleted
                              ? AppColors.green
                              : (isDark ? Colors.white : AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(lesson.duration,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LessonCompleteDialog extends StatefulWidget {
  final String lessonTitle;
  const _LessonCompleteDialog({required this.lessonTitle});

  @override
  State<_LessonCompleteDialog> createState() => _LessonCompleteDialogState();
}

class _LessonCompleteDialogState extends State<_LessonCompleteDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ScaleTransition(
      scale: _scaleAnim,
      child: FadeTransition(
        opacity: _opacityAnim,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppColors.green.withAlpha(26),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.green, size: 36),
              ),
              const SizedBox(height: 16),
              Text('¡Lección completada!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(widget.lessonTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white60 : AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.yellow.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.yellow),
                    const SizedBox(width: 4),
                    const Text('+25 XP', style: TextStyle(color: AppColors.yellow, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}