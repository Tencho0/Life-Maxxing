import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/core/icons/lm_icons.dart';

void main() {
  group('iconPath', () {
    test('every icon builds without throwing', () {
      for (final i in LmIcons.values) {
        expect(() => iconPath(i), returnsNormally, reason: i.name);
      }
    });

    test('every icon has finite bounds within the 24-unit box', () {
      for (final i in LmIcons.values) {
        final b = iconPath(i).getBounds();
        expect(b.left.isFinite && b.top.isFinite, isTrue, reason: i.name);
        expect(b.right.isFinite && b.bottom.isFinite, isTrue, reason: i.name);
        // generous margin for stroke geometry / arcs
        expect(b.left, greaterThanOrEqualTo(-3), reason: i.name);
        expect(b.top, greaterThanOrEqualTo(-3), reason: i.name);
        expect(b.right, lessThanOrEqualTo(27), reason: i.name);
        expect(b.bottom, lessThanOrEqualTo(27), reason: i.name);
      }
    });

    test('icons are cached (same Path instance)', () {
      expect(identical(iconPath(LmIcons.home), iconPath(LmIcons.home)), isTrue);
    });
  });

  group('parseSvgPath', () {
    test('absolute move + line', () {
      final b = parseSvgPath('M2 4 L12 4').getBounds();
      expect(b.left, closeTo(2, 1e-6));
      expect(b.right, closeTo(12, 1e-6));
      expect(b.top, closeTo(4, 1e-6));
    });

    test('relative commands and consecutive decimals ("1.5.4")', () {
      // m0 0 then relative line by (1.5, 0.4)
      final b = parseSvgPath('m0 0 1.5.4').getBounds();
      expect(b.right, closeTo(1.5, 1e-6));
      expect(b.bottom, closeTo(0.4, 1e-6));
    });

    test('vertical/horizontal + close', () {
      final b = parseSvgPath('M0 0 H10 V10 H0 Z').getBounds();
      expect(b.width, closeTo(10, 1e-6));
      expect(b.height, closeTo(10, 1e-6));
    });

    test('arc command produces geometry', () {
      final b = parseSvgPath('M2 12 a6 6 0 0 1 12 0').getBounds();
      expect(b.width, greaterThan(0));
      expect(b.height, greaterThan(0));
    });
  });
}
