import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:educode_mobile/app.dart';
import 'package:educode_mobile/core/theme/theme_provider.dart';

void main() {
  testWidgets('muestra la pantalla de carga al iniciar', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier()..init(false),
        child: const EduCodeApp(),
      ),
    );

    expect(find.text('Cargando EduCode...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}