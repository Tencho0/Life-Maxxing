// One-shot asset generator (run manually, not a behavioural test):
//   flutter test test/tools/generate_branding_assets.dart
// Renders LmLogoPainter to the 1024px PNGs that flutter_launcher_icons consumes.
// Re-run whenever the painter geometry/colours change, then commit the PNGs.

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/core/theme/tokens.dart';
import 'package:lifemaxxing/core/widgets/lm_logo.dart';

const int _px = 1024;

ui.Image _render(void Function(Canvas, Size) paint) {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  paint(canvas, const Size(_px + 0.0, _px + 0.0));
  return recorder.endRecording().toImageSync(_px, _px);
}

Future<void> _writePng(String path, ui.Image image) async {
  final data = await image.toByteData(format: ui.ImageByteFormat.png);
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(data!.buffer.asUint8List());
}

/// Full-bleed hero-blue gradient (adaptive-icon background layer).
void _paintBackground(Canvas canvas, Size size) {
  final rect = Offset.zero & size;
  canvas.drawRect(
    rect,
    Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppGradients.heroBlueStart, AppGradients.heroBlueEnd],
      ).createShader(rect),
  );
}

void main() {
  testWidgets('generate branding PNGs', (tester) async {
    await tester.runAsync(() async {
      // Legacy square icon: mark on the rounded-square background.
      await _writePng(
        'assets/branding/icon-1024.png',
        _render((c, s) => const LmLogoPainter(withBackground: true).paint(c, s)),
      );
      // Adaptive foreground: bare mark on transparent.
      await _writePng(
        'assets/branding/icon-fg-1024.png',
        _render((c, s) => const LmLogoPainter(withBackground: false).paint(c, s)),
      );
      // Adaptive background: gradient fill only.
      await _writePng(
        'assets/branding/icon-bg-1024.png',
        _render(_paintBackground),
      );
    });

    expect(File('assets/branding/icon-1024.png').existsSync(), isTrue);
    expect(File('assets/branding/icon-fg-1024.png').existsSync(), isTrue);
    expect(File('assets/branding/icon-bg-1024.png').existsSync(), isTrue);
  });
}
