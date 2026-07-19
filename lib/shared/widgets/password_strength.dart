import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _calculateStrength(password);
    final data = _strengthData(strength);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: data.fraction,
              minHeight: 4,
              backgroundColor: isDark ? Colors.white12 : Colors.black.withAlpha(13),
              valueColor: AlwaysStoppedAnimation<Color>(data.color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: data.color,
            ),
          ),
        ],
      ),
    );
  }

  int _calculateStrength(String pw) {
    var score = 0;
    if (pw.length >= 8) score++;
    if (pw.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw)) score++;
    if (RegExp(r'[a-z]').hasMatch(pw)) score++;
    if (RegExp(r'[0-9]').hasMatch(pw)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(pw)) score++;
    if (pw.length >= 16) score++;
    return score;
  }

  _StrengthData _strengthData(int score) {
    if (score <= 2) {
      return _StrengthData(0.25, AppColors.red, 'Débil');
    } else if (score <= 3) {
      return _StrengthData(0.45, Colors.orange, 'Media');
    } else if (score <= 5) {
      return _StrengthData(0.7, AppColors.yellow, 'Fuerte');
    } else {
      return _StrengthData(1.0, AppColors.green, 'Muy fuerte');
    }
  }
}

class _StrengthData {
  final double fraction;
  final Color color;
  final String label;
  _StrengthData(this.fraction, this.color, this.label);
}
