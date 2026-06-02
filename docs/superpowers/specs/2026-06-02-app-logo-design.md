# LifeMaxxing logo & app icon — design

**Date:** 2026-06-02
**Status:** Approved (visual + asset pipeline)

## 1. Purpose

LifeMaxxing has no brand mark or app launcher icon yet (Android currently ships
Flutter's default). This spec defines a single mark, an Android launcher icon
built from it, and an in-app symbol widget — all derived from the existing design
tokens so the identity is consistent with the app.

## 2. The mark — "Ascent"

A four-point **upward trend line** that rises left→right and terminates in an
up-arrow head. It reads as measured, upward progress ("maxxing") and as a
data/tracking app at a glance.

- **Geometry (96×96 canvas):** polyline `26,64 → 40,52 → 50,58 → 68,34`, with an
  arrow head at the top-right: `M56 34 H68 V46`.
- **Stroke:** width 6.5 (icon) / 7 (standalone symbol), `stroke-linecap` and
  `stroke-linejoin` both `round`.
- **Color:** linear gradient along the line, bottom-left → top-right,
  `#6AA8FF` (accent blue) → `#5FD08A` (green). The arrow head is solid `#5FD08A`.

## 3. The app icon

The mark on the app's hero-blue gradient in a rounded square.

- **Background:** 135° linear gradient `#1A2435` (`AppGradients.heroBlueStart`) →
  `#14161D` (`heroBlueEnd`).
- **Shape:** rounded square, corner radius 22 on the 96 canvas (≈23%), matching the
  app's generous radii. Android adaptive-icon safe zone respected (mark sits well
  inside the inner 66% circle).
- **Border:** hairline `#21FFFFFF` (~13% white, `AppColors.borderHi`) — the same
  edge treatment used on cards. Optional; dropped on adaptive foreground layers
  where the OS masks the shape.

## 4. The standalone symbol

The bare mark with **no background**, for in-app placement (splash, screen
headers, the About/settings screen). Stroke width 7. Lives in Flutter as an
`LmLogo` widget (see §6).

## 5. Color tokens (already in `lib/core/theme/tokens.dart`)

| Role | Token | Hex |
|---|---|---|
| Line start | `AppColors.accent` | `#6AA8FF` |
| Line end / arrow | `AppColors.green` | `#5FD08A` |
| Icon bg start | `AppGradients.heroBlueStart` | `#1A2435` |
| Icon bg end | `AppGradients.heroBlueEnd` | `#14161D` |
| Border | `AppColors.borderHi` | `#21FFFFFF` |

The mark introduces **no new colors**.

## 6. Deliverables

1. **Master SVG** — `assets/branding/logo.svg` (icon, with background) and
   `assets/branding/symbol.svg` (bare mark). Source of truth; committed.
2. **1024×1024 master PNGs** — rendered from the SVGs, inputs to the generator:
   - `assets/branding/icon-1024.png` — full icon (mark on gradient), for the
     legacy square/round mipmaps.
   - `assets/branding/icon-fg-1024.png` — the mark only, transparent background,
     centered within the adaptive-icon safe zone (adaptive foreground layer).
   - `assets/branding/icon-bg-1024.png` — the hero-blue gradient fill (adaptive
     background layer).
3. **Android launcher icons** — generated via `flutter_launcher_icons`:
   - Legacy mipmap PNGs `mdpi(48)/hdpi(72)/xhdpi(96)/xxhdpi(144)/xxxhdpi(192)`.
   - Adaptive icon (API 26+): foreground = the mark, background = the hero-blue
     gradient (rendered to the background layer; adaptive backgrounds can't be a
     live gradient drawable via the tool, so the background is supplied as an
     image layer).
   - Play Store 512×512 (the 1024 master downscales as needed).
4. **`LmLogo` widget** — `lib/core/widgets/lm_logo.dart`, a `CustomPaint` that
   draws the mark (and optionally the rounded-square background). No `flutter_svg`
   dependency (not in the locked set); the path is reproduced in a `CustomPainter`.
   Variants: `LmLogo.symbol()` (bare) and `LmLogo.icon()` (with background).

## 7. Asset pipeline (approved decision)

Use **`flutter_launcher_icons`** as a `dev_dependency`. This is a new dependency;
it was explicitly approved during brainstorming, satisfying the CLAUDE.md §4/§6
"raise new deps first" rule. Configuration goes in `pubspec.yaml` (or
`flutter_launcher_icons.yaml`):

```yaml
flutter_launcher_icons:
  android: true
  ios: false                      # Android-only per locked decisions
  image_path: "assets/branding/icon-1024.png"
  adaptive_icon_background: "assets/branding/icon-bg-1024.png"
  adaptive_icon_foreground: "assets/branding/icon-fg-1024.png"
  min_sdk_android: 24
```

Run: `dart run flutter_launcher_icons`. Generated mipmaps are committed.

## 8. Master SVG (source of truth)

**Icon** (`logo.svg`):

```svg
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 96 96" width="96" height="96">
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0" stop-color="#1A2435"/><stop offset="1" stop-color="#14161D"/>
    </linearGradient>
    <linearGradient id="ln" x1="0" y1="1" x2="1" y2="0">
      <stop offset="0" stop-color="#6AA8FF"/><stop offset="1" stop-color="#5FD08A"/>
    </linearGradient>
  </defs>
  <rect x="6" y="6" width="84" height="84" rx="22" fill="url(#bg)" stroke="#21FFFFFF" stroke-width="1"/>
  <polyline points="26,64 40,52 50,58 68,34" fill="none" stroke="url(#ln)"
            stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M56 34 H68 V46" fill="none" stroke="#5FD08A"
        stroke-width="6.5" stroke-linecap="round" stroke-linejoin="round"/>
</svg>
```

**Symbol** (`symbol.svg`): identical line + arrow, no `<rect>`, scaled to fill the
canvas with stroke-width 7.

## 9. Verification

- `assets/branding/` files exist and are referenced in `pubspec.yaml` assets.
- `dart run flutter_launcher_icons` completes; `android/app/src/main/res/mipmap-*`
  contains the generated PNGs and the device home screen shows the new icon.
- `flutter analyze` is clean; an `LmLogo` widget test renders both variants without
  error and golden-matches (or at least pumps) at icon and symbol sizes.
- The icon is legible at 48px (mdpi) — the small-size check passed in design.

## 10. Out of scope

- iOS icons (no iOS build config yet, per locked decisions).
- Animated splash / Lottie.
- A text wordmark lockup ("LifeMaxxing" set in type) — symbol + icon only for now.
