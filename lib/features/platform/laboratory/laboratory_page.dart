import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/laboratory_service.dart';
import '../../../core/services/modules_service.dart';
import '../../../models/module.dart';

const Map<int, String> _moduleStarters = {
  1: 'print("Hola, mundo")\n',
  2: 'nombre = "Ana"\nedad = 25\nprint(f"Me llamo {nombre} y tengo {edad} años")\n',
  3: 'entero = 10\ndecimal = 3.14\ntexto = "Python"\nactivo = True\nprint(entero, decimal, texto, activo)\n',
  4: 'a = 10\nb = 3\nprint("Suma:", a + b)\nprint("División:", a / b)\nprint("Resto:", a % b)\n',
  5: 'edad = 18\nif edad >= 18:\n    print("Eres mayor de edad")\nelse:\n    print("Eres menor de edad")\n',
  6: 'for i in range(5):\n    print("Iteración", i)\n',
};

const String _defaultCode = 'print("Hola, mundo")\n';

class LaboratoryPage extends StatefulWidget {
  const LaboratoryPage({super.key});

  @override
  State<LaboratoryPage> createState() => _LaboratoryPageState();
}

class _LaboratoryPageState extends State<LaboratoryPage> {
  late TextEditingController _codeController;
  final FocusNode _codeFocus = FocusNode();
  String _originalCode = _defaultCode;
  String _consoleOutput = '';
  String _stderr = '';
  int? _exitCode;
  int? _executionTime;
  bool _isRunning = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController(text: _defaultCode);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _codeFocus.dispose();
    super.dispose();
  }

  void _loadStarterCode(int? moduleId) {
    final code = (moduleId != null && _moduleStarters.containsKey(moduleId))
        ? _moduleStarters[moduleId]!
        : _defaultCode;
    setState(() {
      _originalCode = code;
      _codeController.text = code;
      _consoleOutput = '';
      _stderr = '';
      _exitCode = null;
      _executionTime = null;
      _errorMessage = null;
    });
  }

  void _restoreCode() {
    setState(() {
      _codeController.text = _originalCode;
      _consoleOutput = '';
      _stderr = '';
      _exitCode = null;
      _executionTime = null;
      _errorMessage = null;
    });
  }

  void _clearConsole() {
    setState(() {
      _consoleOutput = '';
      _stderr = '';
      _exitCode = null;
      _executionTime = null;
      _errorMessage = null;
    });
  }

  Future<void> _runCode() async {
    final code = _codeController.text;
    if (code.trim().isEmpty) {
      setState(() => _errorMessage = 'El código está vacío');
      return;
    }
    setState(() {
      _isRunning = true;
      _errorMessage = null;
      _consoleOutput = '';
      _stderr = '';
      _exitCode = null;
      _executionTime = null;
    });
    try {
      final service = context.read<LaboratoryService>();
      final result = await service.execute(code);
      if (mounted) {
        setState(() {
          _consoleOutput = result.stdout;
          _stderr = result.stderr;
          _exitCode = result.exitCode;
          _executionTime = result.executionTime;
          _isRunning = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('ApiException: ', '');
          _isRunning = false;
        });
      }
    }
  }

  int get _lineCount => '\n'.allMatches(_codeController.text).length + 1;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratorio'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Restaurar código',
            onPressed: _restoreCode,
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services_rounded),
            tooltip: 'Limpiar consola',
            onPressed: _clearConsole,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              flex: 5,
              child: _buildEditorArea(isDark),
            ),
            _buildDivider(isDark),
            Expanded(
              flex: 4,
              child: _buildConsoleArea(isDark),
            ),
            _buildBottomBar(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.pageHorizontalPadding,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.laboratoryBg : const Color(0xFFF1F5F9),
        border: Border(
          bottom: BorderSide(color: isDark ? Colors.white10 : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.green.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.extension_rounded,
              size: 16, color: AppColors.green),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: FutureBuilder<List<Module>>(
              future: context.read<ModulesService>().getModules(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Text('Cargando módulos...',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : AppColors.textSecondary,
                    ),
                  );
                }
                final modules = snapshot.data!;
                return DropdownButtonHideUnderline(
                  child: DropdownButton<int?>(
                    value: null,
                    isExpanded: true,
                    hint: Text('Cargar plantilla de módulo...',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : AppColors.textSecondary,
                      ),
                    ),
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    items: [
                      DropdownMenuItem<int?>(
                        value: null,
                        child: Text('Código en blanco',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : AppColors.textDark,
                          ),
                        ),
                      ),
                      ...modules.map((m) => DropdownMenuItem<int?>(
                        value: m.id,
                        child: Text(m.title,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : AppColors.textDark,
                          ),
                        ),
                      )),
                    ],
                    onChanged: (value) => _loadStarterCode(value),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditorArea(bool isDark) {
    return Container(
      color: isDark ? AppColors.laboratoryEditor : const Color(0xFFF8FAFC),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLineNumbers(isDark),
          const VerticalDivider(width: 1),
          Expanded(
            child: TextField(
              controller: _codeController,
              focusNode: _codeFocus,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.6,
                color: isDark ? AppColors.laboratoryText : AppColors.textDark,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                hintText: '# Escribe tu código aquí',
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                  color: isDark ? Colors.white12 : Colors.black12,
                ),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineNumbers(bool isDark) {
    return Container(
      width: 40,
      padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.laboratoryLineBg : const Color(0xFFF1F5F9),
        border: Border(
          right: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            width: 1,
          ),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: List.generate(
          _lineCount.clamp(1, 999),
          (i) => SizedBox(
            height: 22.4,
            child: Text(
              '${i + 1}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 11,
                height: 1.6,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.laboratoryBg : const Color(0xFFE2E8F0),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFCBD5E1),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.terminal_rounded,
            size: 14,
            color: isDark ? Colors.white38 : AppColors.textSecondary,
          ),
          const SizedBox(width: 6),
          Text('CONSOLA',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: isDark ? Colors.white38 : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (_isRunning)
            SizedBox(
              width: 12, height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.green,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConsoleArea(bool isDark) {
    final hasOutput = _consoleOutput.isNotEmpty || _stderr.isNotEmpty || _errorMessage != null;
    return Container(
      color: AppColors.laboratoryEditor,
      child: hasOutput
          ? ListView(
              padding: const EdgeInsets.all(12),
              children: [
                if (_consoleOutput.isNotEmpty)
                  SelectableText(_consoleOutput,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFFE6EDF3),
                    ),
                  ),
                if (_stderr.isNotEmpty) ...[
                  if (_consoleOutput.isNotEmpty) const SizedBox(height: 8),
                  SelectableText(_stderr,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      height: 1.6,
                      color: Color(0xFFF87171),
                    ),
                  ),
                ],
                if (_errorMessage != null) ...[
                  if (_consoleOutput.isNotEmpty || _stderr.isNotEmpty)
                    const SizedBox(height: 8),
                  SelectableText(_errorMessage!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: AppColors.laboratoryError,
                    ),
                  ),
                ],
                if (_exitCode != null && _executionTime != null) ...[
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _TerminalBadge(
                        label: 'exit code: $_exitCode',
                        color: _exitCode == 0
                            ? AppColors.exitSuccess
                            : AppColors.laboratoryStderr,
                      ),
                      const SizedBox(width: 10),
                      _TerminalBadge(
                        label: 'time: ${_executionTime}ms',
                        color: AppColors.badgeBlue,
                      ),
                    ],
                  ),
                ],
              ],
            )
          : const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.terminal_rounded,
                    size: 32, color: Colors.white10,
                  ),
                  SizedBox(height: 6),
                  Text('La salida del programa aparecerá aquí',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppConstants.pageHorizontalPadding, 10,
        AppConstants.pageHorizontalPadding, 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.laboratoryBg : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: FilledButton.icon(
          onPressed: _isRunning ? null : _runCode,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          icon: _isRunning
              ? const SizedBox(
                  width: 20, height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white,
                  ),
                )
              : const Icon(Icons.play_arrow_rounded, size: 22),
          label: Text(
            _isRunning ? 'Ejecutando...' : 'Ejecutar código',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _TerminalBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TerminalBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(label,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}