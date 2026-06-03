// Steps formatting — space-grouped counts and the provenance label that tells
// the user where a day's value was entered (spec §18).

import 'package:flutter/widgets.dart';

import '../../core/l10n/l10n_ext.dart';
import '../../domain/enums.dart';

/// Thousands-grouped integer, e.g. 9420 → "9 420".
String groupedInt(int n) {
  final digits = n.abs().toString();
  final buf = StringBuffer(n < 0 ? '-' : '');
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(' ');
    buf.write(digits[i]);
  }
  return buf.toString();
}

/// Where a day's step value was entered (spec §18).
String stepsProvenance(BuildContext context, StepsSource source) =>
    switch (source) {
      StepsSource.dailyQuickLog => context.l10n.stepsProvFromDaily,
      StepsSource.stepsModule => context.l10n.stepsProvFromSteps,
    };
