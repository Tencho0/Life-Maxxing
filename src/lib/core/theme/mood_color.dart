// Mood color ramp — red → amber → green across a 1–10 scale.
//
// The design expresses this in OKLCH: `oklch(0.74 0.15 H)` with
// `H = 25 + (v-1)/9 * 125` (hue 25°→150° as v goes 1→10). Flutter's `Color`
// is sRGB, so we convert OKLCH → OKLab → linear sRGB → gamma sRGB here
// (Björn Ottosson's matrices). See docs/technical-spec.md §2.1.

import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// Fixed lightness/chroma of the ramp (from the design).
const double _moodL = 0.74;
const double _moodC = 0.15;

/// Hue in degrees for a mood value [v] (1–10): 25° (red) → 150° (green).
double moodHue(int v) {
  final c = v.clamp(1, 10);
  return 25 + (c - 1) / 9 * 125;
}

/// sRGB color for a mood value [v] in 1–10.
Color moodColor(int v) => oklchToColor(_moodL, _moodC, moodHue(v));

/// Bulgarian label for a mood value [v] (matches the prototype's `moodLabel`).
String moodLabel(int v) {
  final c = v.clamp(1, 10);
  if (c <= 2) return 'много лошо';
  if (c <= 4) return 'лошо';
  if (c <= 6) return 'средно';
  if (c <= 8) return 'добре';
  if (c <= 9) return 'много добре';
  return 'страхотно';
}

/// Converts OKLCH (L 0–1, C, H degrees) to an sRGB [Color] (alpha 1.0).
Color oklchToColor(double l, double c, double hDeg) {
  final h = hDeg * math.pi / 180.0;
  final a = c * math.cos(h);
  final b = c * math.sin(h);
  final (r, g, bl) = _oklabToSrgb(l, a, b);
  return Color.fromARGB(255, _to8(r), _to8(g), _to8(bl));
}

/// OKLab → gamma-encoded sRGB (each channel 0–1, unclamped before gamma).
(double, double, double) _oklabToSrgb(double l, double a, double b) {
  // OKLab → LMS' → LMS (cube)
  final lp = l + 0.3963377774 * a + 0.2158037573 * b;
  final mp = l - 0.1055613458 * a - 0.0638541728 * b;
  final sp = l - 0.0894841775 * a - 1.2914855480 * b;
  final lc = lp * lp * lp;
  final mc = mp * mp * mp;
  final sc = sp * sp * sp;
  // LMS → linear sRGB
  final lr = 4.0767416621 * lc - 3.3077115913 * mc + 0.2309699292 * sc;
  final lg = -1.2684380046 * lc + 2.6097574011 * mc - 0.3413193965 * sc;
  final lb = -0.0041960863 * lc - 0.7034186147 * mc + 1.7076147010 * sc;
  return (_gamma(lr), _gamma(lg), _gamma(lb));
}

/// Linear → gamma sRGB transfer function.
double _gamma(double x) {
  final c = x.clamp(0.0, 1.0);
  return c <= 0.0031308 ? 12.92 * c : 1.055 * math.pow(c, 1 / 2.4) - 0.055;
}

int _to8(double channel) => (channel.clamp(0.0, 1.0) * 255).round();
