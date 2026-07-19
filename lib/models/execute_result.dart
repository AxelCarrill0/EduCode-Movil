class ExecuteResult {
  final String stdout;
  final String stderr;
  final String output;
  final int exitCode;
  final int executionTime;

  const ExecuteResult({
    required this.stdout,
    required this.stderr,
    required this.output,
    required this.exitCode,
    required this.executionTime,
  });

  factory ExecuteResult.fromJson(Map<String, dynamic> json) {
    return ExecuteResult(
      stdout: json['stdout'] as String? ?? '',
      stderr: json['stderr'] as String? ?? '',
      output: json['output'] as String? ?? '',
      exitCode: (json['exitCode'] as num?)?.toInt() ?? 0,
      executionTime: (json['executionTime'] as num?)?.toInt() ?? 0,
    );
  }

  bool get isSuccess => exitCode == 0;
  bool get hasError => stderr.isNotEmpty || exitCode != 0;
}
