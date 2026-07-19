import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;
  String? _error;
  bool _success = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _change() async {
    final current = _currentCtrl.text;
    final newPw = _newCtrl.text;
    final confirm = _confirmCtrl.text;

    if (current.isEmpty) { setState(() => _error = 'Ingresa tu contraseña actual'); return; }
    if (newPw.isEmpty) { setState(() => _error = 'Ingresa la nueva contraseña'); return; }
    if (newPw.length < 8) { setState(() => _error = 'La nueva contraseña debe tener al menos 8 caracteres'); return; }
    if (newPw != confirm) { setState(() => _error = 'Las contraseñas nuevas no coinciden'); return; }

    setState(() { _isSaving = true; _error = null; });
    try {
      await context.read<AuthService>().changePassword(
        currentPassword: current,
        newPassword: newPw,
        newPasswordConfirm: confirm,
      );
      if (mounted) {
        setState(() { _success = true; _isSaving = false; });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('ApiException: ', '');
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseña')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          if (_success)
            Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.check_circle_rounded, color: AppColors.green, size: 64),
                const SizedBox(height: 16),
                Text('Contraseña actualizada',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text('Tu contraseña se ha cambiado correctamente',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Volver'),
                ),
              ],
            )
          else ...[
            _buildField(
              controller: _currentCtrl,
              label: 'Contraseña actual',
              hint: 'Ingresa tu contraseña actual',
              icon: Icons.lock_outline_rounded,
              obscure: _obscureCurrent,
              toggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _newCtrl,
              label: 'Nueva contraseña',
              hint: 'Mínimo 8 caracteres',
              icon: Icons.lock_rounded,
              obscure: _obscureNew,
              toggle: () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 16),
            _buildField(
              controller: _confirmCtrl,
              label: 'Confirmar nueva contraseña',
              hint: 'Repite la nueva contraseña',
              icon: Icons.lock_rounded,
              obscure: _obscureConfirm,
              toggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: AppColors.red, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity, height: 52,
              child: FilledButton(
                onPressed: _isSaving ? null : _change,
                child: _isSaving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Cambiar contraseña'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: toggle,
        ),
        border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
      ),
    );
  }
}