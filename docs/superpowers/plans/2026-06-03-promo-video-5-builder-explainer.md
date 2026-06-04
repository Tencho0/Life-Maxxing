# Promo Video #5 — Builder Explainer — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce `promo/v5/out/v5_final.mp4` — a ~53s first-person "builder story" explainer of LifeMaxxing (desk B-roll bookends, full-frame 9-module tour, AI-export payoff, CTA), 1080×1920 / 30 fps / H.264+AAC.

**Architecture:** Reuse the established per-video pipeline from #2–#4: a `render_v5.sh` that builds each beat as a segment then concats to a silent cut, and a `mux_v5.sh` that lays VO phrases at timed cues with a music bed under, finished with `loudnorm`. New vs prior videos: a full-frame app beat builder (`make_full`) and a desk-B-roll beat builder (`make_desk`); the phone-mock + AI-chip payoff reuses #4's assets/filters.

**Tech Stack:** Portable ffmpeg (`promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe`), edge-tts (`en-US-AndrewNeural`), Python 3.11 (Pillow for assets), bash via the Bash tool. Spec: `docs/superpowers/specs/2026-06-03-promo-video-5-builder-explainer-design.md`.

**Conventions:** All commands run from the **repo root** (the scripts `cd "$(dirname "$0")/../.."`). `FF` = the portable ffmpeg path above; `FP` = the sibling `ffprobe.exe`. The captions are English; the app UI on screen is Bulgarian (expected). Drawtext gotchas (§4 of `promo/VIDEOS.md`): no literal `%`, no Unicode arrows, font `C\:/Windows/Fonts/arialbd.ttf`.

---

## File Structure

- Create `promo/v5/` — the video's working dir (mirrors `promo/v4/`).
- Create `promo/v5/work/` — intermediate segments, B-roll, contact sheet, concat list. (Gitignored like prior `work/` dirs — verify against `.gitignore`.)
- Create `promo/v5/vo/` — generated VO mp3s `p01.mp3`…`p13.mp3`.
- Create `promo/v5/out/` — `v5_silent.mp4`, `v5_final.mp4`.
- Create `promo/v5/vo_lines.txt` — the 13 VO phrases (source of truth for narration; committed).
- Create `promo/v5/render_v5.sh` — beat builders + concat → `v5_silent.mp4`.
- Create `promo/v5/mux_v5.sh` — VO cues + music → `v5_final.mp4`.
- Modify `promo/VIDEOS.md` — add the #5 history row, scripts list entry, and a "what worked" note.

Reused as-is (do not modify): `promo/v2/work/phone_body.png`, `promo/v2/work/screen_mask.png`, `promo/v2/work/music_v2.wav`, `promo/v4/work/chip_*.png` (+ `promo/v4/make_ai_chips.py` to regenerate), `src/assets/branding/icon-1024.png`, app screens in `promo/work/*.png`.

---

## Task 1: Scaffold `promo/v5/` and verify tooling

**Files:**
- Create: `promo/v5/work/`, `promo/v5/vo/`, `promo/v5/out/` (directories)

- [ ] **Step 1: Create the directories and confirm ffmpeg/ffprobe + reused assets exist**

Run (from repo root):
```bash
mkdir -p promo/v5/work promo/v5/vo promo/v5/out
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FF" -version | head -1
ls -1 promo/v2/work/phone_body.png promo/v2/work/screen_mask.png promo/v2/work/music_v2.wav \
      src/assets/branding/icon-1024.png promo/v4/make_ai_chips.py
```
Expected: ffmpeg prints a version line; all five `ls` paths print with no "No such file" error.

- [ ] **Step 2: Verify the phone frame + AI chips are buildable (regenerate if missing)**

Run:
```bash
[ -f promo/v2/work/phone_body.png ] && [ -f promo/v2/work/screen_mask.png ] || python promo/make_phone_frame.py
[ -f promo/v4/work/chip_chatgpt.png ] && [ -f promo/v4/work/chip_claude.png ] && [ -f promo/v4/work/chip_gemini.png ] || python promo/v4/make_ai_chips.py
ls -1 promo/v2/work/phone_body.png promo/v4/work/chip_chatgpt.png
```
Expected: both paths print. (No commit — these are gitignored generated/working assets.)

---

## Task 2: Confirm app screens are current (re-seed + re-capture if stale)

The full-frame tour needs **10** app screens: home, food, money/charts, health, steps, activities, daily log, diary, bucket, trips. Several `promo/work/*.png` predate recent seed changes — verify before trusting them.

**Files:**
- Use/refresh: `promo/work/home.png`, `food.png`, `charts.png`, `health.png`, `steps.png`, `activities.png`, `dailylog.png`, `memories.png`, `bucket.png`, `trips.png`

- [ ] **Step 1: Eyeball the existing captures**

Build a contact sheet of the candidate screens and open it:
```bash
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
"$FF" -y -i promo/work/home.png -i promo/work/food.png -i promo/work/charts.png \
      -i promo/work/health.png -i promo/work/steps.png -i promo/work/activities.png \
      -i promo/work/dailylog.png -i promo/work/memories.png -i promo/work/bucket.png \
      -i promo/work/trips.png \
  -filter_complex "[0][1][2][3][4][5][6][7][8][9]xstack=inputs=10:layout=0_0|w0_0|w0+w1_0|0_h0|w0_h0|w0+w1_h0|0_h0+h3|w0_h0+h3|w0+w1_h0+h3|w0+w1+w2_0,scale=1280:-1[v]" \
  -map "[v]" -frames:v 1 promo/v5/work/screens_check.png -loglevel error
```
Then open with `Invoke-Item promo/v5/work/screens_check.png` (PowerShell) and check: data looks seeded ("Martin" persona, populated charts), UI is current, no error states.
Expected: a single sheet image; you visually confirm each screen.

- [ ] **Step 2: Re-seed + re-capture any stale screen (only if Step 1 shows problems)**

If any screen is stale/empty: boot the emulator, re-seed (app → **More** → **Dev: design system** → **Данни** → **"Зареди примерни данни"**, per `promo/VIDEOS.md` §4), navigate to each stale module, and capture:
```bash
# example for the food screen; repeat per stale module with the right filename
MSYS_NO_PATHCONV=1 adb exec-out screencap -p > promo/work/food.png
```
Expected: each re-captured PNG opens and shows current seeded data. Re-run Step 1's sheet to confirm. (`adb screenrecord` is broken on this emulator — stills only.)

- [ ] **Step 3: Commit any new/updated captures**

Only if screens were re-captured (skip if all were already current):
```bash
git add promo/work/*.png
git commit -m "promo: refresh app screens for video #5 explainer"
```
Expected: commit succeeds, or nothing to commit if no captures changed.

---

## Task 3: Source and grade-test the desk/builder B-roll

The desk bookends (beats 1 & 13) are the one net-new asset and the main risk (can look stock-y). Source 2–3 short clips and prove the grade reads well before building beats.

**Files:**
- Create: `promo/v5/work/desk1.mp4`, `promo/v5/work/desk2.mp4` (raw `_tiny` clips), `promo/v5/work/desk_grade_check.png`

- [ ] **Step 1: Pull candidate clips from Pixabay**

Per `promo/VIDEOS.md` §4 (Pixabay, free commercial use, no attribution). Try several queries; download 2–3 `_tiny.mp4`:
```bash
for q in "programmer-coding" "developer-desk-coffee" "typing-keyboard"; do
  curl -sL -A "Mozilla/5.0" "https://pixabay.com/videos/search/$q/" \
    | grep -oE "https://cdn\.pixabay\.com/video/[^\"\\ ]+_tiny\.mp4" | sort -u | head -3
done
```
Pick two that read as "person building software at a desk" (hands on keyboard, code on screen, warm/low light). Download:
```bash
curl -L "<chosen_url_1>" -o promo/v5/work/desk1.mp4
curl -L "<chosen_url_2>" -o promo/v5/work/desk2.mp4
ls -la promo/v5/work/desk1.mp4 promo/v5/work/desk2.mp4
```
Expected: two non-empty `.mp4` files (>50 KB each).

- [ ] **Step 2: Grade-test one frame (the stock-y risk gate)**

Render one graded still and eyeball it — dark, desaturated, lightly blurred hero look (lighter blur than the heavy `sigma=26` background blur, since this is a hero shot):
```bash
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
"$FF" -y -i promo/v5/work/desk1.mp4 -vf \
"scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=8,eq=brightness=-0.15:saturation=0.7,vignette=PI/5" \
-frames:v 1 promo/v5/work/desk_grade_check.png -loglevel error
```
Open `promo/v5/work/desk_grade_check.png`. Expected: looks like a moody developer-at-work scene, not a bright stock clip. **If it looks stock-y and can't be saved by grading, invoke the spec's fallback (Task 5 alt-path): phone-mock-on-gradient bookends instead of desk B-roll.**

---

## Task 4: Write the 13 VO phrases, generate them, and measure durations

**Files:**
- Create: `promo/v5/vo_lines.txt`
- Create: `promo/v5/vo/p01.mp3` … `promo/v5/vo/p13.mp3`
- Create: `promo/v5/work/vo_durations.txt`

- [ ] **Step 1: Write the narration file (the 13 beats, in order)**

Create `promo/v5/vo_lines.txt` with exactly these lines (one phrase per line; the percent in beat 4 is spoken, not drawn — safe for TTS):
```
I wanted to remember my whole life. So I built an app for it.
Everything that matters, in one place. Fully offline, no account.
I log what I eat.
And where the money goes. Turns out forty-seven percent went to food.
Blood pressure, meds, lab results.
Every step.
Every workout.
A quick daily check-in, and my mood.
A visual diary of the moments.
The things I still want to do.
And every trip I take.
Then I export all of it, and let A.I. tell me what I am missing.
It is called LifeMaxxing. I built it for me. Now it is yours too.
```

- [ ] **Step 2: Generate one mp3 per line with edge-tts**

Voice `en-US-AndrewNeural`, `--rate=+6%` (warm/confident, series-consistent — `promo/VIDEOS.md` §4):
```bash
i=0
while IFS= read -r line; do
  i=$((i+1)); idx=$(printf "%02d" $i)
  python -m edge_tts --voice en-US-AndrewNeural --rate=+6% --text "$line" --write-media "promo/v5/vo/p$idx.mp3"
done < promo/v5/vo_lines.txt
ls -1 promo/v5/vo/p*.mp3 | wc -l
```
Expected: prints `13` (thirteen mp3 files created). If `edge_tts` is missing: `pip install edge-tts`.

- [ ] **Step 3: Measure each phrase's duration (drives beat timing in Tasks 5 & 7)**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
: > promo/v5/work/vo_durations.txt
for i in $(seq 1 13); do idx=$(printf "%02d" $i);
  d=$("$FP" -v error -show_entries format=duration -of csv=p=0 "promo/v5/vo/p$idx.mp3")
  printf "p%s %s\n" "$idx" "$d" | tee -a promo/v5/work/vo_durations.txt
done
```
Expected: 13 lines like `p06 0.9`. **Record these — each beat's length in Task 5 must be `≥ phrase duration + 0.3s`.** If any module phrase is longer than its target beat (Task 5 table), bump that beat's duration to fit.

- [ ] **Step 4: Commit the narration source**

```bash
git add promo/v5/vo_lines.txt
git commit -m "promo: add video #5 builder-explainer narration script"
```
Expected: commit succeeds. (mp3s + durations live under gitignored `vo/`/`work/`.)

---

## Task 5: Write `render_v5.sh` (build beats → silent cut)

**Files:**
- Create: `promo/v5/render_v5.sh`

Beat timing target (sum ≈ 52.8s; retime per Task 4 Step 3 measurements):

| seg | beat | dur (s) | start (s) |
|-----|------|---------|-----------|
| s01 | desk intro | 5.0 | 0.0 |
| s02 | home (full) | 4.0 | 5.0 |
| s03 | food | 3.0 | 9.0 |
| s04 | money | 3.2 | 12.0 |
| s05 | health | 3.0 | 15.2 |
| s06 | steps | 2.8 | 18.2 |
| s07 | activities | 2.8 | 21.0 |
| s08 | daily log | 3.0 | 23.8 |
| s09 | diary | 3.0 | 26.8 |
| s10 | bucket | 3.0 | 29.8 |
| s11 | trips | 3.0 | 32.8 |
| s12 | AI export (phone-mock) | 2.5 | 35.8 |
| s13 | AI card (chips) | 4.0 | 38.3 |
| s14 | desk outro | 4.0 | 42.3 |
| s15 | endcard | 6.5 | 46.3 |

- [ ] **Step 1: Write the script**

Create `promo/v5/render_v5.sh`:
```bash
#!/usr/bin/env bash
# Video #5 "I built an app to track my entire life" — builder explainer.
# Desk B-roll bookends + full-frame 9-module tour + AI payoff (reuses #4) + CTA.
# Silent cut; audio via mux_v5.sh.
set -e
cd "$(dirname "$0")/../.."   # repo root
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v5/work"; OUT="promo/v5/out"; mkdir -p "$W" "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"
PB="promo/v2/work/phone_body.png"; MK="promo/v2/work/screen_mask.png"
[ -f "$PB" ] && [ -f "$MK" ] || python promo/make_phone_frame.py
[ -f "$W/../../v4/work/chip_chatgpt.png" ] || python promo/v4/make_ai_chips.py
CHIP="promo/v4/work"
GRAD="$W/grad.png"
"$FF" -y -f lavfi -i "gradients=s=1080x1920:c0=0x1A2738:c1=0x070910:x0=0:y0=0:x1=1080:y1=1920" -frames:v 1 "$GRAD" -loglevel error

# make_full <app_png> <dur> <captext> <capcolor> <out>
# Full-frame app showcase: sharp screen fit-to-frame over a blurred fill of itself, slow push-in, top caption.
make_full(){ local app="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -loop 1 -i "$app" \
   -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=24,eq=brightness=-0.20:saturation=1.05[bg];\
[0:v]scale=1080:1920:force_original_aspect_ratio=decrease,setsar=1[fg];\
[bg][fg]overlay=(W-w)/2:(H-h)/2[c];\
[c]zoompan=z='1.03+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=58:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.45:boxborderw=24:alpha='if(lt(t,0.25),t/0.25,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

# make_desk <broll> <dur> <captext> <capcolor> <out>
# Builder bookend: graded desk B-roll (lighter blur = hero shot), gentle push-in, top caption.
make_desk(){ local broll="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -i "$broll" \
   -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=8,eq=brightness=-0.15:saturation=0.7,vignette=PI/5[bg];\
[bg]zoompan=z='1.04+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=60:x=(w-text_w)/2:y=h*0.78:box=1:boxcolor=black@0.45:boxborderw=26:alpha='if(lt(t,0.3),t/0.3,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

# make_phone <app_png> <dur> <cap> <col> <out>  (phone-mock over gradient — for the export beat; from #4)
make_phone(){ local app="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$PB" -loop 1 -i "$app" -loop 1 -i "$MK" \
   -filter_complex "[2:v]crop=1280:2610:0:123,scale=620:1264,setsar=1,format=rgba[av];[3:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];[0:v][mock]overlay=(W-w)/2:(H-h)/2:shortest=1[c];\
[c]zoompan=z='1.03+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=56:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.45:boxborderw=24:alpha='if(lt(t,0.25),t/0.25,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== s01 desk intro =="
make_desk promo/v5/work/desk1.mp4 5.0 'I built an app to track my entire life' 0xFFFFFF "$W/s01.mp4"

echo "== s02-s11 full-frame module tour =="
make_full promo/work/home.png       4.0 'One app. Everything. Offline.' 0xFFFFFF "$W/s02.mp4"
make_full promo/work/food.png       3.0 'FOOD'                          0xF5C36B "$W/s03.mp4"
make_full promo/work/charts.png     3.2 'MONEY - 47 percent on food'    0x5FD08A "$W/s04.mp4"
make_full promo/work/health.png     3.0 'HEALTH - avg 127/78'           0xFF9EC4 "$W/s05.mp4"
make_full promo/work/steps.png      2.8 'STEPS - 294,399 in 30 days'    0xC9A8FF "$W/s06.mp4"
make_full promo/work/activities.png 2.8 'TRAINING - 25 sessions, 38h'   0x6AA8FF "$W/s07.mp4"
make_full promo/work/dailylog.png   3.0 'DAILY LOG - mood 7.5'          0xFFFFFF "$W/s08.mp4"
make_full promo/work/memories.png   3.0 'DIARY'                         0xFFFFFF "$W/s09.mp4"
make_full promo/work/bucket.png     3.0 'BUCKET LIST'                   0x5FD08A "$W/s10.mp4"
make_full promo/work/trips.png      3.0 'TRIPS'                         0x6AA8FF "$W/s11.mp4"

echo "== s12 AI export (phone-mock) =="
make_phone promo/work/more_bottom2.png 2.5 '1 TAP - EXPORT FOR AI' 0x6AA8FF "$W/s12.mp4"

echo "== s13 AI card (logo chips, from #4) =="
"$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$CHIP/chip_chatgpt.png" -loop 1 -i "$CHIP/chip_claude.png" -loop 1 -i "$CHIP/chip_gemini.png" \
 -filter_complex "[1:v]scale=300:-1,format=rgba,fade=t=in:st=0.10:d=0.3:alpha=1[c1];\
[2:v]scale=300:-1,format=rgba,fade=t=in:st=0.35:d=0.3:alpha=1[c2];\
[3:v]scale=300:-1,format=rgba,fade=t=in:st=0.60:d=0.3:alpha=1[c3];\
[0:v]drawtext=fontfile='${FONT}':text='ASK ANY AI':fontcolor=white:fontsize=58:x=(w-text_w)/2:y=h*0.22[bg];\
[bg][c1]overlay=x=60:y=(H-h)/2:shortest=1[o1];[o1][c2]overlay=x=390:y=(H-h)/2[o2];[o2][c3]overlay=x=720:y=(H-h)/2,format=yuv420p[v]" \
 -map "[v]" -t 4.0 "$W/s13.mp4" -loglevel error

echo "== s14 desk outro =="
make_desk promo/v5/work/desk2.mp4 4.0 'Built for me. Now yours too.' 0x5FD08A "$W/s14.mp4"

echo "== s15 endcard (brand + CTA) =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
 -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Track your whole life':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 195 "$W/s15.mp4" -loglevel error

echo "== concat =="
L="$W/list_v5.txt"; : > "$L"
for s in s01 s02 s03 s04 s05 s06 s07 s08 s09 s10 s11 s12 s13 s14 s15; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v5_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v5_silent.mp4" -loglevel error
echo "DONE -> $OUT/v5_silent.mp4"
```

- [ ] **Step 2: Make it executable and commit the script**

```bash
chmod +x promo/v5/render_v5.sh
git add promo/v5/render_v5.sh
git commit -m "promo: add video #5 render script (builder explainer)"
```
Expected: commit succeeds.

---

## Task 6: Render the silent cut and verify it

**Files:**
- Produces: `promo/v5/out/v5_silent.mp4`, `promo/v5/work/v5_contact.png`

- [ ] **Step 1: Run the render**

```bash
bash promo/v5/render_v5.sh
```
Expected: prints each `== sNN ==` line then `DONE -> promo/v5/out/v5_silent.mp4`. No ffmpeg errors. If a `make_full` errors on a screen, the PNG is likely missing/misnamed — fix the path (Task 2) and re-run.

- [ ] **Step 2: Verify format + duration (the automated gate)**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FP" -v error -select_streams v:0 -show_entries stream=width,height,r_frame_rate,codec_name \
  -show_entries format=duration -of default=noprint_wrappers=1 promo/v5/out/v5_silent.mp4
```
Expected: `codec_name=h264`, `width=1080`, `height=1920`, `r_frame_rate=30/1`, and `duration` between **45 and 60** (target ~52.8). If duration is out of range, adjust beat `-t` values in `render_v5.sh` (Task 5 table) and re-render.

- [ ] **Step 3: Build a 1-fps contact sheet and eyeball every beat**

```bash
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
"$FF" -y -i promo/v5/out/v5_silent.mp4 -vf "fps=1,scale=216:384,tile=5x11" promo/v5/work/v5_contact.png -loglevel error
```
Open `promo/v5/work/v5_contact.png` (`Invoke-Item`). Check: desk intro reads as a builder scene (not stock-y); all 10 module screens are legible and current; captions clear the content and the phone (in s12); AI chips all visible on white; endcard icon + green CTA correct. Expected: all beats look right. If the desk beats look bad, switch s01/s14 to `make_phone`/gradient bookends (spec fallback) and re-render.

---

## Task 7: Write `mux_v5.sh` (VO cues + music → final)

**Files:**
- Create: `promo/v5/mux_v5.sh`

VO cue delays (ms from start) = each beat's start time + 150 ms (from the Task 5 table). **Recompute from the actual silent-cut beat boundaries if you retimed any beat.** Default array (13 cues):
`150 5150 9150 12150 15350 18350 21150 23950 26950 29950 32950 35950 42450`

- [ ] **Step 1: Write the script**

Create `promo/v5/mux_v5.sh` (music = `music_v2.wav` looped to cover ~53s, ducked low under VO; final `loudnorm`). Note `MUSDUR` and the music `afade out` start should match the silent-cut duration from Task 6 Step 2:
```bash
#!/usr/bin/env bash
# Mux video #5: 13 VO phrases at their cues + music bed under -> loudnorm.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
VID="promo/v5/out/v5_silent.mp4"; OUT="promo/v5/out/v5_final.mp4"
MUSIC="promo/v2/work/music_v2.wav"
DUR=$("$FP" -v error -show_entries format=duration -of csv=p=0 "$VID")
FADEOUT=$(awk "BEGIN{print $DUR-0.8}")
delays=(150 5150 9150 12150 15350 18350 21150 23950 26950 29950 32950 35950 42450)
n=${#delays[@]}
ins=""; fc=""; mixin=""
for i in $(seq 1 $n); do idx=$(printf "%02d" $i); ins="$ins -i promo/v5/vo/p$idx.mp3";
  d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
M=$((n+1))
# music: input index $M; loop it (-stream_loop) so a 20s bed covers the full video.
"$FF" -y -i "$VID" $ins -stream_loop 4 -i "$MUSIC" \
 -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${M}:a]atrim=0:${DUR},volume=0.24,afade=t=in:st=0:d=0.5,afade=t=out:st=${FADEOUT}:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
 -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
```

- [ ] **Step 2: Make executable and commit**

```bash
chmod +x promo/v5/mux_v5.sh
git add promo/v5/mux_v5.sh
git commit -m "promo: add video #5 mux script (VO + music)"
```
Expected: commit succeeds.

---

## Task 8: Mux the final and verify it (audio + format + watch)

**Files:**
- Produces: `promo/v5/out/v5_final.mp4`

- [ ] **Step 1: Run the mux**

```bash
bash promo/v5/mux_v5.sh
```
Expected: prints `DONE -> promo/v5/out/v5_final.mp4`, no errors.

- [ ] **Step 2: Verify the final has video + audio, correct format, in-range duration**

```bash
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
"$FP" -v error -show_entries stream=codec_type,codec_name -show_entries format=duration,size,bit_rate \
  -of default=noprint_wrappers=1 promo/v5/out/v5_final.mp4
```
Expected: one `codec_type=video`/`codec_name=h264` and one `codec_type=audio`/`codec_name=aac`; `duration` 45–60s. Note the `bit_rate` — flag if it drops far below the series' ~1.4–2.6 Mbps (video #4 shipped at 0.43 Mbps; aim higher here).

- [ ] **Step 3: Watch it (the real gate) — VO sync + music balance**

Open and watch end-to-end:
```bash
# PowerShell:
Invoke-Item promo/v5/out/v5_final.mp4
```
Check: each VO phrase lands on its beat (no drift by the end); music sits under the voice (not over it); no clipping; desk bookends + module captions + endcard all read. Expected: it plays clean. If VO drifts, recompute `delays` from the actual beat boundaries (Task 7) and re-mux. If music is too loud/quiet, adjust `volume=0.24` and re-mux.

---

## Task 9: Log the video in `promo/VIDEOS.md`

**Files:**
- Modify: `promo/VIDEOS.md` (§1 history table, the per-video scripts list, and the "what worked" note + last-updated line)

- [ ] **Step 1: Add the history row to §1**

Add after the video #4 row in the table:
```markdown
| 5 | **I Built an App to Track My Entire Life** | *Builder story / explainer* — first-person founder tour of the whole app (all 9 modules) → AI export → CTA | Desk-B-roll bookends + full-frame module tour + phone-mock AI payoff (#4 reuse) | 53s | ✅ done | `promo/v5/out/v5_final.mp4` |
```

- [ ] **Step 2: Add the per-video build-scripts line**

Under the "Per-video build scripts" list:
```markdown
- **#5:** `promo/v5/render_v5.sh` · `promo/v5/mux_v5.sh` (full-frame `make_full` + desk `make_desk` beat builders; reuses #2 phone frame/music + #4 AI chips)
```

- [ ] **Step 3: Update the "what worked / try next" note and last-updated line**

Replace the final `*Last updated after video #4...*` line with a short note covering: how the **builder-story** angle and the **desk B-roll** format landed (did the desk read authentic or stock-y? did 9 even module beats feel like a tour or a list? was 53s the right length for an explainer?), plus the new `*Last updated after video #5.*` line.

- [ ] **Step 4: Commit**

```bash
git add promo/VIDEOS.md
git commit -m "promo: log video #5 (builder explainer) in VIDEOS.md"
```
Expected: commit succeeds.

---

## Self-Review (completed by plan author)

- **Spec coverage:** Length 45–60s → Task 6/8 duration gate. Builder story → desk bookends (Task 3/5 s01,s14) + first-person VO (Task 4). TTS Andrew → Task 4 Step 2. All 9 modules even → Task 5 s03–s11 + home s02. Format C → `make_desk` bookends + `make_full` tour. AI payoff reuse → s12/s13. Real seed numbers → captions in s04–s08 + VO line 4. Assets (desk B-roll, screens, chips, phone, music, voice) → Tasks 1–4. Verification (ffprobe + contact sheet + watch) → Tasks 6 & 8. Logging → Task 9. Risks (stock-y desk, runtime creep, stale screens) → Task 3 Step 2 gate + fallback, Task 6/8 duration gates, Task 2. All spec sections map to tasks.
- **Placeholder scan:** B-roll URLs in Task 3 are intentionally chosen-at-runtime (`<chosen_url_1>`) because the specific Pixabay clip can't be known ahead of sourcing — the query commands and selection criteria are concrete. No other placeholders.
- **Type/name consistency:** segment names `s01`–`s15` consistent across `render_v5.sh`, the concat list, and the contact-sheet tile (`5x11`=55 cells ≥ ~53 frames). VO files `p01`–`p13` consistent across Task 4, the `delays` array length (13), and `mux_v5.sh`. Function names `make_full`/`make_desk`/`make_phone` used as defined.
```
