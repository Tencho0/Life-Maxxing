import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'dev/dev_home.dart';

void main() => runApp(const LifeMaxxingApp());

class LifeMaxxingApp extends StatelessWidget {
  const LifeMaxxingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LifeMaxxing',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // TEMP (Phase 1–2): design-system gallery + component catalog. Replaced
      // by the router shell in Phase 5 (see docs/implementation-plan.md).
      home: const DevHome(),
    );
  }
}
