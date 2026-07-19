class ContentBlock {
  final String type;
  final String value;

  const ContentBlock({required this.type, required this.value});

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    return ContentBlock(
      type: json['type'] as String? ?? 'text',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'type': type, 'value': value};

  bool get isCode => type == 'code';
  bool get isText => type == 'text';
  bool get isHeading => type == 'heading';
  bool get isWarning => type == 'warning';
}