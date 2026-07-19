import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/lesson_content.dart';
import '../../../models/content_block.dart';
import '../../../models/lesson.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final String moduleTitle;
  final String moduleAccent;
  final bool isCompleted;
  final Future<void> Function() onMarkComplete;

  const LessonPage({
    super.key,
    required this.lesson,
    required this.moduleTitle,
    required this.moduleAccent,
    required this.isCompleted,
    required this.onMarkComplete,
  });

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  bool _isCompleting = false;
  late bool _isCompleted;
  late List<ContentBlock> _displayContent;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
    final backendContent = widget.lesson.content;
    if (backendContent.length < 3 && enrichedLessons.containsKey(widget.lesson.id)) {
      _displayContent = enrichedLessons[widget.lesson.id]!;
    } else {
      _displayContent = backendContent;
    }
  }

  Future<void> _markComplete() async {
    setState(() { _isCompleting = true; });
    try {
      await widget.onMarkComplete();
      if (mounted) setState(() { _isCompleted = true; _isCompleting = false; });
    } catch (_) {
      if (mounted) {
        setState(() { _isCompleting = false; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo marcar la lección como completada')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = Color(int.parse('FF${widget.moduleAccent.replaceAll('#', '')}', radix: 16));

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.lesson.title, style: const TextStyle(fontSize: 16)),
            Text(widget.moduleTitle, style: TextStyle(
              fontSize: 11, color: isDark ? Colors.white60 : AppColors.textSecondary,
            )),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              itemCount: _displayContent.length,
              itemBuilder: (context, index) {
                final block = _displayContent[index];
                if (block.isCode) {
                  return _CodeBlock(value: block.value, color: color);
                }
                if (block.isHeading) {
                  return _HeadingBlock(value: block.value);
                }
                if (block.isWarning) {
                  return _WarningBlock(value: block.value);
                }
                return _TextBlock(value: block.value);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: _isCompleted ? null : _markComplete,
                  icon: _isCompleting
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Icon(_isCompleted ? Icons.check_circle_rounded : Icons.check_rounded),
                  label: Text(_isCompleted
                      ? 'Completada'
                      : (_isCompleting ? 'Guardando...' : 'Marcar como completada')),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextBlock extends StatelessWidget {
  final String value;

  const _TextBlock({required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(value,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: isDark ? Colors.white : AppColors.textDark,
          height: 1.6,
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  final String value;
  final Color color;

  const _CodeBlock({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code_rounded, size: 16, color: color),
                const SizedBox(width: 6),
                Text('Código', style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600, color: color,
                )),
              ],
            ),
            const SizedBox(height: 10),
            SelectableText(value,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: isDark ? Colors.white : AppColors.textDark,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeadingBlock extends StatelessWidget {
  final String value;
  const _HeadingBlock({required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(value,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.textDark,
          height: 1.3,
        ),
      ),
    );
  }
}

class _WarningBlock extends StatelessWidget {
  final String value;
  const _WarningBlock({required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: (isDark ? AppColors.yellow : AppColors.yellow).withAlpha(20),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: (isDark ? AppColors.yellow : AppColors.yellow).withAlpha(60),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.warning_amber_rounded, size: 20, color: AppColors.yellow),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white.withAlpha(204) : AppColors.textDark,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}