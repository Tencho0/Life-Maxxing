import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/core/theme/mood_color.dart';

void main() {
  group('moodColor (OKLCH→sRGB ramp)', () {
    test('low mood (1) is red-dominant', () {
      final c = moodColor(1);
      expect(c.r, greaterThan(c.g));
      expect(c.r, greaterThan(c.b));
    });

    test('high mood (10) is green-dominant', () {
      final c = moodColor(10);
      expect(c.g, greaterThan(c.r));
      expect(c.g, greaterThan(c.b));
    });

    test('mid mood (6) is warm — blue is the weakest channel', () {
      final c = moodColor(6);
      expect(c.b, lessThan(c.r));
      expect(c.b, lessThan(c.g));
    });

    test('hue increases monotonically 1→10 (25°→150°)', () {
      for (var v = 1; v < 10; v++) {
        expect(moodHue(v + 1), greaterThan(moodHue(v)));
      }
      expect(moodHue(1), closeTo(25, 1e-9));
      expect(moodHue(10), closeTo(150, 1e-9));
    });

    test('all channels stay within the sRGB gamut [0,1]', () {
      for (var v = 1; v <= 10; v++) {
        final c = moodColor(v);
        expect(c.r, inInclusiveRange(0.0, 1.0));
        expect(c.g, inInclusiveRange(0.0, 1.0));
        expect(c.b, inInclusiveRange(0.0, 1.0));
        expect(c.a, 1.0);
      }
    });

    test('clamps out-of-range values', () {
      expect(moodColor(0), equals(moodColor(1)));
      expect(moodColor(99), equals(moodColor(10)));
    });
  });

  group('moodLabel', () {
    test('maps ranges to Bulgarian labels', () {
      expect(moodLabel(1), 'много лошо');
      expect(moodLabel(2), 'много лошо');
      expect(moodLabel(3), 'лошо');
      expect(moodLabel(4), 'лошо');
      expect(moodLabel(6), 'средно');
      expect(moodLabel(8), 'добре');
      expect(moodLabel(9), 'много добре');
      expect(moodLabel(10), 'страхотно');
    });
  });
}
