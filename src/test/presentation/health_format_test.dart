import 'package:flutter_test/flutter_test.dart';
import 'package:lifemaxxing/presentation/health/health_format.dart';

void main() {
  test('formatKg renders one decimal with the кг suffix', () {
    expect(formatKg(82500), '82.5 кг');
    expect(formatKg(80000), '80.0 кг');
  });

  test('formatKgDelta is signed with a unicode minus for losses', () {
    expect(formatKgDelta(1200), '+1.2 кг');
    expect(formatKgDelta(-800), '−0.8 кг'); // U+2212 minus
    expect(formatKgDelta(0), '±0.0 кг');
  });
}
