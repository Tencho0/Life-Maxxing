// LifeMaxxing icon set — the design's 24×24 stroke icons, ported faithfully.
//
// The prototype (design/.../lib/ui.jsx `Icon`) defines icons as SVG primitives
// (path `d` data, <circle>, <rect>) drawn with fill:none, round caps/joins.
// We parse the path data into a Flutter [Path] (incl. arcs via arcToPoint) and
// stroke everything in a 24-unit space scaled to the requested size. See §6.1.

import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// The available icons (names mirror the prototype).
enum LmIcons {
  home, bolt, food, expense, income, heart, pulse, pill, run, steps, camera,
  bucket, trip, labs, event, chart, export, search, calendar, plus,
  chevR, chevL, chevD, close, check, edit, trash, mood, clock, drop, screen,
  dumbbell, star, flag, pin, arrowR, filter, dots, sun,
}

/// A stroked line-icon from the design set.
class LmIcon extends StatelessWidget {
  const LmIcon(
    this.icon, {
    super.key,
    this.size = 22,
    this.color = const Color(0xFFF3F5F9),
    this.strokeWidth = 1.7,
  });

  final LmIcons icon;
  final double size;
  final Color color;

  /// Stroke width in the 24-unit icon space (scales with [size]).
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _IconPainter(icon, color, strokeWidth),
      ),
    );
  }
}

class _IconPainter extends CustomPainter {
  _IconPainter(this.icon, this.color, this.strokeWidth);
  final LmIcons icon;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 24.0;
    canvas.save();
    canvas.scale(s, s);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    canvas.drawPath(iconPath(icon), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _IconPainter old) =>
      old.icon != icon || old.color != color || old.strokeWidth != strokeWidth;
}

// ── Icon path registry (cached) ─────────────────────────────────────
final Map<LmIcons, Path> _cache = {};

/// The combined [Path] for [icon] in 24×24 space (cached).
Path iconPath(LmIcons icon) => _cache[icon] ??= _build(icon);

Path _build(LmIcons icon) {
  switch (icon) {
    case LmIcons.home:
      return _paths(['M3 10.5 12 3l9 7.5', 'M5 9.5V20h14V9.5']);
    case LmIcons.bolt:
      return _paths(['M13 2 4 13h6l-1 9 9-12h-6l1-8z']);
    case LmIcons.food:
      return _paths([
        'M5 3v7a2 2 0 0 0 4 0V3',
        'M7 10v11',
        'M17 3c-1.5 0-3 1.8-3 5s1 4 1 4v9',
      ]);
    case LmIcons.expense:
      return _combine([_rrect(2.5, 6, 19, 12, 2), _circle(12, 12, 2.6)]);
    case LmIcons.income:
      return _paths(['M12 3v13', 'm7 11 5 5 5-5', 'M5 21h14']);
    case LmIcons.heart:
      return _paths([
        'M12 20s-7-4.3-9.2-8.6C1.3 8.2 3 5 6 5c2 0 3.2 1.3 4 2.5C10.8 6.3 12 5 14 5c3 0 4.7 3.2 3.2 6.4C19 15.7 12 20 12 20z',
      ]);
    case LmIcons.pulse:
      return _paths(['M2 12h4l2-6 4 14 3-9 2 3h5']);
    case LmIcons.pill:
      return _combine([
        _transform(_rrect(3.5, 9, 17, 6, 3), _rotateAbout(45, 12, 12)),
        parseSvgPath('M8.5 8.5 15.5 15.5'),
      ]);
    case LmIcons.run:
      return _combine([
        _circle(14, 4.5, 2),
        parseSvgPath('M11 21l1.5-6L9 12l1-5 4 2 3 1'),
        parseSvgPath('m6 10 3-2'),
        parseSvgPath('m11 15-3 1-2 4'),
      ]);
    case LmIcons.steps:
      return _paths([
        'M7 4c1.5 0 2.5 1.5 2.5 4S8.5 14 7 14s-2.5-1.2-2.5-4S5.5 4 7 4z',
        'M5 16c2 0 3 1 3 2.5S7 21 5.5 21 3 20 3 18.5 3.5 16 5 16z',
        'M17 7c1.5 0 2.5 1.5 2.5 4S18.5 17 17 17s-2.5-1.2-2.5-4S15.5 7 17 7z',
      ]);
    case LmIcons.camera:
      return _combine([
        parseSvgPath(
          'M4 8h3l1.5-2h7L17 8h3a1 1 0 0 1 1 1v9a1 1 0 0 1-1 1H4a1 1 0 0 1-1-1V9a1 1 0 0 1 1-1z',
        ),
        _circle(12, 13, 3.2),
      ]);
    case LmIcons.bucket:
      return _transform(
        parseSvgPath(
          'm12 3 2.3 5.6 6 .5-4.6 4 1.4 5.9L12 20.9 6.9 24l1.4-5.9-4.6-4 6-.5L12 3z',
        ),
        _affine(0.92, 0, 0, 0.92, 0.92, -0.92), // scale(.92) translate(1,-1)
      );
    case LmIcons.trip:
      return _paths([
        'M2 16l8-2 4-9 1.5.4-1.8 8 5.3-1.4 1-2 1.2.3-.6 3.3L20 15l-1 3.6L4 21z',
      ]);
    case LmIcons.labs:
      return _paths([
        'M9 3h6',
        'M10 3v6l-5 9a1.6 1.6 0 0 0 1.5 2.3h11A1.6 1.6 0 0 0 19 18l-5-9V3',
        'M7.5 15h9',
      ]);
    case LmIcons.event:
      return _combine([
        _rrect(3.5, 5, 17, 16, 2),
        parseSvgPath('M3.5 9.5h17'),
        parseSvgPath('M8 3v4M16 3v4'),
        parseSvgPath('M12 12.5v4M10 14.5h4'),
      ]);
    case LmIcons.chart:
      return _combine([
        parseSvgPath('M4 4v16h16'),
        _rrect(7, 11, 3, 6, 0),
        _rrect(12.5, 7, 3, 10, 0),
      ]);
    case LmIcons.export:
      return _paths([
        'M12 15V3',
        'm8 7 4-4 4 4',
        'M5 13v6a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-6',
      ]);
    case LmIcons.search:
      return _combine([_circle(11, 11, 7), parseSvgPath('m21 21-4.3-4.3')]);
    case LmIcons.calendar:
      return _combine([
        _rrect(3.5, 5, 17, 16, 2),
        parseSvgPath('M3.5 9.5h17M8 3v4M16 3v4'),
      ]);
    case LmIcons.plus:
      return _paths(['M12 5v14M5 12h14']);
    case LmIcons.chevR:
      return _paths(['m9 5 7 7-7 7']);
    case LmIcons.chevL:
      return _paths(['m15 5-7 7 7 7']);
    case LmIcons.chevD:
      return _paths(['m5 9 7 7 7-7']);
    case LmIcons.close:
      return _paths(['M6 6l12 12M18 6 6 18']);
    case LmIcons.check:
      return _paths(['m4 12 5 5L20 6']);
    case LmIcons.edit:
      return _paths(['M4 20h4L19 9l-4-4L4 16v4z', 'm14 6 4 4']);
    case LmIcons.trash:
      return _paths(['M4 7h16M9 7V4h6v3M6 7l1 13h10l1-13']);
    case LmIcons.mood:
      return _combine([
        _circle(12, 12, 9),
        parseSvgPath('M8.5 14.5s1.3 2 3.5 2 3.5-2 3.5-2'),
        parseSvgPath('M9 9.5h.01M15 9.5h.01'),
      ]);
    case LmIcons.clock:
      return _combine([_circle(12, 12, 9), parseSvgPath('M12 7v5l3.5 2')]);
    case LmIcons.drop:
      return _paths(['M12 3s6 6.5 6 11a6 6 0 0 1-12 0c0-4.5 6-11 6-11z']);
    case LmIcons.screen:
      return _combine([
        _rrect(6, 2.5, 12, 19, 2.5),
        parseSvgPath('M10.5 18.5h3'),
      ]);
    case LmIcons.dumbbell:
      return _paths(['M6.5 8v8M3.5 9.5v5M17.5 8v8M20.5 9.5v5M6.5 12h11']);
    case LmIcons.star:
      return _paths([
        'm12 3 2.6 6.3 6.8.5-5.2 4.4 1.6 6.6L12 17.7 6.2 21.3l1.6-6.6L2.6 9.8l6.8-.5L12 3z',
      ]);
    case LmIcons.flag:
      return _paths(['M5 21V4M5 4h11l-2 4 2 4H5']);
    case LmIcons.pin:
      return _combine([
        parseSvgPath('M12 21s7-5.5 7-11a7 7 0 1 0-14 0c0 5.5 7 11 7 11z'),
        _circle(12, 10, 2.5),
      ]);
    case LmIcons.arrowR:
      return _paths(['M5 12h14M13 6l6 6-6 6']);
    case LmIcons.filter:
      return _paths(['M3 5h18l-7 8v6l-4 2v-8L3 5z']);
    case LmIcons.dots:
      return _combine([
        _circle(5, 12, 1.4),
        _circle(12, 12, 1.4),
        _circle(19, 12, 1.4),
      ]);
    case LmIcons.sun:
      return _combine([
        _circle(12, 12, 4),
        parseSvgPath(
          'M12 2v2M12 20v2M2 12h2M20 12h2M5 5l1.5 1.5M17.5 17.5 19 19M19 5l-1.5 1.5M6.5 17.5 5 19',
        ),
      ]);
  }
}

// ── Primitive builders ──────────────────────────────────────────────
Path _paths(List<String> ds) => _combine(ds.map(parseSvgPath).toList());

Path _combine(List<Path> parts) {
  final p = Path();
  for (final part in parts) {
    p.addPath(part, Offset.zero);
  }
  return p;
}

Path _circle(double cx, double cy, double r) =>
    Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));

Path _rrect(double l, double t, double w, double h, double r) => Path()
  ..addRRect(
    RRect.fromRectAndRadius(Rect.fromLTWH(l, t, w, h), Radius.circular(r)),
  );

Path _transform(Path p, Float64List m) => p.transform(m);

/// Column-major 4×4 matrix for the 2D affine
/// `x' = a·x + c·y + e`, `y' = b·x + d·y + f`.
Float64List _affine(
    double a, double b, double c, double d, double e, double f) {
  final m = Float64List(16);
  m[0] = a; m[1] = b; m[4] = c; m[5] = d; m[10] = 1; m[12] = e; m[13] = f;
  m[15] = 1;
  return m;
}

/// Affine for rotating [deg] degrees about point ([px], [py]).
Float64List _rotateAbout(double deg, double px, double py) {
  final t = deg * math.pi / 180.0;
  final cos = math.cos(t), sin = math.sin(t);
  // R·(p − c) + c  ⇒  e = c − R·c
  final e = px - cos * px + sin * py;
  final f = py - sin * px - cos * py;
  return _affine(cos, sin, -sin, cos, e, f);
}

// ── Minimal SVG path-data parser ────────────────────────────────────
// Supports M m L l H h V v C c S s Q q T t A a Z z (the commands used by the
// icon set). Maps arcs to Path.arcToPoint and tracks the last control point
// for smooth-curve reflection.

/// Parses an SVG path `d` string into a Flutter [Path] (24-unit space).
Path parseSvgPath(String d) {
  final p = Path();
  final sc = _Scanner(d);
  double cx = 0, cy = 0, sx = 0, sy = 0;
  double lastCx = 0, lastCy = 0; // last cubic/quad control point
  String cmd = '';
  String prev = '';

  while (true) {
    sc.skipSep();
    if (sc.atEnd) break;
    if (sc.peekIsLetter) {
      cmd = sc.readChar();
    } else {
      if (cmd.isEmpty) break;
      if (cmd == 'M') cmd = 'L';
      if (cmd == 'm') cmd = 'l';
    }
    switch (cmd) {
      case 'M':
        cx = sc.num_(); cy = sc.num_(); p.moveTo(cx, cy); sx = cx; sy = cy;
      case 'm':
        cx += sc.num_(); cy += sc.num_(); p.moveTo(cx, cy); sx = cx; sy = cy;
      case 'L':
        cx = sc.num_(); cy = sc.num_(); p.lineTo(cx, cy);
      case 'l':
        cx += sc.num_(); cy += sc.num_(); p.lineTo(cx, cy);
      case 'H':
        cx = sc.num_(); p.lineTo(cx, cy);
      case 'h':
        cx += sc.num_(); p.lineTo(cx, cy);
      case 'V':
        cy = sc.num_(); p.lineTo(cx, cy);
      case 'v':
        cy += sc.num_(); p.lineTo(cx, cy);
      case 'C':
        final x1 = sc.num_(), y1 = sc.num_(), x2 = sc.num_(), y2 = sc.num_();
        final x = sc.num_(), y = sc.num_();
        p.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2; lastCy = y2; cx = x; cy = y;
      case 'c':
        final x1 = cx + sc.num_(), y1 = cy + sc.num_();
        final x2 = cx + sc.num_(), y2 = cy + sc.num_();
        final x = cx + sc.num_(), y = cy + sc.num_();
        p.cubicTo(x1, y1, x2, y2, x, y);
        lastCx = x2; lastCy = y2; cx = x; cy = y;
      case 'S':
        final (rx, ry) = _reflect(prev, cx, cy, lastCx, lastCy);
        final x2 = sc.num_(), y2 = sc.num_(), x = sc.num_(), y = sc.num_();
        p.cubicTo(rx, ry, x2, y2, x, y);
        lastCx = x2; lastCy = y2; cx = x; cy = y;
      case 's':
        final (rx, ry) = _reflect(prev, cx, cy, lastCx, lastCy);
        final x2 = cx + sc.num_(), y2 = cy + sc.num_();
        final x = cx + sc.num_(), y = cy + sc.num_();
        p.cubicTo(rx, ry, x2, y2, x, y);
        lastCx = x2; lastCy = y2; cx = x; cy = y;
      case 'Q':
        final x1 = sc.num_(), y1 = sc.num_(), x = sc.num_(), y = sc.num_();
        p.quadraticBezierTo(x1, y1, x, y);
        lastCx = x1; lastCy = y1; cx = x; cy = y;
      case 'q':
        final x1 = cx + sc.num_(), y1 = cy + sc.num_();
        final x = cx + sc.num_(), y = cy + sc.num_();
        p.quadraticBezierTo(x1, y1, x, y);
        lastCx = x1; lastCy = y1; cx = x; cy = y;
      case 'T':
        final (rx, ry) = _reflect(prev, cx, cy, lastCx, lastCy);
        final x = sc.num_(), y = sc.num_();
        p.quadraticBezierTo(rx, ry, x, y);
        lastCx = rx; lastCy = ry; cx = x; cy = y;
      case 't':
        final (rx, ry) = _reflect(prev, cx, cy, lastCx, lastCy);
        final x = cx + sc.num_(), y = cy + sc.num_();
        p.quadraticBezierTo(rx, ry, x, y);
        lastCx = rx; lastCy = ry; cx = x; cy = y;
      case 'A':
        final rx = sc.num_(), ry = sc.num_(), rot = sc.num_();
        final large = sc.num_() != 0, sweep = sc.num_() != 0;
        final x = sc.num_(), y = sc.num_();
        p.arcToPoint(Offset(x, y),
            radius: Radius.elliptical(rx, ry),
            rotation: rot, largeArc: large, clockwise: sweep);
        cx = x; cy = y;
      case 'a':
        final rx = sc.num_(), ry = sc.num_(), rot = sc.num_();
        final large = sc.num_() != 0, sweep = sc.num_() != 0;
        final x = cx + sc.num_(), y = cy + sc.num_();
        p.arcToPoint(Offset(x, y),
            radius: Radius.elliptical(rx, ry),
            rotation: rot, largeArc: large, clockwise: sweep);
        cx = x; cy = y;
      case 'Z':
      case 'z':
        p.close(); cx = sx; cy = sy;
    }
    prev = cmd;
  }
  return p;
}

/// Reflection of the last control point about the current point (for S/T),
/// or the current point itself if the previous command was not a curve.
(double, double) _reflect(
    String prev, double cx, double cy, double lcx, double lcy) {
  const curves = {'C', 'c', 'S', 's', 'Q', 'q', 'T', 't'};
  if (curves.contains(prev)) return (2 * cx - lcx, 2 * cy - lcy);
  return (cx, cy);
}

/// Tiny number/command scanner for SVG path data.
class _Scanner {
  _Scanner(this.s);
  final String s;
  int i = 0;

  bool get atEnd => i >= s.length;

  void skipSep() {
    while (i < s.length) {
      final c = s.codeUnitAt(i);
      if (c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D || c == 0x2C) {
        i++; // space, tab, LF, CR, comma
      } else {
        break;
      }
    }
  }

  bool get peekIsLetter {
    if (atEnd) return false;
    final c = s.codeUnitAt(i);
    return (c >= 0x41 && c <= 0x5A) || (c >= 0x61 && c <= 0x7A);
  }

  String readChar() => s[i++];

  /// Reads one number, skipping leading separators. Handles signs, decimals,
  /// consecutive decimals ("1.5.4"), and exponents.
  double num_() {
    skipSep();
    final start = i;
    if (i < s.length && (s[i] == '+' || s[i] == '-')) i++;
    var sawDot = false;
    while (i < s.length) {
      final ch = s[i];
      if (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39) {
        i++;
      } else if (ch == '.' && !sawDot) {
        sawDot = true;
        i++;
      } else if ((ch == 'e' || ch == 'E') && i + 1 < s.length) {
        i++;
        if (s[i] == '+' || s[i] == '-') i++;
      } else {
        break;
      }
    }
    return double.parse(s.substring(start, i));
  }
}
