import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/modules_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/progress_service.dart';
import '../../../models/app_notification.dart';
import '../../../models/auth_user.dart';
import '../../../models/module.dart';
import '../../../models/progress.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/traffic_light_progress_bar.dart';
import '../../../shared/widgets/skeleton_loading.dart';
import '../../shell/mobile_shell.dart';
import '../modules/module_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Progress? _progress;
  List<Module> _modules = [];
  AuthUser? _user;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
    MobileShell.refreshNotifier.addListener(_onRefreshNeeded);
  }

  @override
  void dispose() {
    MobileShell.refreshNotifier.removeListener(_onRefreshNeeded);
    super.dispose();
  }

  void _onRefreshNeeded() {
    _silentRefresh();
  }

  Future<void> _silentRefresh() async {
    try {
      final results = await Future.wait([
        context.read<AuthService>().getMe(),
        context.read<ProgressService>().getProgress(),
        context.read<ModulesService>().getModules(),
      ]);
      if (mounted) {
        setState(() {
          _user = results[0] as AuthUser?;
          _progress = results[1] as Progress;
          _modules = results[2] as List<Module>;
        });
      }
    } catch (_) {}
  }

  Future<void> _loadData() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final results = await Future.wait([
        context.read<AuthService>().getMe(),
        context.read<ProgressService>().getProgress(),
        context.read<ModulesService>().getModules(),
      ]);
      if (mounted) {
        setState(() {
          _user = results[0] as AuthUser?;
          _progress = results[1] as Progress;
          _modules = results[2] as List<Module>;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() { _error = 'No se pudieron cargar los datos'; _isLoading = false; });
  }
}



  String _greeting() {
    if (_user == null) return 'Bienvenido';
    final hour = DateTime.now().hour;
    final name = _user!.name.split(' ').first;
    if (hour < 12) return 'Buenos días, $name';
    if (hour < 18) return 'Buenas tardes, $name';
    return 'Buenas noches, $name';
  }

  ModuleProgress? get _bestInProgress {
    final inProgress = _progress?.modules.where(
      (m) => !m.completedModule && m.pct > 0,
    ).toList() ?? [];
    if (inProgress.isEmpty) return null;
    inProgress.sort((a, b) => b.pct.compareTo(a.pct));
    return inProgress.first;
  }

  Module? _findModule(int id) {
    try { return _modules.firstWhere((m) => m.id == id); } catch (_) { return null; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_greeting()),
        actions: [
          Consumer<NotificationService>(
            builder: (context, notifService, _) {
              final unread = notifService.unreadCount;
              return Badge(
                isLabelVisible: unread > 0,
                label: Text('$unread', style: const TextStyle(fontSize: 10)),
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  tooltip: 'Notificaciones',
                  onPressed: () => _showNotifications(context),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar sesión',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return const SkeletonLoading(isDashboard: true);
    if (_error != null) return ErrorView(message: _error!, onRetry: _loadData);
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppConstants.pageHorizontalPadding, 8,
          AppConstants.pageHorizontalPadding, 24,
        ),
        children: [
          _buildWelcomeCard(),
          const SizedBox(height: 20),
          _buildQuickStats(),
          const SizedBox(height: 24),
          if (_bestInProgress != null) _buildContinueLearning(),
          if (_bestInProgress == null && _progress!.stats.completedLessons == 0)
            _buildStartPrompt(),
          if (_bestInProgress == null && _progress!.stats.completedLessons > 0)
            _buildModuleCompletedCard(),
          const SizedBox(height: 24),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stats = _progress!.stats;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.green.withAlpha(40), AppColors.green.withAlpha(10)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome_rounded, color: AppColors.green, size: 28),
          const SizedBox(height: 8),
          Text('¡Sigue aprendiendo Python!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text('Has completado ${stats.completedLessons} de ${stats.totalLessons} lecciones',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    final stats = _progress!.stats;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: _MiniStat(
            value: '${stats.xp}',
            label: 'XP',
            icon: Icons.auto_awesome_rounded,
            color: AppColors.yellow,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStat(
            value: '${stats.completedLessons}',
            label: 'Lecciones hechas',
            icon: Icons.check_circle_rounded,
            color: AppColors.green,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MiniStat(
            value: '${stats.streak}',
            label: 'Racha',
            icon: Icons.local_fire_department_rounded,
            color: AppColors.red,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueLearning() {
    final mp = _bestInProgress!;
    final module = _findModule(mp.moduleId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = module != null ? Color(module.colorValue) : AppColors.green;
    final icons = [Icons.code_rounded, Icons.data_object_rounded, Icons.table_chart_rounded,
      Icons.calculate_rounded, Icons.account_tree_rounded, Icons.loop_rounded];
    final icon = module != null && module.id <= icons.length ? icons[module.id - 1] : Icons.code_rounded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Continuar aprendiendo',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Material(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => _navigateToModule(mp.moduleId),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border(left: BorderSide(color: color, width: 4)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: color.withAlpha(26),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(mp.moduleName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: TrafficLightProgressBar(
                            value: mp.pct / 100,
                            minHeight: 6,
                            backgroundColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text('${mp.completed}/${mp.total} · $mp.pct%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary, fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, color: color),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartPrompt() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.green.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: AppColors.green, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Comienza tu primer módulo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text('Explora los módulos de aprendizaje y empieza con Python',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleCompletedCard() {
    final allDone = _progress!.modules.every((m) => m.completedModule);
    final completedModules = _progress!.modules.where((m) => m.completedModule).length;
    final totalModules = _progress!.modules.length;

    if (allDone) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.green.withAlpha(13),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.celebration_rounded, color: AppColors.green, size: 32),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¡Todos los módulos completados!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text('Sigue practicando en el laboratorio',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.blue.withAlpha(13),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppColors.blue, size: 32),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Completaste el módulo $completedModules de $totalModules',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text('Sigue con el siguiente módulo',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Acceso rápido',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _ActionButton(
              icon: Icons.school_rounded,
              label: 'Módulos',
              color: AppColors.blue,
              isDark: isDark,
              onTap: () => _switchTab(1),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ActionButton(
              icon: Icons.terminal_rounded,
              label: 'Laboratorio',
              color: AppColors.purple,
              isDark: isDark,
              onTap: () => _switchTab(2),
            )),
            const SizedBox(width: 12),
            Expanded(child: _ActionButton(
              icon: Icons.bar_chart_rounded,
              label: 'Progreso',
              color: AppColors.green,
              isDark: isDark,
              onTap: () => _switchTab(3),
            )),
          ],
        ),
      ],
    );
  }

  void _switchTab(int index) {
    MobileShell.switchToTab(index);
  }

  void _navigateToModule(int moduleId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModuleDetailPage(moduleId: moduleId),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => _NotificationSheet(),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); _logout(); },
            child: const Text('Cerrar sesión', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          margin: EdgeInsets.all(80),
          child: Padding(
            padding: EdgeInsets.all(32),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
    await context.read<AuthService>().logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final bool isDark;

  const _MiniStat({
    required this.value, required this.label, required this.icon,
    required this.color, required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
          Text(label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isDark ? Colors.white60 : AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon, required this.label, required this.color,
    required this.isDark, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.darkSurface : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border(top: BorderSide(color: color, width: 3)),
          ),
          child: Column(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<NotificationService>(
      builder: (context, notifService, _) {
        final notifications = notifService.notifications;
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) => Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 8),
                child: Row(
                  children: [
                    Icon(Icons.notifications_rounded,
                      size: 20,
                      color: isDark ? Colors.white70 : AppColors.textDark,
                    ),
                    const SizedBox(width: 8),
                    Text('Notificaciones',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const Spacer(),
                    if (notifService.unreadCount > 0)
                      TextButton(
                        onPressed: () => notifService.markAllAsRead(),
                        child: const Text('Marcar todo leído', style: TextStyle(fontSize: 12)),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (notifications.isEmpty)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_rounded,
                          size: 40,
                          color: isDark ? Colors.white12 : Colors.black12,
                        ),
                        const SizedBox(height: 8),
                        Text('Sin notificaciones',
                          style: TextStyle(
                            color: isDark ? Colors.white30 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final n = notifications[index];
                      return _NotificationItem(
                        notification: n,
                        isDark: isDark,
                        onTap: () {
                          if (!n.read) notifService.markAsRead(n.id);
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final AppNotification notification;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationItem({
    required this.notification,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = notification;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: !n.read
              ? (isDark ? Colors.white.withAlpha(8) : AppColors.green.withAlpha(8))
              : null,
          border: Border(
            bottom: BorderSide(
              color: isDark ? const Color(0x14FFFFFF) : const Color(0xFFF1F5F9),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: n.color.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(n.icon, color: n.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(n.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(n.message,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(_timeAgo(n.createdAt),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white30 : AppColors.textSecondary.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            if (!n.read)
              Container(
                width: 8, height: 8,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours}h';
    if (diff.inDays < 7) return 'hace ${diff.inDays}d';
    return '${date.day}/${date.month}/${date.year}';
  }
}
