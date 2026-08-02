import 'package:flutter/material.dart';

class TrafficLightProgressBar extends StatelessWidget {
  final double value;
  final double minHeight;
  final Color backgroundColor;
  final BorderRadius? borderRadius;

  const TrafficLightProgressBar({
    super.key,
    required this.value,
    this.minHeight = 6,
    this.backgroundColor = Colors.white, // Fondo neutro
    this.borderRadius,
  });

  Color _getProgressColor(double progress) {
    if (progress <= 0) return Colors.transparent;
    if (progress <= 0.25) return Colors.red;
    if (progress <= 0.5) return Colors.yellow;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final clampedValue = value.clamp(0.0, 1.0);
    final color = _getProgressColor(clampedValue);

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(minHeight / 2),
      child: LinearProgressIndicator(
        value: clampedValue,
        minHeight: minHeight,
        backgroundColor: Colors.transparent, // Fondo transparente
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}