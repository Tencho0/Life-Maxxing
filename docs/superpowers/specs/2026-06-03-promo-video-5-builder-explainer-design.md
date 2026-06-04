# Promo Video #5 — "I Built an App to Track My Entire Life" (Builder Explainer)

**Date:** 2026-06-03
**Type:** Promo video (TikTok/Reels/Shorts), the explainer entry in the series
**Status:** Design approved — ready for implementation plan

---

## 1. Why this video

The series so far is four short scroll-stoppers (15–23s): a breadth hook (#1), a
narrative (#2), an insight (#3, best so far), and an AI/utility dramatization (#4).
None of them actually **explain what LifeMaxxing is** to a first-time viewer. This is
the explainer — it educates rather than just stops the scroll, and it earns a longer
runtime and its own format.

It's framed as a **builder story** (first person), which the idea backlog
(`promo/VIDEOS.md` §2) flags as one of the two strongest untested angles and which
rides #buildinpublic.

## 2. Decisions (locked during brainstorming)

| Dimension | Decision | Rationale |
|---|---|---|
| **Length** | ~53s (target 45–60s) | Room for ~6–8 beats with real screens; still holds on feed. |
| **Angle** | Builder story, first person | Authenticity + #buildinpublic; untested in the series. |
| **Voice** | edge-tts `en-US-AndrewNeural`, first person | Ships today, consistent with the series, no recording needed. |
| **Module coverage** | All ~9 modules, even beats | Breadth-first: "look how much it tracks." Threaded by builder VO so it reads as a tour, not a manual. |
| **Visual format** | C — desk/builder B-roll bookends, full-frame app tour in the middle | Personal bookends + big legible module screens for a fast breadth sweep. Phone-mock reserved for the AI payoff (reuse #4). |

Format specs (unchanged from the series): **1080×1920, 9:16, 30 fps, H.264 + AAC**,
English VO + captions, Bulgarian app UI visible on screen.

## 3. Concept

A founder's tour in four movements:

1. **The why** — builder at his desk: "I wanted to remember my whole life, so I built this."
2. **The what** — a fast, full-frame sweep through everything the app captures (9 modules).
3. **The so-what** — export it all and let AI find what you're missing (the real "Export for AI" feature; reuses #4's payoff beat).
4. **The close** — back at the desk, name + green CTA.

The desk bookends carry the personal/founder feel; the full-frame middle keeps the
breadth legible and fast.

## 4. Beat sheet (~53s)

| # | Time | Visual | VO (first person) | Caption | Accent |
|---|------|--------|-------------------|---------|--------|
| 1 | 0:00–0:05 | **Desk B-roll** — hands typing, code on screen, coffee, warm light (graded dark) | "I wanted to remember my whole life. So I built an app for it." | I built an app to track my entire life | white |
| 2 | 0:05–0:09 | Cut to **app home** full-frame, zoom-punch | "Everything that matters — in one place. Fully offline, no account." | One app. Everything. Offline. | white |
| 3 | 0:09–0:12 | **Food** | "I log what I eat…" | FOOD | amber `0xF5C36B` |
| 4 | 0:12–0:15 | **Money** / spending chart | "…and where the money goes. Turns out 47% went to food." | MONEY — 47% on food | green `0x5FD08A` |
| 5 | 0:15–0:18 | **Health** | "Blood pressure, meds, lab results." | HEALTH — avg 127/78 | pink `0xFF9EC4` |
| 6 | 0:18–0:21 | **Steps** | "Every step." | STEPS — 294,399 in 30 days | purple `0xC9A8FF` |
| 7 | 0:21–0:24 | **Activities/workouts** | "Every workout." | TRAINING — 25 sessions, 38h | blue `0x6AA8FF` |
| 8 | 0:24–0:27 | **Daily log** | "A quick daily check-in, and my mood." | DAILY LOG — mood 7.5 | white |
| 9 | 0:27–0:30 | **Diary** (photos) | "A visual diary of the moments." | DIARY | white |
| 10 | 0:30–0:33 | **Bucket list** | "The things I still want to do." | BUCKET LIST | green |
| 11 | 0:33–0:36 | **Trips** | "And every trip I take." | TRIPS | blue |
| 12 | 0:36–0:43 | **Phone-mock** export → **AI card** (reuse #4 assets) | "Then I export all of it, and let AI tell me what I'm missing." | Export → ask any AI | white |
| 13 | 0:43–0:53 | Back to **desk B-roll** → **endcard** (icon + name + green button) | "It's called LifeMaxxing. I built it for me. Now it's yours too." | LifeMaxxing · **DOWNLOAD NOW** | green CTA |

**VO line count:** 13 short phrases (one per beat). Generate per phrase, measure each, set the beat
length to fit its phrase (+~0.3s headroom) — per the §3 recipe. The table times are the
target; the final cut is timing-to-VO, so individual beats may shift ±0.5s.

## 5. Assets

### App screens (full-frame, beats 2–11)
Reuse existing captures in `promo/work/` where current, else re-capture via
`adb exec-out screencap -p` after re-seeding (`promo/VIDEOS.md` §4). Candidates already
present: `home.png`, `food.png`, `charts.png`, `health.png`, `steps.png`,
`activities.png`, `dailylog.png`, `memories.png`/`memories2.png`, `bucket.png`,
`trips.png`/`trips2.png`. **Verify each looks current (seeded "Martin" data) before use;
re-seed + re-capture any stale ones.** Crop/scale per the §4 full-frame convention.

### Desk / builder B-roll (beats 1 & 13) — the new asset for this video
Source from Pixabay (`promo/VIDEOS.md` §4): queries like `programmer coding laptop`,
`developer desk coffee`, `typing keyboard macro`, `code screen night`. `_tiny.mp4` is
fine. **Grade consistently** to avoid the "stock-y" risk: dark + desaturated
(`eq=brightness=-0.15:saturation=0.7`), mild blur (`gblur=sigma=8` — lighter than the
heavy `sigma=26` background blur, since these are hero shots), accent vignette. Keep
each desk shot short (<2.5s) with 2–3 cuts so it reads as energy, not stock footage.

### AI payoff (beat 12)
Reuse #4's assets: phone-mock export beat + AI logo-chip card
(`promo/v4/work/`). White rounded chips for the AI logos (they're dark/mono). Nominative
trademark use — fine for organic posts (`promo/VIDEOS.md` §4 warning).

### Brand / shared
- Phone mockup: `promo/v2/work/phone_body.png` + `screen_mask.png`.
- Icon: `src/assets/branding/icon-1024.png`. CTA: green `#5FD08A`, "DOWNLOAD NOW", card bg `#0C0D11`.
- Font: `C:/Windows/Fonts/arialbd.ttf`.

### Voice & music
- VO: `edge-tts en-US-AndrewNeural --rate=+6%`, per phrase, placed with `adelay`, then `loudnorm I=-16`.
- Music: synth bed (`make_music*.py`) sized to ~53s, **or** reuse `promo/v2/work/music_v2.wav` (loop/trim to length). Keep low under VO (vol ~0.28).

## 6. Production layout

New per-video directory `promo/v5/` mirroring #2–#4:
- `promo/v5/work/` — captures, B-roll, VO phrases, segments, contact sheet.
- `promo/v5/out/` — `v5_silent.mp4`, `v5_final.mp4`.
- `promo/v5/render_v5.sh` — builds each beat + concat to silent cut.
- `promo/v5/mux_v5.sh` — muxes VO phrases at cues + music under → loudnorm.

ffmpeg: `promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe`.

## 7. Verification

Per the §3 recipe step 10: build a **1-fps contact sheet** of `v5_final.mp4`, eyeball
every beat (caption legibility, screen freshness, B-roll grade, phone-mock alignment,
endcard), confirm duration is in the 45–60s window and format is 1080×1920 / 30 fps /
h264+aac (probe with `ffprobe`), then `Invoke-Item` to open. Captions must clear the
phone when it's centered (top placement, `y=h*0.085`); avoid literal `%` and Unicode
arrows in `drawtext` (§4 gotchas — note caption #4 uses the word "47% on food"; render the
percent safely or reword to "nearly half").

## 8. Log on completion

Add a row to `promo/VIDEOS.md` §1 (title, angle = builder/explainer, format, length,
status, output path), add the `promo/v5/` build scripts to the per-video scripts list,
and write a short "what worked / what to try next" note. Builder story and the desk-B-roll
format are both new — capture how they landed.

## 9. Risks & open items

- **Desk B-roll looks stock-y** (the known risk of format C). Mitigation: consistent dark
  grade, short cuts, light blur. Fallback if the contact sheet looks bad: drop to a
  phone-mock-on-gradient open/close (no desk footage) and keep the builder VO.
- **9 even module beats can feel list-y.** Mitigation: the first-person VO threads them
  ("I log…", "…and where the money goes…") and stat captions give 5 of them a payoff.
- **Stale screen captures.** Several `promo/work/*.png` predate recent seed changes —
  must verify/re-capture before use, not assume.
- **Runtime creep.** 10 VO lines timed to phrase length could push past 60s. If so,
  tighten module beats toward 2.8s and trim desk bookends.
