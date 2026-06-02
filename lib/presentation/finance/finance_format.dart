// EUR formatting (cents → €, space-grouped, comma decimals) and the
// expense-category color palette used by the finance breakdown.
//
// The format is deliberately locale-INDEPENDENT: a single currency (EUR) with
// the finalized design's space-grouped thousands + comma decimals, identical in
// every UI language (CLAUDE §2 design-locked, §4 EUR). Only natural-language
// text is localized (Slice 10.5); record dates likewise stay numeric dd.MM.yyyy.

import 'package:flutter/widgets.dart';
import '../../core/theme/tokens.dart';
import '../../domain/enums.dart';

String _group(String digits) {
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buf.write(' ');
    buf.write(digits[i]);
  }
  return buf.toString();
}

/// Whole euros, e.g. 119000 → "1 190 €".
String euroWhole(int cents) => '${_group((cents ~/ 100).abs().toString())} €';

/// Euros with 2 decimals, e.g. 3250 → "32,50 €".
String euro2(int cents) {
  final s = (cents.abs() / 100).toStringAsFixed(2).split('.');
  return '${_group(s[0])},${s[1]} €';
}

/// Signed whole euros for ledger rows, e.g. expense → "−120 €".
String euroSigned(int cents, {required bool negative}) =>
    '${negative ? '−' : '+'}${euroWhole(cents)}';

const _palette = [
  AppColors.amber,
  AppColors.accent,
  AppColors.purple,
  AppColors.red,
  AppColors.green,
  AppColors.pink,
];

Color expenseCategoryColor(ExpenseCategory c) =>
    _palette[c.index % _palette.length];
