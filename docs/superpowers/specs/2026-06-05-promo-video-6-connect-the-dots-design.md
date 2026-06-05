# Promo Video #6 — "Connect the Dots" (B-roll-led short film)

**Date:** 2026-06-05
**Type:** Promo video (TikTok/Reels/Shorts), the emotional/story entry in the series
**Status:** Design approved — ready for implementation plan

---

## 1. Why this video

The series so far has been **app-forward**: every video either opens on the app or
keeps a phone-mock on screen throughout (#1 breadth, #2 narrative, #3 insight, #4 AI,
#5 builder explainer). That framing is also the *generic* productivity-app-promo
framing — and the backlog ideas (deleted-7-apps, listicle, ASMR) are well-worn tropes.

This video deliberately breaks the pattern. It is a **B-roll-led short film** where the
app does not appear until the final beat. The story carries the viewer; the app arrives
as the *answer* to the story, not its subject. This is the most distinctive cut in the
series and the hardest to mistake for a templated app ad.

It is built on the one thing **no competitor can show**: LifeMaxxing is the only place a
user's mood and their workouts live in the same database, so it can reveal a cross-domain
truth a single-purpose app cannot. The story dramatizes that moat instead of asserting it.

## 2. Decisions (locked during brainstorming)

| Dimension | Decision | Rationale |
|---|---|---|
| **Angle** | "Connect the dots" — a cross-domain personal revelation | Weaponizes the real moat (one app holds mood + workouts); untested in the series. |
| **Tone** | Wonder / uplift | A vague feeling becomes a happy *fact*. Avoids the generic health-scare register; the moat reads as a gift. |
| **Who connects the dots** | You + the app (no AI) | Intimate, personal. Deliberately differentiates from #4's AI-verdict video; keeps the app's role to the single payoff beat. |
| **Format** | **B-roll-led short film**; app appears only at the reveal (beat 5) | The user's explicit direction: don't open on the app; mostly B-roll; mention the app at the end. The biggest format break in the series. |
| **The true story** | Mood is measurably higher on training days | Grounded in the real seed ("avg mood 7.5, higher on training days"). Real data underneath; only the *visualization of the link* is constructed. |
| **Length** | ~16–18s | Short scroll-stopper; max contrast with #5's 51s explainer. |
| **Voice** | edge-tts `en-US-AndrewNeural`, **calmer rate `+4%`**, sparse | Ships today, consistent with the series; slower so the wonder lands. |
| **B-roll source** | Free, **no API key** — source by hand | The user declined a Pexels API key. Pull the best free footage from no-key sources (see §5). |
| **Beat 4 ("the doubt")** | Kept | A one-breath dip so the reveal lands harder. Cuttable to a ~15s purely-positive cut if it reads wrong in the contact sheet. |

Format specs (unchanged from the series): **1080×1920, 9:16, 30 fps, H.264 + AAC**,
English VO + captions. The app UI visible in the reveal beat is Bulgarian (as shipped).

## 3. Concept

A ~17s film in one emotional arc:

> A guy *felt* like he was happier on the days he trained — but couldn't prove it.
> Then he realized his own app had quietly proven it: every mood peak landed on a
> training day. He didn't need an expert; his own life told him what makes him happy.

Beats 1–4 are **100% real footage, no app, no phone** (~12s): ordinary days → the days
he moved → feeling lighter → *but was it real?* The app appears **once**, at beat 5, as
the proof. Endcard at beat 6.

```
0s ─────────────────────────────────────────────────── ~17s
[ B-roll story (no app)                          ][ APP ][ end ]
  ordinary → movement → joy → doubt                reveal  CTA
  cool/muted  warm bloom  warmest   pull back      resolve
```

## 4. Beat sheet (~17s)

| # | Time | Visual | VO (Andrew, `+4%`, sparse) | Caption | Grade / music |
|---|------|--------|----------------------------|---------|---------------|
| 1 | 0:00–0:03 | **B-roll only** — quiet ordinary moments: coffee cooling by a grey window, sitting still, dull morning | "Some days I felt great. Some days… just flat. I never knew why." | *(none)* | Cool, muted. Music sparse. |
| 2 | 0:03–0:07 | **B-roll only** — movement: running at golden hour, gym, a hard walk, breath, sweat | "Then I noticed something — on the days I trained…" | *(none)* | Warm bloom in. Music rises. |
| 3 | 0:07–0:10 | **B-roll only** — the good part: sunlight, a real smile, water after effort, ease | "…I felt lighter. Clearer. Happier. Every time." | *(none)* | Warmest. Music swells. |
| 4 | 0:10–0:12 | **B-roll only** — one held, quiet still; a pause | "But was it real? …or just in my head?" | *(none)* | Music pulls back one breath. |
| 5 | 0:12–0:15 | **Phone rises into frame (app's only appearance)** — mood trend; happy-day peaks light **green**, landing on training days; "dots connect" animation | "Turns out… I'd been keeping track. Every peak — a day I trained." | "Higher mood on training days." (green, after the reveal) | Resolve to a bright major chord. |
| 6 | 0:15–0:17 | **Endcard** — icon + "LifeMaxxing" + green **DOWNLOAD NOW** | "I didn't need an expert to tell me what makes me happy. My own life did." | LifeMaxxing · **DOWNLOAD NOW** | Warm, resolved. |

**Timing-to-VO:** generate each phrase, measure its duration, set each beat to fit its
phrase (+~0.3s headroom) per the `promo/VIDEOS.md` §3 recipe. Table times are targets; the
final cut times to the VO, so beats may shift ±0.5s. Beat 6's CTA only needs to *hold* —
the VO outro finishes inside it (the #5 "trim dead air" lesson).

## 5. Assets

### B-roll (beats 1–4, and the bg fill behind the phone in beat 5) — the core asset
This video lives or dies on footage. **No API key** (user's call), so source by hand,
preferring no-key sources that give the highest resolution available:

- **Mixkit** (`mixkit.co/free-stock-video/`) — direct full-res `.mp4` downloads, no login.
- **Coverr** (`coverr.co`) — free direct downloads, no login.
- **Pexels** video pages — expose download links (page scrape; no key needed for the
  page's own download URLs).
- **Pixabay `_tiny.mp4`** — graded fallback only (`promo/VIDEOS.md` §4 method), used
  blurred or behind the phone, not as a sharp hero shot.

Queries per beat:
- B1 (ordinary): `coffee window morning`, `tired desk`, `rainy window`, `slow morning`.
- B2 (movement): `running sunrise`, `gym workout`, `trail run`, `lifting weights`.
- B3 (joy/light): `smile sunlight`, `drinking water workout`, `stretching morning sun`.
- B4 (doubt/still): `pensive window`, `quiet portrait`, `still thinking`.

**Grade for consistency & arc:** beats 1 & 4 cool/desaturated
(`eq=brightness=-0.05:saturation=0.78`, slight `vignette`); beats 2–3 warm
(`eq=brightness=0.04:saturation=1.08` + a warm tone curve / light bloom). Hero footage is
shown **sharp** (light or no blur) — unlike the series' usual heavy `gblur=sigma=26`
background blur. Keep cuts short (1.5–2.5s) so it reads as a film, not stock. **Grade-test
one frame per beat before building** (the #5 gate). If a sharp `_tiny` clip looks cheap,
swap source or fall back to a tighter crop + light grain.

### App reveal screen (beat 5)
The mood-trend screen with the seeded "Martin" data. Capture via
`adb exec-out screencap -p` after re-seeding (`promo/VIDEOS.md` §4 — More → Dev →
Данни → "Зареди примерни данни"). The app has **no built-in cross-module chart** that
overlays mood on workouts, so:
- Capture the real **mood trend / MoodGauge** screen (the data is real).
- The "dots connect" moment is built **in the edit**: animate markers/dots dropping onto
  the peak (training-day) positions and lighting green — an overlay on the real chart,
  same spirit as #4's red/green reveals. This is the signature creative moment.
- Pick the screen that *proves* the caption (the #5 "match stat to a screen" lesson):
  use the screen whose data actually shows the high-mood days.

### Phone mockup (beat 5)
Reuse `promo/v2/work/phone_body.png` + `screen_mask.png` (the no-hand mock). App screen →
crop/scale → `alphamerge` with mask → `overlay` onto body → rise into frame over a soft
blurred fill. (Per `promo/VIDEOS.md` §4 phone-mock convention.)

### Brand / shared
- Icon: `src/assets/branding/icon-1024.png`. CTA: green `#5FD08A`, "DOWNLOAD NOW",
  card bg `#0C0D11`. Caption accent for the reveal: green `0x5FD08A`.
- Overlay font: `C:/Windows/Fonts/arialbd.ttf`.

### Voice & music
- VO: `edge-tts en-US-AndrewNeural --rate=+4%`, per phrase, placed with `adelay`, then
  `loudnorm I=-16`. Six short phrases (one per beat). Sparse — let the footage breathe.
- Music: synth bed (`make_music*.py`) sized to ~17s, written to **rise across beats 2–3
  and resolve to a major chord on beat 5** (the emotional arc lives in the music as much
  as the VO). Keep low under VO (vol ~0.28). Reusing `music_v2.wav` is a fallback but its
  Am–F–C–G loop doesn't carry the build → resolve; prefer a purpose-built bed.

## 6. Production layout

New per-video directory `promo/v6/` mirroring #2–#5:
- `promo/v6/work/` — B-roll downloads, graded clips, app capture, VO phrases, segments,
  contact sheet.
- `promo/v6/out/` — `v6_silent.mp4`, `v6_final.mp4`.
- `promo/v6/render_v6.sh` — grade + assemble each B-roll beat, build the phone-mock reveal
  with the dots-connect overlay, concat → silent cut.
- `promo/v6/mux_v6.sh` — mux VO phrases at cues + music under → loudnorm.
- `promo/v6/make_music_v6.py` — purpose-built rise→resolve bed.

ffmpeg: `promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe`.

## 7. Verification

Per the `promo/VIDEOS.md` §3 recipe step 10: build a **1-fps contact sheet** of
`v6_final.mp4`, eyeball every beat (B-roll grade consistency + arc cool→warm→resolve,
footage doesn't read cheap, the dots-connect overlay reads clearly, phone-mock alignment,
endcard, caption legibility), confirm duration is ~16–18s and format is 1080×1920 / 30 fps
/ h264+aac (probe with `ffprobe`), then `Invoke-Item` to open. Captions: avoid literal `%`
and Unicode arrows in `drawtext` (§4 gotchas); the reveal caption sits clear of the phone.

## 8. Log on completion

Add a row to `promo/VIDEOS.md` §1 (title "Connect the Dots", angle = emotional/story,
format = B-roll-led + single phone-mock reveal, length, status, output path), add the
`promo/v6/` build scripts to the per-video scripts list, mark the "connect the dots /
cross-domain" idea used, and write a short "what worked / what to try next" note. The
B-roll-led (no-app-until-the-end) format and the edit-built cross-module reveal are both
new — capture how they landed.

## 9. Risks & open items

- **Free no-key B-roll looks cheap when shown sharp.** This is the central risk of a
  footage-led video without HD sourcing. Mitigations: prefer Mixkit/Coverr/Pexels HD over
  Pixabay `_tiny`; grade for mood; tight crops; short cuts; light grain. The grade-test-one-
  frame gate runs *before* building beats — if no beat's footage survives it, fall back to
  the phone-mock-over-blurred-B-roll formula (where low-res is hidden) and re-scope.
- **Footage that doesn't match the story.** Generic stock can read as "an ad" not "his
  life." Pick intimate, specific, single-subject shots over wide glossy ones (the #5
  bookend lesson).
- **The dots-connect overlay over-promises a feature.** The app doesn't actually overlay
  mood on workouts. The caption ("higher mood on training days") states the real finding;
  the overlay visualizes the real data. Keep it honest — no fake UI chrome implying a
  screen that doesn't exist; it reads as a data viz of his own numbers.
- **Tone whiplash.** Beat 4's dip must be one breath, not a downer. If the contact sheet
  feels heavy, cut beat 4 (3 → 5) for a ~15s purely-positive version.
- **Stale app capture.** Re-seed + re-capture the mood screen; don't assume an old
  `promo/work/*.png` is current.
- **Runtime.** Six VO lines timed to phrase length should sit ~16–18s; if it creeps, tighten
  beats 1–4 and let beat 6 hold shorter.
