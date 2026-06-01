import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lifemaxxing/core/widgets/lm_button.dart';
import 'package:lifemaxxing/core/widgets/pill.dart';
import 'package:lifemaxxing/core/widgets/segmented.dart';
import 'package:lifemaxxing/core/widgets/yes_no.dart';
import 'package:lifemaxxing/core/widgets/scale10.dart';
import 'package:lifemaxxing/core/widgets/lm_stepper.dart';
import 'package:lifemaxxing/core/widgets/mood_picker.dart';

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Center(child: child))),
  );
}

void main() {
  group('LmButton', () {
    testWidgets('renders label and fires onTap', (tester) async {
      var taps = 0;
      await _pump(tester, LmButton('Запази', onTap: () => taps++));
      expect(find.text('Запази'), findsOneWidget);
      await tester.tap(find.text('Запази'));
      expect(taps, 1);
    });

    testWidgets('all variants render their label', (tester) async {
      for (final v in LmButtonVariant.values) {
        await _pump(tester, LmButton('Бутон', variant: v, onTap: () {}));
        expect(find.text('Бутон'), findsOneWidget);
      }
    });
  });

  testWidgets('Pill renders its text', (tester) async {
    await _pump(tester, const Pill('нормално'));
    expect(find.text('нормално'), findsOneWidget);
  });

  testWidgets('Segmented reports the tapped option', (tester) async {
    String? picked;
    await _pump(
      tester,
      Segmented(
        options: const ['Закуска', 'Обяд', 'Вечеря'],
        value: 'Закуска',
        onChanged: (v) => picked = v,
      ),
    );
    await tester.tap(find.text('Вечеря'));
    expect(picked, 'Вечеря');
  });

  testWidgets('YesNo reports true for Да and false for Не', (tester) async {
    bool? v;
    await _pump(tester, YesNo(value: null, onChanged: (x) => v = x));
    await tester.tap(find.text('Да'));
    expect(v, isTrue);
    await tester.tap(find.text('Не'));
    expect(v, isFalse);
  });

  testWidgets('Scale10 reports the tapped number', (tester) async {
    int? v;
    await _pump(tester, Scale10(value: null, onChanged: (x) => v = x));
    await tester.tap(find.text('7'));
    expect(v, 7);
  });

  group('LmStepper', () {
    testWidgets('increments and decrements by step', (tester) async {
      int? v;
      await _pump(tester, LmStepper(value: 5, onChanged: (x) => v = x));
      await tester.tap(find.text('+'));
      expect(v, 6);
      await tester.tap(find.text('−')); // minus sign U+2212
      expect(v, 4);
    });

    testWidgets('clamps at min', (tester) async {
      int? v;
      await _pump(
        tester,
        LmStepper(value: 0, min: 0, onChanged: (x) => v = x),
      );
      await tester.tap(find.text('−'));
      expect(v, 0);
    });
  });

  testWidgets('MoodPicker reports the tapped value', (tester) async {
    int? v;
    await _pump(tester, MoodPicker(value: 5, onChanged: (x) => v = x));
    await tester.tap(find.text('9')); // segment 9 (big number is 5)
    expect(v, 9);
  });
}
