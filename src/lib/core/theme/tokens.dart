// Design tokens — the single source for colors, radii, spacing, and motion.
// Mirrors the finalized design system (design/life-maxxing/project/lib/ui.jsx `T`).
// See docs/technical-spec.md §2.

import 'package:flutter/widgets.dart';

/// Color palette. Solid colors are full-alpha; `…Soft` variants are ~14% alpha
/// for chip/pill/gradient fills (matching the prototype's `…Soft` tokens).
abstract final class AppColors {
  // Surfaces
  static const bg = Color(0xFF0C0D11); // app background
  static const bg2 = Color(0xFF111319); // sheet background
  static const card = Color(0xFF15171E); // cards, inputs, rows
  static const cardHi = Color(0xFF1B1E27); // elevated card / toast

  // Borders (white at low alpha)
  static const border = Color(0x12FFFFFF); // ~7%
  static const borderHi = Color(0x21FFFFFF); // ~13%

  // Text
  static const text = Color(0xFFF3F5F9); // primary
  static const textDim = Color(0xFF99A0AE); // secondary
  static const textFaint = Color(0xFF5C636F); // tertiary / eyebrow

  // Accent + semantic colors (each with a ~14% soft fill)
  static const accent = Color(0xFF6AA8FF); // primary blue
  static const accentSoft = Color(0x246AA8FF);

  static const green = Color(0xFF5FD08A); // income / good / workout
  static const greenSoft = Color(0x245FD08A);

  static const red = Color(0xFFFF7A6B); // expense / danger / alcohol
  static const redSoft = Color(0x24FF7A6B);

  static const amber = Color(0xFFF5C36B); // food / priority / ratings
  static const amberSoft = Color(0x24F5C36B);

  static const purple = Color(0xFFC9A8FF); // steps
  static const purpleSoft = Color(0x24C9A8FF);

  static const pink = Color(0xFFFF9EC4); // pulse / BP
  static const pinkSoft = Color(0x24FF9EC4);

  /// Subtle white fills used for icon tiles / unselected chips.
  static const white05 = Color(0x0DFFFFFF); // ~5%
  static const white08 = Color(0x14FFFFFF); // ~8%
}

/// Gradient endpoints for the design's "hero" cards (daily mood, finance
/// balance, bucket experience). Use with [LinearGradient].
abstract final class AppGradients {
  // Blue hero (daily mood, "finish daily report" CTA): 135° #1A2435 → #14161D
  static const heroBlueStart = Color(0xFF1A2435);
  static const heroBlueEnd = Color(0xFF14161D);
  // Green hero (finance balance, bucket experience): 135° #15241C → #14161D
  static const heroGreenStart = Color(0xFF15241C);
  static const heroGreenEnd = Color(0xFF14161D);
}

/// Corner radii (logical px), from the prototype.
abstract final class AppRadii {
  static const double card = 18;
  static const double row = 15;
  static const double input = 13;
  static const double tile = 12; // small icon tiles
  static const double fab = 18;
  static const double sheet = 26; // bottom-sheet top corners
  static const double pill = 100; // fully rounded
}

/// Spacing rhythm (logical px). Screen body uses 14×16×22 padding.
abstract final class AppSpacing {
  static const double screenH = 16; // horizontal screen padding
  static const double screenTop = 14;
  static const double screenBottom = 22;
  static const double cardPad = 16;

  // Common gaps
  static const double xs = 6;
  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 14;
}

/// Motion timings, from the prototype's keyframes/transitions.
abstract final class AppDurations {
  static const fade = Duration(milliseconds: 200); // fadeIn
  static const sheet = Duration(milliseconds: 250); // sheet slide-up
  static const ring = Duration(milliseconds: 600); // ring stroke ease
}
