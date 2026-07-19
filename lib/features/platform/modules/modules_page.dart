import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/modules_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../models/module.dart';
import '../../../models/progress.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../shell/mobile_shell.dart';
import 'module_detail_page.dart';

class ModulesPage extends StatefulWidget {
  const ModulesPage({super.key});

  @override
  State<ModulesPage> createState() => _ModulesPageState();
}

class _ModulesPageState extends State<ModulesPage> {
  List<Module> _modules = [];
  Progress? _progress;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
    MobileShell.refreshNotifier.addListener(_silentRefresh);
  }

  @override
  void dispose() {
    MobileShell.refreshNotifier.removeListener(_silentRefresh);
    super.dispose();
  }

  Future<void> _silentRefresh() async {
    try {
      final results = await Future.wait([
        context.read<ModulesService>().getModules(),
        context.read<ProgressService>().getProgress(),
      ]);
      if (!mounted) return;
      setState(() {
        _modules = results[0] as List<Module>;
        _progress = results[1] as Progress;
      });
    } catch (_) {}
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final modulesService = context.read<ModulesService>();
      final progressService = context.read<ProgressService>();
      final results = await Future.wait([
        modulesService.getModules(),
        progressService.getProgress(),
      ]);
      if (!mounted) return;
      setState(() {
        _modules = results[0] as List<Module>;
        _progress = results[1] as Progress;
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudieron cargar los módulos';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulos')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const SkeletonLoading();
    if (_error != null) return ErrorView(message: _error!, onRetry: _loadData);
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.pageHorizontalPadding, 8,
          AppConstants.pageHorizontalPadding, 24,
        ),
        itemCount: _modules.length,
        itemBuilder: (context, index) {
          final module = _modules[index];
          final mp = _progress?.modules.firstWhere(
            (m) => m.moduleId == module.id,
            orElse: () => ModuleProgress(
              moduleId: module.id,
              moduleName: module.title,
              completed: 0,
              total: 0,
              pct: 0,
              completedModule: false,
            ),
          );
          return _ModuleCard(
            module: module,
            progress: mp ?? ModuleProgress(
              moduleId: module.id,
              moduleName: module.title,
              completed: 0,
              total: 0,
              pct: 0,
              completedModule: false,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ModuleDetailPage(moduleId: module.id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final Module module;
  final ModuleProgress progress;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.module,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = Color(module.colorValue);
    final pct = progress.pct;
    final icons = const [
      Icons.code_rounded, Icons.data_object_rounded, Icons.table_chart_rounded,
      Icons.calculate_rounded, Icons.account_tree_rounded, Icons.loop_rounded,
    ];
    final icon = module.id > 0 && module.id <= icons.length
        ? icons[module.id - 1]
        : Icons.code_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border(
                left: BorderSide(color: color, width: 4),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withAlpha(26),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(module.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text('${module.difficulty} · ${progress.completed}/${progress.total} lecciones',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isDark ? Colors.white60 : AppColors.textSecondary,
                        ),
                      ),
                      if (pct > 0) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: pct / 100,
                            minHeight: 6,
                            backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(color),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded,
                    color: isDark ? Colors.white38 : AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}