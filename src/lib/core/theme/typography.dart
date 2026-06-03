// Typography — named text styles from the design system.
// IBM Plex Sans for UI text; IBM Plex Mono for numbers/metrics/eyebrows.
// Styles carry their intrinsic color; override with .copyWith at call sites
// when the design tints them (e.g. an accent-colored eyebrow). See §2.2.

import 'package:flutter/widgets.dart';
import 'tokens.dart';

abstract final class AppText {
  static const String sans = 'IBM Plex Sans';
  static const String mono = 'IBM Plex Mono';

  // ── Titles / headings (Sans) ──────────────────────────────────────
  static const greeting = TextStyle(
    fontFamily: sans, fontSize: 23, fontWeight: FontWeight.w700,
    letterSpacing: -0.4, color: AppColors.text, height: 1.1,
  );
  static const title = TextStyle(
    fontFamily: sans, fontSize: 18, fontWeight: FontWeight.w700,
    letterSpacing: -0.3, color: AppColors.text,
  );
  static const sheetTitle = TextStyle(
    fontFamily: sans, fontSize: 19, fontWeight: FontWeight.w700,
    letterSpacing: -0.3, color: AppColors.text,
  );
  static const cardTitle = TextStyle(
    fontFamily: sans, fontSize: 15, fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  // ── Body (Sans) ───────────────────────────────────────────────────
  static const body = TextStyle(
    fontFamily: sans, fontSize: 14, fontWeight: FontWeight.w400,
    color: AppColors.text, height: 1.5,
  );
  static const bodyDim = TextStyle(
    fontFamily: sans, fontSize: 13, fontWeight: FontWeight.w400,
    color: AppColors.textDim, height: 1.5,
  );
  static const bodyStrong = TextStyle(
    fontFamily: sans, fontSize: 14, fontWeight: FontWeight.w600,
    color: AppColors.text,
  );
  static const button = TextStyle(
    fontFamily: sans, fontSize: 15, fontWeight: FontWeight.w600,
    color: AppColors.text,
  );

  // ── Eyebrows / labels (Mono, uppercase) ───────────────────────────
  static const eyebrow = TextStyle(
    fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 1.5, color: AppColors.textFaint,
  );
  static const fieldLabel = TextStyle(
    fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.8, color: AppColors.textDim,
  );

  // ── Numbers / metrics (Mono) ──────────────────────────────────────
  static const stat = TextStyle(
    fontFamily: mono, fontSize: 22, fontWeight: FontWeight.w600,
    color: AppColors.text, height: 1.1,
  );
  static const statLg = TextStyle(
    fontFamily: mono, fontSize: 30, fontWeight: FontWeight.w600,
    color: AppColors.text, height: 1.0,
  );
  static const statXl = TextStyle(
    fontFamily: mono, fontSize: 34, fontWeight: FontWeight.w600,
    color: AppColors.text, height: 1.0,
  );
  static const mono12 = TextStyle(
    fontFamily: mono, fontSize: 12, fontWeight: FontWeight.w400,
    color: AppColors.textDim,
  );
  static const monoFaint = TextStyle(
    fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w400,
    color: AppColors.textFaint,
  );

  // ── Pills / chips (Mono) ──────────────────────────────────────────
  static const pill = TextStyle(
    fontFamily: mono, fontSize: 11, fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
  );
}
