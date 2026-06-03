# LifeMaxxing — Promo Video Playbook & History

This is the **single source of truth** for the TikTok/Reels promo series. It tracks
what each video was about, holds the production recipe, and lists ideas for what's next.

> **UI language note:** the app UI is Bulgarian; the promos use **English** voiceover +
> captions (international audience). A Bulgarian-localized cut is a future option.
> Format: **1080×1920, 9:16, 30 fps, H.264 + AAC.**

---

## 0. How to use this doc (the workflow)

When asked to make the next promo video:

1. **Suggest topics.** Read §1 (history) + §2 (idea backlog). Propose 2–3 topics that are
   *different in angle* from the last 1–2 videos (don't repeat breadth→narrative→insight
   back-to-back). Lead with a recommendation and say why.
2. **Pick a topic** (with the user, or pick the recommended one if they say "you choose").
3. **Build it** following the recipe in §3. You have **creative freedom** to experiment
   with transitions, B-roll, caption style, pacing, and new beats — as long as you respect
   the brand guardrails in §4. Pick the best frames, source fitting B-roll, write punchy
   captions, generate the VO, add music, **verify with a contact sheet, then open it.**
4. **Log it.** Add a new row to §1 and a short "what worked / what to try next" note.

---

## 1. Video history

| # | Title | Angle | Format | Len | Status | Output |
|---|-------|-------|--------|-----|--------|--------|
| 1 | **Track Your Entire Life** | Data-dopamine *breadth* — "you can track ALL of this" | Full-screen app stills, fast cuts, zoom-punch, charts climax | 15s | ✅ done | `promo/out/lifemaxxing_promo_v1_final.mp4` |
| 2 | **A Day in My Life** | *Narrative* — wake → log the whole day → it all adds up | Device-mockup (phone frame, **no hand**) on dark gradient; in-phone app motion (capture-sequence) | 20s | ✅ done | `promo/v2/out/v2_final.mp4` |
| 3 | **30 Days Taught Me** ⭐ | *Insight/outcome* — what the data revealed (4 real stats) | **Phone-mock floating over themed, blurred B-roll** + synced captions | 16s | ✅ done (best so far) | `promo/v3/out/v3_final.mp4` |
| 4 | **Let Your Favorite AI Analyze Your Life** | *AI/utility, dramatic* — export → ChatGPT/Claude/Gemini → **exposed my mistakes → fixes** (ties to the real "Export for AI" feature) | Phone-mock (hook + export) + **AI logo-chip row** + red **"3 MISTAKES FOUND"** reveal → green **"HOW TO FIX IT"** payoff | 19s | ✅ done | `promo/v4/out/v4_final.mp4` |

**#3's phone-mock-over-blurred-B-roll is the "winning formula"** — default to it unless the
angle calls for something else (e.g. #4's full-frame AI card). #4 proved a non-app "explainer"
beat (logo row, AI card) mixes cleanly with phone-mock beats.

Per-video build scripts (reusable, edit + re-run):
- **#1:** `promo/render.sh` · `promo/mux_vo.sh` · `promo/make_music.py`
- **#2:** `promo/v2/render_v2.sh` · `promo/v2/mux_v2.sh` · `promo/v2/make_music_v2.py`
- **#3:** `promo/v3/render_v3.sh` · `promo/v3/mux_v3.sh` (reuses #2's phone frame + music)
- **#4:** `promo/v4/render_v4.sh` · `promo/v4/mux_v4.sh` (reuses #2's phone frame + music_v2)

---

## 2. Idea backlog (pick the next topic from here)

Angles **not yet used** — each is a distinct hook type:

| Idea | Hook type | One-liner |
|------|-----------|-----------|
| **I deleted 7 apps** | Pain → relief | Cluttered phone of tracking apps collapses into one. Strongest scroll-stopper. (Need a mocked "messy phone" opener.) |
| **Builder story** | Personal/founder | "I built an app to track my whole life." Taps #buildinpublic; over-performs early. |
| **Feature spotlight** | Depth | Deep-dive ONE module end-to-end (log → chart → insight). High-intent for that use case. |
| **Private & offline** | Trust/values | "Your data is being sold — mine never leaves my phone." Topical. |
| **Oddly satisfying** | Aesthetic/ASMR | Logging taps + charts filling on a beat. No narrative, very re-watchable. |
| **You finally got it together** | Aspirational | "POV: your life, finally organized." Transformation vibe. |
| **5 things I track** | Listicle | Numbered value list; the number is the hook. |
| **Weekly review ritual** | Routine | "Every Sunday I review my week in 2 minutes." |
| **New Year / seasonal** | Timely | "Track your 2026." Strong in Dec–Jan. |

**Heuristic for choosing:** maximize contrast with the last video's *angle* and *hook type*.
Rotate format too (full-screen ↔ phone-mock ↔ B-roll-heavy). When unsure, the **pain hook
("deleted 7 apps")** and the **builder story** are the two strongest untested angles.

---

## 3. The recipe (how #3 was made — the winning formula)

**Concept → ~15–18s, English VO, phone-mock over blurred themed B-roll, synced captions.**

### Pipeline
1. **Plan beats.** Hook + 3–4 insight/story beats + endcard. Each beat = one app screen +
   one B-roll theme + one caption + one VO line. Ground any numbers in the real seeded data.
2. **Get app screens** (`adb exec-out screencap -p`). Re-seed first if the data looks stale
   (see §4). For in-app *motion*, use the **capture-sequence** trick (§4), not screenrecord.
3. **Source B-roll** per beat from Pixabay (§4) — themed to each insight (food→cooking,
   steps→walking, training→gym, etc.). Low-res `_tiny.mp4` is fine; it gets blurred.
4. **Write + generate VO** (edge-tts Andrew, §4). Measure each phrase's duration; set each
   beat's length to fit its phrase (+~0.3s headroom).
5. **Build each beat** (`make_insight` in `render_v3.sh`):
   blurred+darkened B-roll bg → app screen rounded into the phone frame → float centered →
   gentle push-in (zoompan 1.03→1.08) → color-coded caption (top, fade in/out).
6. **Endcard:** icon + "LifeMaxxing" + green **DOWNLOAD NOW** button (fade in).
7. **Concat** beats → silent cut.
8. **Music:** synth bed (`make_music*.py`) or reuse `promo/v2/work/music_v2.wav`.
9. **Mux** VO phrases at their cues (`adelay`) + music under (vol ~0.28, ducked by being
   low) → `loudnorm I=-16:TP=-1.5`.
10. **Verify:** build a 1-fps contact sheet, eyeball every beat, then `Invoke-Item` to open.

### Creative freedom (encouraged)
Try: whip-pans/crossfades between beats, a count-up number animation, a B-roll-only punch
shot, a different VO voice (Brian/Guy), beat-synced zoom-punches, a parallax on the B-roll.
Keep the **brand guardrails** (§4): phone-mock identity, accent colors, icon, green CTA,
9:16, English VO. If an experiment doesn't look good in the contact sheet, fall back.

---

## 4. Shared conventions, assets & gotchas

### Brand
- **Icon:** `src/assets/branding/icon-1024.png` (blue→green upward arrow). **Name:** `LifeMaxxing`.
- **CTA:** green button `#5FD08A`, text `DOWNLOAD NOW`. Card bg `#0C0D11`.
- **Module accent colors** (use for captions per topic): food/amber `0xF5C36B`,
  money/green `0x5FD08A`, workouts/blue `0x6AA8FF`, steps/purple `0xC9A8FF`,
  health/pink `0xFF9EC4`, neutral white `0xFFFFFF`.
- **Overlay font:** `C:/Windows/Fonts/arialbd.ttf` (Arial Bold).

### Brand logos (e.g. AI chatbots — video #4)
- **Source:** Wikimedia Commons rasterizes SVGs to PNG via the width param —
  `curl -L "https://commons.wikimedia.org/wiki/Special:FilePath/<File.svg>?width=400" -o logo.png`
  (e.g. `ChatGPT-Logo.svg`, `Claude_AI_logo.svg`, `Google_Gemini_logo.svg`).
- Many logos are dark/mono → **invisible on dark bg**. Put each on a **white rounded chip**
  (PIL) so they all read. Space chips so they don't overlap (e.g. x=60/390/720 for 300px chips).
- **⚠️ Trademark:** third-party logos in a promo are *nominative use* ("works with"). Fine for
  organic/personal posts; for paid/scaled ads, review each brand's logo guidelines or use
  neutral "AI" iconography instead.

### Phone mockup (no hand)
- `promo/v2/work/phone_body.png` (660×1304 rounded bezel) + `promo/v2/work/screen_mask.png`
  (620×1264 rounded mask). Regenerate via PIL if needed (`rounded_rectangle`).
- App screen → `crop=1280:2610:0:123,scale=620:1264` → `format=rgba` + `alphamerge` with the
  mask → `overlay=20:20` onto the body → float on bg (gradient or blurred B-roll).

### Voiceover
- **edge-tts**, voice `en-US-AndrewNeural` (warm, confident), rate `+6%`–`+10%`.
  `python -m edge_tts --voice en-US-AndrewNeural --rate=+6% --text "..." --write-media p0X.mp3`
- Generate **per phrase**; place each at its cue with `adelay=<ms>:all=1`, `amix`, then
  `loudnorm I=-16`. (No ElevenLabs key on this machine — add `ELEVENLABS_API_KEY` to upgrade.)

### Music
- Synth bed via numpy/`wave` (`make_music*.py`): pad (Am–F–C–G) + 4-on-floor kick + riser +
  impacts on key beats. Keep it low under VO. Match its DUR to the video length.

### B-roll (Pixabay — free commercial use, **no attribution**)
- The Pixabay search-page HTML exposes direct CDN previews. Extract with:
  `curl -sL -A "Mozilla/5.0" "https://pixabay.com/videos/search/<query>/" | grep -oE "https://cdn\.pixabay\.com/video/[^\"\\ ]+_tiny\.mp4" | sort -u | head`
- `_tiny` is low-res → only use **blurred** (`gblur=sigma=26`, `eq=brightness=-0.17`). For
  HD/full-frame B-roll, get a free **Pexels/Pixabay API key**.
- Other sources: Pexels, Coverr, Mixkit (all royalty-free). Swap to licensed/own footage for a real campaign.

### Tools
- ffmpeg (portable): `promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe` (gitignored;
  re-download the gyan.dev static build if missing). Python 3.11 + `edge-tts`, `numpy`, `Pillow`.

### Emulator gotchas (IMPORTANT)
- **`adb screenrecord` is BROKEN on this emulator** (encoder produces 0-byte/invalid files at
  every size, even after reboot). **Do not rely on it.** Use:
  - **Stills:** `adb exec-out screencap -p > f.png` (always works).
  - **In-app motion ("capture-sequence"):** rapid `screencap` in a loop during a *slow* swipe,
    then assemble + `minterpolate=fps=30:mi_mode=mci`. ~7 fps source → smooth-ish.
- App package: `com.lifemaxxing.app/.MainActivity`. Cold start is slow (~10–20s, debug build);
  it may throw a "System UI not responding" ANR — tap **Wait** and give it time.
- **Re-seed demo data:** open app → **More** → scroll down → **Dev: design system** (`/dev`) →
  **Данни** tab → **"Зареди примерни данни"**. Seeder lives at `src/lib/dev/seed.dart`
  (includes trip covers + diary photos from `src/assets/seed_photos/`).
- Use a **phone** AVD (e.g. Pixel 9 Pro, ~1080×2400), not the tablet, for 9:16.
- Git Bash mangles `/sdcard/...` paths → prefix commands with `MSYS_NO_PATHCONV=1`.

### ffmpeg caption gotchas
- A literal `%` in `drawtext` triggers "Stray %" — avoid it (reword) or escape carefully.
- Unicode arrows (↑) may not render in Arial — prefer words ("higher", "up").
- When the phone is centered, place captions at the **top** (`y=h*0.085`) so they clear it.

### Real numbers from the seed (for insight-style videos)
Food = **47%** of spending · **294,399** steps / 30 days · **25 workouts, 38 h** · avg BP
**127/78**, one record flagged *"after a salty dinner"* · avg mood **7.5**, higher on training
days. (These are the demo "Martin" persona — swap for real user numbers before a real post.)

---

*Last updated after video #4. Keep this file current — it's how the next session picks up.*
