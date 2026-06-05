# Promo Video #6 — "Connect the Dots" — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce `promo/v6/out/v6_final.mp4` — a ~18s **B-roll-led short film** (wonder/uplift) where the app appears only at the reveal: ordinary days → the days I trained → feeling lighter → *was it real?* → the app proves it (mood peaks land on training days) → CTA. 1080×1920 / 30 fps / H.264+AAC.

**Architecture:** Reuse the per-video pipeline shape from #2–#5: a `render_v6.sh` that builds each beat as a segment then concats to a silent cut, and a `mux_v6.sh` that lays VO phrases at timed cues over a purpose-built music bed, finished with `loudnorm`. **New vs prior videos:** (1) beats 1–4 are graded B-roll with a *cool→warm* arc and **no app** (`make_broll`); (2) the app appears once, in a phone-mock that **rises into frame** showing the real mood screen, then a Pillow-generated **"connect the dots" overlay sequence** (`make_dots.py`) animates the finding on top; (3) a purpose-built **rise→resolve** music bed (`make_music_v6.py`).

**Tech Stack:** Portable ffmpeg (`promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe`), edge-tts (`en-US-AndrewNeural`, `--rate=+4%`), Python 3.11 (Pillow for the dots overlay, numpy/wave for music), bash via the Bash tool. Spec: `docs/superpowers/specs/2026-06-05-promo-video-6-connect-the-dots-design.md`.

**Conventions:** All commands run from the **repo root** (scripts `cd "$(dirname "$0")/../.."`). `FF` = the portable ffmpeg path above; `FP` = the sibling `ffprobe.exe`. Captions are English; the app UI in the reveal is Bulgarian (expected). Drawtext gotchas (`promo/VIDEOS.md` §4): no literal `%`, no Unicode arrows, font `C\:/Windows/Fonts/arialbd.ttf`. In filtergraph expressions, **commas inside `min()`/`if()` must be escaped** as `\,`.

---

## File Structure

- Create `promo/v6/` — the video's working dir (mirrors `promo/v5/`).
- Create `promo/v6/work/` — B-roll downloads, graded segments, app capture, dots frames, contact sheet, concat list. (Gitignored like prior `work/` dirs — verify against `.gitignore`.)
- Create `promo/v6/work/dots/` — the `make_dots.py` PNG frame sequence (`dots_000.png`…).
- Create `promo/v6/vo/` — generated VO mp3s `p01.mp3`…`p06.mp3`.
- Create `promo/v6/out/` — `v6_silent.mp4`, `v6_final.mp4`.
- Create `promo/v6/vo_lines.txt` — the 6 VO phrases (committed; narration source of truth).
- Create `promo/v6/make_dots.py` — generates the connect-the-dots overlay frame sequence (committed).
- Create `promo/v6/make_music_v6.py` — purpose-built rise→resolve music bed (committed).
- Create `promo/v6/render_v6.sh` — beat builders + concat → `v6_silent.mp4` (committed).
- Create `promo/v6/mux_v6.sh` — VO cues + music → `v6_final.mp4` (committed).
- Modify `promo/VIDEOS.md` — add the #6 history row, scripts list entry, mark idea used, "what worked" note.

Reused as-is (do not modify): `promo/v2/work/phone_body.png`, `promo/v2/work/screen_mask.png`, `src/assets/branding/icon-1024.png`.

**Beat timing targets** (sum ≈ 18.4s; **retime to measured VO in Task 4**):

| seg | beat | grade | dur (s) | start (s) | VO |
|-----|------|-------|---------|-----------|----|
| s01 | ordinary days | cool | 3.4 | 0.0 | L1 |
| s02 | the days I moved | warm | 2.2 | 3.4 | L2 |
| s03 | lighter / joy | warm | 2.8 | 5.6 | L3 |
| s04 | the doubt | cool | 2.6 | 8.4 | L4 |
| s05 | the reveal (app + dots) | — | 3.8 | 11.0 | L5 |
| s06 | endcard (brand + CTA) | — | 3.6 | 14.8 | L6 |

---

## Task 1: Scaffold `promo/v6/` and verify tooling

**Files:**
- Create: `promo/v6/work/`, `promo/v6/work/dots/`, `promo/v6/vo/`, `promo/v6/out/` (directories)

- [ ] **Step 1: Create the directories and confirm ffmpeg/ffprobe + reused assets exist**

Run (from repo root):
```bash
mkdir -p promo/v6/work/dots promo/v6/vo promo/v6/out
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FF" -version | head -1
ls -1 promo/v2/work/phone_body.png promo/v2/work/screen_mask.png src/assets/branding/icon-1024.png
```
Expected: ffmpeg prints a version line; all three `ls` paths print with no "No such file" error.

- [ ] **Step 2: Confirm Python deps (Pillow, numpy, edge-tts) are importable**

Run:
```bash
python -c "import PIL, numpy, edge_tts; print('deps ok', PIL.__version__)"
```
Expected: prints `deps ok <version>`. If any import fails: `pip install pillow numpy edge-tts`.

- [ ] **Step 3: Regenerate the phone frame if missing**

Run:
```bash
[ -f promo/v2/work/phone_body.png ] && [ -f promo/v2/work/screen_mask.png ] || python promo/make_phone_frame.py
ls -1 promo/v2/work/phone_body.png promo/v2/work/screen_mask.png
```
Expected: both paths print. (No commit — these are gitignored working assets.)

---

## Task 2: Source and grade-test the B-roll (the central risk gate)

The whole film is footage; this is where it lives or dies. Source **four** clips — one per story beat — preferring no-key HD sources, then prove the cool/warm grade reads well **before** building beats.

**Files:**
- Create: `promo/v6/work/b1.mp4` (ordinary), `b2.mp4` (movement), `b3.mp4` (joy/light), `b4.mp4` (doubt/still)
- Create: `promo/v6/work/grade_cool.png`, `promo/v6/work/grade_warm.png`

- [ ] **Step 1: Source four clips from no-key free sources**

No Pexels/Pixabay API key (user's call). Pull the best free footage by hand, preferring sources that give full-res direct downloads:
- **Mixkit** — `https://mixkit.co/free-stock-video/<query>/` exposes direct `.mp4` download links (no login).
- **Coverr** — `https://coverr.co/s?q=<query>` direct downloads (no login).
- **Pexels** — `https://www.pexels.com/search/videos/<query>/` video pages expose download URLs.
- **Pixabay `_tiny`** — graded fallback only (`promo/VIDEOS.md` §4 method): `curl -sL -A "Mozilla/5.0" "https://pixabay.com/videos/search/<query>/" | grep -oE "https://cdn\.pixabay\.com/video/[^\"\\ ]+_tiny\.mp4" | sort -u | head`.

Target one clip per beat (**each ≥ its beat length**, ideally 4s+, single-subject, intimate not glossy):
- `b1` ordinary: `coffee window morning`, `rainy window`, `slow morning tired`.
- `b2` movement: `running sunrise`, `gym workout`, `trail running`.
- `b3` joy/light: `smile sunlight`, `drinking water after workout`, `stretching morning sun`.
- `b4` doubt/still: `pensive window`, `thinking quiet`, `looking out window`.

Download the chosen clips:
```bash
curl -L "<b1_url>" -o promo/v6/work/b1.mp4
curl -L "<b2_url>" -o promo/v6/work/b2.mp4
curl -L "<b3_url>" -o promo/v6/work/b3.mp4
curl -L "<b4_url>" -o promo/v6/work/b4.mp4
for f in b1 b2 b3 b4; do
  d=$("promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe" -v error -show_entries format=duration -of csv=p=0 promo/v6/work/$f.mp4)
  printf "%s %s  " "$f" "$d"; ls -la promo/v6/work/$f.mp4 | awk '{print $5}'
done
```
Expected: four non-empty `.mp4` files (>50 KB each); note each duration — must be ≥ its beat target (s01 3.4, s02 2.2, s03 2.8, s04 2.6). If a clip is shorter, it will jump-cut-loop in render — prefer re-sourcing a longer one.

- [ ] **Step 2: Grade-test one cool frame and one warm frame (the stock-y gate)**

Render a graded still for each look and eyeball them. Cool = beats 1 & 4 (muted, slightly cold); warm = beats 2 & 3 (warm, alive):
```bash
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
# cool look on b1
"$FF" -y -i promo/v6/work/b1.mp4 -vf \
"scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,eq=brightness=-0.04:saturation=0.78:contrast=1.03,colorbalance=rm=-0.04:bm=0.05,vignette=PI/4.5" \
-frames:v 1 promo/v6/work/grade_cool.png -loglevel error
# warm look on b2
"$FF" -y -i promo/v6/work/b2.mp4 -vf \
"scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,eq=brightness=0.04:saturation=1.10:contrast=1.04,colorbalance=rm=0.06:gm=0.02:bm=-0.06,vignette=PI/5" \
-frames:v 1 promo/v6/work/grade_warm.png -loglevel error
```
Open both (`Invoke-Item promo/v6/work/grade_cool.png` etc., PowerShell). Expected: the cool frame reads quiet/muted and the warm frame reads alive/hopeful — **and neither looks like cheap bright stock**. **If a clip can't be saved by grading (blocky, obviously low-res when sharp), re-source it** (try a Mixkit/Coverr HD alternative). **If no usable footage can be found for a beat at all, invoke the spec fallback** (§9): drop to the phone-mock-over-blurred-B-roll formula where low-res is hidden, and note the re-scope. Do not proceed to render until all four clips pass.

---

## Task 3: Capture the app mood screen (re-seed + screencap)

The reveal needs the real seeded mood-trend screen (proves it's real app data; the dots overlay is layered on top in the edit).

**Files:**
- Create: `promo/v6/work/mood.png`

- [ ] **Step 1: Boot the emulator, re-seed, navigate to the mood/health trend screen, capture**

Per `promo/VIDEOS.md` §4: re-seed (app → **More** → **Dev: design system** → **Данни** → **"Зареди примерни данни"**), then open the module that shows the **mood trend over time** (the daily-log / health mood view with the MoodGauge / trend chart and the seeded "Martin" data). Capture (stills only — `adb screenrecord` is broken on this emulator):
```bash
MSYS_NO_PATHCONV=1 adb exec-out screencap -p > promo/v6/work/mood.png
"promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe" -v error -show_entries stream=width,height -of csv=p=0 promo/v6/work/mood.png
```
Expected: a non-empty PNG; ffprobe prints its dimensions (e.g. `1080,2400`). Open it (`Invoke-Item`) and confirm it shows the seeded mood data over time (the "happy days" the story is about), not an empty/error state. **Pick the screen that best proves "higher mood on training days"** (the #5 "match stat to a screen" lesson) — if one view shows mood peaks more legibly, use that.

- [ ] **Step 2: Commit the capture**

```bash
git add -f promo/v6/work/mood.png
git commit -m "promo: capture mood screen for video #6 reveal"
```
Expected: commit succeeds. (`-f` because `work/` is gitignored; the mood capture is the one screen we want versioned for reproducibility.)

---

## Task 4: Write the 6 VO phrases, generate them, and measure durations

**Files:**
- Create: `promo/v6/vo_lines.txt`
- Create: `promo/v6/vo/p01.mp3` … `promo/v6/vo/p06.mp3`
- Create: `promo/v6/work/vo_durations.txt`

- [ ] **Step 1: Write the narration file (6 beats, in order, sparse)**

Create `promo/v6/vo_lines.txt` with exactly these lines (one phrase per line):
```
Some days I felt great. Some days, just flat.
But on the days I trained...
I felt lighter. Happier. Every single time.
Was it real? Or just in my head?
Turns out, I'd been keeping track. Every peak, a training day.
I didn't need an expert. My own life told me what makes me happy.
```

- [ ] **Step 2: Generate one mp3 per line with edge-tts (calmer rate `+4%`)**

```bash
i=0
while IFS= read -r line; do
  i=$((i+1)); idx=$(printf "%02d" $i)
  python -m edge_tts --voice en-US-AndrewNeural --rate=+4% --text "$line" --write-media "promo/v6/vo/p$idx.mp3"
done < promo/v6/vo_lines.txt
ls -1 promo/v6/vo/p*.mp3 | wc -l
```
Expected: prints `6`. If `edge_tts` is missing: `pip install edge-tts`.

- [ ] **Step 3: Measure each phrase's duration (drives beat timing)**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
: > promo/v6/work/vo_durations.txt
for i in $(seq 1 6); do idx=$(printf "%02d" $i);
  d=$("$FP" -v error -show_entries format=duration -of csv=p=0 "promo/v6/vo/p$idx.mp3")
  printf "p%s %s\n" "$idx" "$d" | tee -a promo/v6/work/vo_durations.txt
done
```
Expected: 6 lines like `p02 1.6`. **Record these.** Each beat's `-t` in Task 6 must be `≥ phrase duration + 0.3s`. If any phrase is longer than its target beat (File Structure table), bump that beat (and update the music section boundaries in Task 5 and the `delays` in Task 7 to match — they all share the same beat-start timeline).

- [ ] **Step 4: Commit the narration source**

```bash
git add promo/v6/vo_lines.txt
git commit -m "promo: add video #6 narration script (connect the dots)"
```
Expected: commit succeeds. (mp3s + durations live under gitignored `vo/`/`work/`.)

---

## Task 5: Write `make_music_v6.py` (rise → resolve bed)

**Files:**
- Create: `promo/v6/make_music_v6.py`
- Produces: `promo/v6/work/music_v6.wav`

- [ ] **Step 1: Write the music generator**

Create `promo/v6/make_music_v6.py` (additive sine pads with a per-section gain arc, a soft kick from the movement beat through the reveal, a noise riser into the reveal, and a bell impact on the resolve). Section boundaries match the beat timeline (retime if Task 4 changed beats):
```python
import numpy as np, wave

sr = 44100
DUR = 18.6                      # slightly longer than the video; mux trims to length
N = int(sr * DUR)
mix = np.zeros(N)

def note(freq, t0, t1, gain=0.2, attack=0.4, release=0.6):
    s = np.zeros(N)
    i0, i1 = int(t0*sr), int(t1*sr)
    if i1 <= i0 or i0 >= N: return s
    i1 = min(i1, N); n = i1 - i0
    tt = np.arange(n)/sr
    w = (np.sin(2*np.pi*freq*tt)
         + 0.5*np.sin(2*np.pi*freq*1.001*tt)   # gentle detune for width
         + 0.25*np.sin(2*np.pi*freq*2*tt))     # octave for warmth
    env = np.ones(n)
    a = int(min(attack, n/sr/2)*sr); r = int(min(release, n/sr/2)*sr)
    if a > 0: env[:a] = np.linspace(0, 1, a)
    if r > 0: env[-r:] = np.linspace(1, 0, r)
    s[i0:i1] = w * env * gain
    return s

def chord(freqs, t0, t1, gain=0.10, **kw):
    s = np.zeros(N)
    for f in freqs: s += note(f, t0, t1, gain=gain, **kw)
    return s

# pitches (Hz)
A2,C3,E3,F3,G3,A3,C4,E4,G4,D4 = 110,130.81,164.81,174.61,196,220,261.63,329.63,392,293.66

# emotional arc (section times track the beat timeline)
mix += chord([A2, E3],            0.0, 3.6, gain=0.05, attack=1.0, release=1.1)  # b1 ordinary: low minor, cold
mix += chord([C3, G3, C4],        3.4, 5.8, gain=0.07, attack=1.0, release=0.8)  # b2 movement: warm builds
mix += chord([F3, A3, C4, F3*2],  5.6, 8.6, gain=0.08, attack=0.8, release=0.7)  # b3 joy: brighter
mix += chord([A3, D4],            8.4, 11.0, gain=0.045, attack=0.5, release=0.6) # b4 doubt: pull back, suspended
mix += chord([C3,E3,G3,C4,E4,G4], 10.8, 14.9, gain=0.09, attack=0.25, release=1.1) # b5 reveal: resolve, bright major
mix += chord([C3, G3, C4, E4],    14.8, 18.6, gain=0.07, attack=0.4, release=1.6)  # b6 endcard: sustained warm major

# soft 4-on-the-floor kick from movement through the reveal
def kick(tc, gain=0.32):
    s = np.zeros(N); i0 = int(tc*sr); n = int(0.18*sr)
    if i0+n > N: n = N-i0
    if n <= 0: return s
    tt = np.arange(n)/sr
    freq = 110*np.exp(-tt*30) + 45
    s[i0:i0+n] = np.sin(2*np.pi*np.cumsum(freq)/sr) * np.exp(-tt*16) * gain
    return s
spb = 60/100.0                  # 100 bpm
tk = 3.4
while tk < 11.0:
    mix += kick(tk); tk += spb

# noise riser into the reveal (9.5 -> 11.0)
i0, i1 = int(9.5*sr), int(11.0*sr); n = i1-i0
tt = np.arange(n)/sr
mix[i0:i1] += np.random.randn(n) * 0.05 * (np.linspace(0,1,n)**2)

# bell impact on the resolve (11.0)
mix += note(C4, 11.0, 12.4, gain=0.16, attack=0.004, release=1.3)
mix += note(G4, 11.0, 12.4, gain=0.11, attack=0.004, release=1.3)

# master: normalize, global fade in/out
mix /= (np.max(np.abs(mix)) + 1e-9); mix *= 0.85
fi, fo = int(0.3*sr), int(0.9*sr)
mix[:fi] *= np.linspace(0,1,fi); mix[-fo:] *= np.linspace(1,0,fo)

data = (mix*32767).astype(np.int16)
stereo = np.column_stack([data, data]).flatten()
w = wave.open("promo/v6/work/music_v6.wav", "w")
w.setnchannels(2); w.setsampwidth(2); w.setframerate(sr)
w.writeframes(stereo.tobytes()); w.close()
print("wrote promo/v6/work/music_v6.wav", DUR, "s")
```

- [ ] **Step 2: Generate and sanity-check the bed**

```bash
python promo/v6/make_music_v6.py
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FP" -v error -show_entries format=duration -of csv=p=0 promo/v6/work/music_v6.wav
```
Expected: prints `wrote ... 18.6 s` then a duration ≈ `18.6`. Optionally open the wav to confirm it builds and resolves (cold/quiet → warmer → a brief pull-back → a bright resolve around 11s). It plays under VO so it only needs to feel right, not be a finished track.

- [ ] **Step 3: Commit the music generator**

```bash
git add promo/v6/make_music_v6.py
git commit -m "promo: add video #6 music bed generator (rise to resolve)"
```
Expected: commit succeeds. (The `.wav` is gitignored under `work/`.)

---

## Task 6: Write `make_dots.py` (the connect-the-dots overlay sequence)

**Files:**
- Create: `promo/v6/make_dots.py`
- Produces: `promo/v6/work/dots/dots_000.png` … (one per frame of beat 5)

The signature creative moment. Generates a transparent PNG sequence the length of beat 5: a scrim panel fades in over the phone, a connecting line draws left→right across 7 day-points, the "happy" days (training days) pop **green** with a glow, and small dumbbell glyphs appear under them. Honest data viz of his own numbers (not fake app UI). Positioned over the phone's mid-region so it reads as the app highlighting the pattern.

- [ ] **Step 1: Write the generator**

Create `promo/v6/make_dots.py` (`DOT_DUR` must equal beat s05's duration from Task 4 — default 3.8s):
```python
import os
from PIL import Image, ImageDraw

W, H = 1080, 1920
FPS = 30
DOT_DUR = 3.8                       # MUST equal beat s05 duration (retime in Task 4)
NF = int(FPS * DOT_DUR)
OUT = "promo/v6/work/dots"; os.makedirs(OUT, exist_ok=True)

# 7 days across a band over the phone's mid-region
N = 7
X0, X1 = 200, 880
BAND_TOP, BAND_BOT = 1150, 1450
xs = [int(X0 + (X1-X0)*i/(N-1)) for i in range(N)]
mood     = [0.35, 0.85, 0.42, 0.92, 0.45, 0.88, 0.50]   # higher = happier
training = [False, True, False, True, False, True, False] # peaks = training days
ys = [int(BAND_BOT - (BAND_BOT-BAND_TOP)*m) for m in mood]
GREEN = (95, 208, 138)             # 0x5FD08A
GREY  = (165, 174, 190)
GLYPH_Y = BAND_BOT + 70

def clamp(v, a=0.0, b=1.0): return max(a, min(b, v))

for i in range(NF):
    t = i / FPS
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))

    # scrim panel fades in 0.6 -> 1.0
    sc = clamp((t - 0.6) / 0.4)
    if sc > 0:
        scrim = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        ImageDraw.Draw(scrim).rounded_rectangle(
            [110, BAND_TOP-110, 970, GLYPH_Y+40], radius=36,
            fill=(8, 10, 16, int(150*sc)))
        img = Image.alpha_composite(img, scrim)

    d = ImageDraw.Draw(img)
    # connecting line draws 0.9 -> 2.1
    p = clamp((t - 0.9) / 1.2)
    drawn_x = X0 + (X1 - X0) * p
    pts = [(xs[k], ys[k]) for k in range(N) if xs[k] <= drawn_x]
    if len(pts) >= 2:
        d.line(pts, fill=(205, 214, 228, 230), width=6, joint="curve")

    # dots + (for training days) glow and a dumbbell glyph
    for k in range(N):
        if xs[k] <= drawn_x + 2:
            if training[k]:
                glow = Image.new("RGBA", (W, H), (0, 0, 0, 0))
                ImageDraw.Draw(glow).ellipse(
                    [xs[k]-40, ys[k]-40, xs[k]+40, ys[k]+40], fill=(95, 208, 138, 70))
                img = Image.alpha_composite(img, glow); d = ImageDraw.Draw(img)
                r = 24
                d.ellipse([xs[k]-r, ys[k]-r, xs[k]+r, ys[k]+r], fill=GREEN+(255,))
                gx, gy = xs[k], GLYPH_Y
                d.rounded_rectangle([gx-24, gy-6, gx+24, gy+6], radius=4, fill=(255,255,255,235))
                d.rounded_rectangle([gx-30, gy-16, gx-18, gy+16], radius=4, fill=(255,255,255,235))
                d.rounded_rectangle([gx+18, gy-16, gx+30, gy+16], radius=4, fill=(255,255,255,235))
            else:
                r = 15
                d.ellipse([xs[k]-r, ys[k]-r, xs[k]+r, ys[k]+r], fill=GREY+(255,))

    img.save(f"{OUT}/dots_{i:03d}.png")

print("wrote", NF, "frames to", OUT)
```

- [ ] **Step 2: Generate the frames**

```bash
rm -f promo/v6/work/dots/dots_*.png
python promo/v6/make_dots.py
ls -1 promo/v6/work/dots/dots_*.png | wc -l
```
Expected: prints `wrote 114 frames ...` then `114` (for DOT_DUR=3.8 → 3.8×30). Spot-check the last frame (`Invoke-Item promo/v6/work/dots/dots_113.png`): a dark rounded panel with a line through 7 dots, the 2nd/4th/6th green with a glow and a dumbbell under each. (It will be composited over the phone in Task 7, so it's mostly transparent.)

- [ ] **Step 3: Commit the generator**

```bash
git add promo/v6/make_dots.py
git commit -m "promo: add video #6 connect-the-dots overlay generator"
```
Expected: commit succeeds. (PNG frames are gitignored under `work/`.)

---

## Task 7: Write `render_v6.sh` (build beats → silent cut)

**Files:**
- Create: `promo/v6/render_v6.sh`

- [ ] **Step 1: Write the render script**

Create `promo/v6/render_v6.sh`:
```bash
#!/usr/bin/env bash
# Video #6 "Connect the Dots" — B-roll-led short film; app only at the reveal.
# Beats 1-4: graded B-roll (cool->warm arc), no app. Beat 5: phone rises with the
# real mood screen + connect-the-dots overlay. Beat 6: brand + CTA. Silent cut; audio via mux_v6.sh.
set -e
cd "$(dirname "$0")/../.."   # repo root
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v6/work"; OUT="promo/v6/out"; mkdir -p "$W" "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"
PB="promo/v2/work/phone_body.png"; MK="promo/v2/work/screen_mask.png"
[ -f "$PB" ] && [ -f "$MK" ] || python promo/make_phone_frame.py

# make_broll <clip> <dur> <cool|warm> <out>
# Graded full-frame B-roll, gentle push-in, light grain, in/out fades. No caption (story beats).
make_broll(){ local clip="$1" dur="$2" mode="$3" o="$4"; local NN=$(awk "BEGIN{print $dur*30-1}")
  local fo=$(awk "BEGIN{print $dur-0.3}") grade
  if [ "$mode" = "warm" ]; then
    grade="eq=brightness=0.04:saturation=1.10:contrast=1.04,colorbalance=rm=0.06:gm=0.02:bm=-0.06,vignette=PI/5"
  else
    grade="eq=brightness=-0.04:saturation=0.78:contrast=1.03,colorbalance=rm=-0.04:bm=0.05,vignette=PI/4.5"
  fi
  "$FF" -y -stream_loop -1 -i "$clip" -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,${grade},\
zoompan=z='1.04+0.06*on/${NN}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
noise=alls=7:allf=t,\
fade=t=in:st=0:d=0.3,fade=t=out:st=${fo}:d=0.3,format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== s01-s04 B-roll story (no app) =="
make_broll "$W/b1.mp4" 3.4 cool "$W/s01.mp4"
make_broll "$W/b2.mp4" 2.2 warm "$W/s02.mp4"
make_broll "$W/b3.mp4" 2.8 warm "$W/s03.mp4"
make_broll "$W/b4.mp4" 2.6 cool "$W/s04.mp4"

echo "== s05a reveal base: phone rises with mood screen =="
# bg = mood screen blurred/darkened fill; phone (mood screen sharp) rises into a centered settle by 0.6s.
"$FF" -y -loop 1 -i "$W/mood.png" -loop 1 -i "$PB" -loop 1 -i "$MK" \
 -filter_complex "\
[0:v]split[m1][m2];\
[m1]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=26,eq=brightness=-0.22:saturation=1.05[bg];\
[m2]scale=620:1264:force_original_aspect_ratio=increase,crop=620:1264,setsar=1,format=rgba[av];\
[2:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];\
[bg][mock]overlay=x=(W-w)/2:y='(H-h)/2 + H*(1-min(1\,t/0.6))':shortest=1,format=yuv420p[v]" \
 -map "[v]" -t 3.8 "$W/s05base.mp4" -loglevel error

echo "== s05b reveal: overlay connect-the-dots sequence + caption =="
"$FF" -y -i "$W/s05base.mp4" -framerate 30 -i "$W/dots/dots_%03d.png" \
 -filter_complex "[0:v][1:v]overlay=0:0:shortest=1,\
drawtext=fontfile='${FONT}':text='Higher mood on training days':fontcolor=0x5FD08A:fontsize=52:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.5:boxborderw=22:enable='gte(t,1.6)':alpha='if(lt(t,1.6),0,if(lt(t,1.9),(t-1.6)/0.3,1))',format=yuv420p[v]" \
 -map "[v]" -t 3.8 "$W/s05.mp4" -loglevel error

echo "== s06 endcard (brand + CTA) =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
 -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Track your whole life':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 108 "$W/s06.mp4" -loglevel error

echo "== concat =="
L="$W/list_v6.txt"; : > "$L"
for s in s01 s02 s03 s04 s05 s06; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v6_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v6_silent.mp4" -loglevel error
echo "DONE -> $OUT/v6_silent.mp4"
```

- [ ] **Step 2: Make it executable and commit**

```bash
chmod +x promo/v6/render_v6.sh
git add promo/v6/render_v6.sh
git commit -m "promo: add video #6 render script (B-roll-led + dots reveal)"
```
Expected: commit succeeds.

---

## Task 8: Render the silent cut and verify it

**Files:**
- Produces: `promo/v6/out/v6_silent.mp4`, `promo/v6/work/v6_contact.png`

- [ ] **Step 1: Run the render**

```bash
bash promo/v6/render_v6.sh
```
Expected: prints each `== ... ==` line then `DONE -> promo/v6/out/v6_silent.mp4`, no ffmpeg errors. If a `make_broll` errors, the clip path is wrong (Task 2). If the s05 reveal errors, check `mood.png` (Task 3) and that `dots/dots_000.png` exists (Task 6).

- [ ] **Step 2: Verify format + duration (the automated gate)**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FP" -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,codec_name \
  -show_entries format=duration -of default=noprint_wrappers=1 promo/v6/out/v6_silent.mp4
```
Expected: `codec_name=h264`, `width=1080`, `height=1920`, `r_frame_rate=30/1`, and `duration` between **15 and 20** (target ~18.4). If out of range, adjust beat `-t` values in `render_v6.sh` and re-render.

- [ ] **Step 3: Build a contact sheet and eyeball every beat**

```bash
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
"$FF" -y -i promo/v6/out/v6_silent.mp4 -vf "fps=1,scale=216:384,tile=4x5" promo/v6/work/v6_contact.png -loglevel error
```
Open `promo/v6/work/v6_contact.png` (`Invoke-Item`). Check, in order: (1) B-roll grade arc reads **cool → warm → warm → cool** across beats 1–4 and none looks cheap; (2) the phone **rises** into frame in beat 5 and settles centered on the mood screen; (3) the **dots overlay** is legible — line through 7 dots, training days green with glow + dumbbell, the green caption clears the phone; (4) the endcard shows the icon, "LifeMaxxing", and the green DOWNLOAD NOW. **If the dots overlay reads badly** (overlaps the phone awkwardly, illegible), invoke the fallback: simplify beat 5 to phone + caption + a green underline animation (drop the `make_dots` overlay) and re-render. **If a B-roll beat looks stock-y**, re-source that clip (Task 2) and re-render.

---

## Task 9: Write `mux_v6.sh` and produce the final

**Files:**
- Create: `promo/v6/mux_v6.sh`
- Produces: `promo/v6/out/v6_final.mp4`

VO cue delays (ms from start) = each beat's start + 150 ms (from the File Structure table). **Recompute from the actual silent-cut beat boundaries if you retimed any beat.** Default array (6 cues): `150 3550 5750 8550 11150 14950`.

- [ ] **Step 1: Write the mux script**

Create `promo/v6/mux_v6.sh`:
```bash
#!/usr/bin/env bash
# Mux video #6: 6 VO phrases at their cues + purpose-built music bed under -> loudnorm.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
VID="promo/v6/out/v6_silent.mp4"; OUT="promo/v6/out/v6_final.mp4"
MUSIC="promo/v6/work/music_v6.wav"
[ -f "$MUSIC" ] || python promo/v6/make_music_v6.py
DUR=$("$FP" -v error -show_entries format=duration -of csv=p=0 "$VID")
FADEOUT=$(awk "BEGIN{print $DUR-0.8}")
delays=(150 3550 5750 8550 11150 14950)
n=${#delays[@]}
ins=""; fc=""; mixin=""
for i in $(seq 1 $n); do idx=$(printf "%02d" $i); ins="$ins -i promo/v6/vo/p$idx.mp3";
  d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
M=$((n+1))
"$FF" -y -i "$VID" $ins -i "$MUSIC" \
 -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${M}:a]atrim=0:${DUR},volume=0.26,afade=t=in:st=0:d=0.5,afade=t=out:st=${FADEOUT}:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
 -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
```

- [ ] **Step 2: Make executable and commit**

```bash
chmod +x promo/v6/mux_v6.sh
git add promo/v6/mux_v6.sh
git commit -m "promo: add video #6 mux script (VO + music)"
```
Expected: commit succeeds.

- [ ] **Step 3: Run the mux**

```bash
bash promo/v6/mux_v6.sh
```
Expected: prints `DONE -> promo/v6/out/v6_final.mp4`, no errors.

- [ ] **Step 4: Verify the final has video + audio, correct format, in-range duration**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FP" -v error -show_entries stream=codec_type,codec_name -show_entries format=duration,size,bit_rate \
  -of default=noprint_wrappers=1 promo/v6/out/v6_final.mp4
```
Expected: one `codec_type=video`/`codec_name=h264` and one `codec_type=audio`/`codec_name=aac`; `duration` 15–20s. Note `bit_rate` — flag if it drops far below the series' healthy ~1.2–2.6 Mbps.

- [ ] **Step 5: Watch it (the real gate) — VO sync, music arc, emotional read**

```bash
# PowerShell:
Invoke-Item promo/v6/out/v6_final.mp4
```
Check: each VO phrase lands on its beat (no drift by the end); the music rises through beats 2–3, pulls back on the doubt, and **resolves on the reveal**; the dots connect cleanly as L5 is spoken; it *feels* like wonder, not a health scare. **If beat 4 (the doubt) feels heavy/downer**, cut it: remove `s04` from the concat list in `render_v6.sh`, drop the L4 mp3 + its cue from `delays`, re-render and re-mux (≈15s, purely positive — the spec-sanctioned alt). If VO drifts, recompute `delays` from actual beat boundaries and re-mux. If music is too loud/quiet, adjust `volume=0.26` and re-mux.

---

## Task 10: Log the video in `promo/VIDEOS.md`

**Files:**
- Modify: `promo/VIDEOS.md` (§1 history table, per-video scripts list, §2 idea status, "what worked" note + last-updated line)

- [ ] **Step 1: Add the history row to §1**

Add after the video #5 row in the table:
```markdown
| 6 | **Connect the Dots** | *Emotional / story* — a vague feeling ("happier on training days") becomes a measurable fact, proven because mood + workouts live in one app | **B-roll-led short film** (cool→warm grade arc); app appears only at the reveal (phone-mock + edit-built connect-the-dots overlay) + CTA | 18s | ✅ done | `promo/v6/out/v6_final.mp4` |
```

- [ ] **Step 2: Add the per-video build-scripts line**

Under the "Per-video build scripts" list:
```markdown
- **#6:** `promo/v6/render_v6.sh` · `promo/v6/mux_v6.sh` · `promo/v6/make_music_v6.py` · `promo/v6/make_dots.py` (B-roll-led `make_broll` cool/warm grade; phone-rise reveal + Pillow connect-the-dots overlay sequence; reuses #2 phone frame). Spec/plan in `docs/superpowers/`.
```

- [ ] **Step 3: Mark the idea used in §2 and update the "what worked / try next" note**

In §2, strike through or annotate the cross-domain "connect the dots" concept as used in #6. Replace the final `*Last updated after video #5...*` line with a short note covering how the **B-roll-led (no-app-until-the-end) format** landed (did free no-key footage read cinematic or cheap? did the cool→warm arc carry the emotion?), how the **edit-built cross-module reveal** read (clear? honest? impressive?), whether **beat 4's doubt** earned its place, and the new `*Last updated after video #6.*` line.

- [ ] **Step 4: Commit**

```bash
git add promo/VIDEOS.md
git commit -m "promo: log video #6 (connect the dots) in VIDEOS.md"
```
Expected: commit succeeds.

---

## Self-Review (completed by plan author)

- **Spec coverage:** B-roll-led, app only at reveal → Tasks 2 (B-roll) + 7 (s01–s04 no app, s05 reveal). Wonder/uplift tone → cool→warm grade arc (Task 7 `make_broll` modes) + rise→resolve music (Task 5). You+app, no AI → no AI assets anywhere; reveal is phone + edit overlay (Tasks 6–7). True story (mood↑ on training days) → real `mood.png` capture (Task 3) + dots viz (Task 6). ~16–18s → duration gate 15–20 (Tasks 8, 9). Andrew +4% sparse → Task 4. Free no-key B-roll → Task 2 sourcing (Mixkit/Coverr/Pexels/Pixabay-tiny). Dots-connect "in the edit" → `make_dots.py` (Task 6) overlaid in s05b (Task 7). Beat-4 cuttable → Task 9 Step 5. Production layout `promo/v6/` → Tasks 1, 7, 9. Verification (ffprobe + contact sheet + watch) → Tasks 8, 9. Logging → Task 10. Risks (cheap footage, tone whiplash, over-promising UI, stale capture, runtime) → Task 2 grade gate + fallback, Task 9 Step 5 beat-4 cut, honest data-viz framing (Task 6), Task 3 re-seed, duration gates. All spec sections map to tasks.
- **Placeholder scan:** B-roll URLs in Task 2 (`<b1_url>`…) are intentionally chosen-at-runtime — the specific free clip can't be known before sourcing; the queries, sources, and selection criteria (≥ beat length, single-subject, passes grade gate) are concrete. No other placeholders.
- **Type/name consistency:** segment names `s01`–`s06` consistent across `render_v6.sh`, the concat list, and the contact-sheet tile (`4x5`=20 ≥ ~19 frames). VO files `p01`–`p06` consistent across Task 4, the `delays` array length (6), and `mux_v6.sh`. `make_broll` modes `cool`/`warm` match the grade branch. `DOT_DUR` (3.8) in `make_dots.py` == s05 `-t` (3.8) in `render_v6.sh` == `make_dots` frame count assumption (114). Music section boundaries (Task 5) align to the beat-start timeline and the `delays` cues (Task 9). `make_music_v6.py` writes `music_v6.wav`, which `mux_v6.sh` reads. Beat starts (0/3.4/5.6/8.4/11.0/14.8) → cues (150/3550/5750/8550/11150/14950) are start+150ms and consistent.
```
