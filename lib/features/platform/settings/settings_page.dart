import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/settings_service.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../models/auth_user.dart';
import 'change_password_page.dart';
import 'edit_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AuthUser? _user;
  bool _notifications = true;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final auth = context.read<AuthService>();
    final notifService = context.read<NotificationService>();
    final user = await auth.getMe();
    final notif = await notifService.getEnabled();
    if (mounted) {
      setState(() {
        _user = user;
        _notifications = notif;
      });
    }
  }

  Future<void> _toggleDarkMode(bool value) async {
    final settings = context.read<SettingsService>();
    await settings.setDarkMode(value);
    if (mounted) context.read<ThemeNotifier>().setDarkMode(value);
  }

  Future<void> _toggleNotifications(bool value) async {
    await context.read<NotificationService>().setEnabled(value);
    setState(() => _notifications = value);
  }

  Future<void> _deleteAccount() async {
    final auth = context.read<AuthService>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar cuenta'),
        content: const Text('¿Estás seguro? Esta acción no se puede deshacer. Se eliminarán todos tus datos y progreso.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _isDeleting = true);
    try {
      await auth.deleteAccount();
      if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      if (mounted) {
        setState(() => _isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('ApiException: ', ''))),
        );
      }
    }
  }

  Future<void> _logout() async {
    final auth = context.read<AuthService>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Cerrar sesión', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await auth.logout();
    if (mounted) Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = _user;

    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
        children: [
          // Profile section
          _SectionHeader(title: 'PERFIL'),
          _SettingsTile(
            leading: Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.green.withAlpha(26),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.person_rounded, color: AppColors.green, size: 22),
            ),
            title: user?.name ?? 'Usuario',
            subtitle: user?.email ?? '',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(
                    currentName: user?.name ?? '',
                    currentBio: user?.bio,
                  ),
                ),
              );
              if (result == true) _loadData();
            },
          ),
          const Divider(height: 1, indent: 72, endIndent: 16),

          // Account section
          _SectionHeader(title: 'CUENTA'),
          _SettingsTile(
            leading: _settingIcon(Icons.lock_rounded, AppColors.blue),
            title: 'Cambiar contraseña',
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const ChangePasswordPage(),
            )),
          ),
          const Divider(height: 1, indent: 72, endIndent: 16),
          _SettingsTile(
            leading: _settingIcon(Icons.delete_forever_rounded, AppColors.red),
            title: 'Eliminar cuenta',
            subtitle: 'Todos tus datos serán borrados',
            titleColor: AppColors.red,
            trailing: _isDeleting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : null,
            onTap: _deleteAccount,
          ),

          // Preferences section
          _SectionHeader(title: 'PREFERENCIAS'),
          _SettingsTile(
            leading: _settingIcon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              AppColors.yellow,
            ),
            title: 'Modo oscuro',
            trailing: Switch(
              value: isDark,
              activeTrackColor: AppColors.yellow,
              onChanged: _toggleDarkMode,
            ),
          ),
          const Divider(height: 1, indent: 72, endIndent: 16),
          _SettingsTile(
            leading: _settingIcon(Icons.notifications_rounded, AppColors.purple),
            title: 'Notificaciones',
            trailing: Switch(
              value: _notifications,
              activeTrackColor: AppColors.purple,
              onChanged: _toggleNotifications,
            ),
          ),

          const SizedBox(height: 16),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: _logout,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar sesión'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingIcon(IconData icon, Color color) {
    return Container(
      width: 44, height: 44,
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
      child: Text(title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      leading: leading,
      title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
          color: titleColor ?? (isDark ? Colors.white : const Color(0xFF1E293B)),
        ),
      ),
      subtitle: subtitle != null
          ? Text(subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : const Color(0xFF64748B),
              ),
            )
          : null,
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      shape: const Border(),
    );
  }
}