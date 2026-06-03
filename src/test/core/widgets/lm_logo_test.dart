import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/core/widgets/lm_logo.dart';

void main() {
  testWidgets('LmLogo.icon paints a CustomPaint at the requested size',
      (tester) async {
    await tester.pumpWidget(
      const Center(child: LmLogo.icon(size: 64)),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LmLogo), findsOneWidget);
    final customPaint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(LmLogo),
        matching: find.byType(CustomPaint),
      ),
    );
    expect(customPaint.painter, isA<LmLogoPainter>());
    expect((customPaint.painter! as LmLogoPainter).withBackground, isTrue);
    expect(tester.getSize(find.byType(LmLogo)), const Size(64, 64));
  });

  testWidgets('LmLogo.symbol paints the bare mark (no background)',
      (tester) async {
    await tester.pumpWidget(
      const Center(child: LmLogo.symbol(size: 40)),
    );
    await tester.pumpAndSettle();

    final customPaint = tester.widget<CustomPaint>(
      find.descendant(
        of: find.byType(LmLogo),
        matching: find.byType(CustomPaint),
      ),
    );
    expect((customPaint.painter! as LmLogoPainter).withBackground, isFalse);
    expect(tester.getSize(find.byType(LmLogo)), const Size(40, 40));
  });
}
