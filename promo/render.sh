#!/usr/bin/env bash
# Renders the 15s 9:16 LifeMaxxing data-dopamine promo (visual cut, silent).
# Sources: promo/work/*.png (1280x2856 emulator stills). Output: promo/out/.
set -e
cd "$(dirname "$0")/.."   # repo root

FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/work"
OUT="promo/out"
mkdir -p "$OUT"

# Pick a bold font present on Windows
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'
elif [ -f "/c/Windows/Fonts/segoeuib.ttf" ]; then FONT='C\:/Windows/Fonts/segoeuib.ttf'
else FONT='C\:/Windows/Fonts/arial.ttf'; fi
echo "Using font: $FONT"

# Crop the 1280x2856 phone frame to exact 9:16 (1280x2276) then scale to 1080x1920.
CROP_H=2276

# render_beat  out  img  frames  cropY  mode(push|settle|out)  label  color  fontsize  tdelay
render_beat() {
  local out="$1" img="$2" frames="$3" cropy="$4" mode="$5" label="$6" color="$7" fs="$8" tdelay="$9"
  local nm=$((frames-1))
  local z
  case "$mode" in
    push)   z="1.0+0.09*on/$nm" ;;
    settle) z="1.10-0.10*on/$nm" ;;
    out)    z="1.14-0.14*on/$nm" ;;
  esac
  "$FF" -y -loop 1 -framerate 30 -i "$W/$img.png" \
    -filter_complex "[0:v]crop=1280:${CROP_H}:0:${cropy},scale=1080:1920,setsar=1,\
zoompan=z='${z}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920[bg];\
[bg]drawtext=fontfile='${FONT}':text='${label}':fontcolor=${color}:fontsize=${fs}:\
x=(w-text_w)/2:y=h*0.745:box=1:boxcolor=black@0.42:boxborderw=26:\
alpha='if(lt(t,0.15),t/0.15,1)':enable='gte(t,${tdelay})',format=yuv420p[v]" \
    -map "[v]" -frames:v "$frames" -c:v libx264 -pix_fmt yuv420p -profile:v high -crf 18 -preset medium "$W/$out.mp4" \
    -loglevel error
  echo "  rendered $out ($frames f)"
}

echo "== beats =="
render_beat seg_01 home       60 210 push   "YOUR WHOLE LIFE"  0xFFFFFF 68 0.45
render_beat seg_02 food       30 180 settle "FOOD & CALORIES"  0xF5C36B 58 0
render_beat seg_03 current    30 180 push   "MONEY"            0x5FD08A 64 0
render_beat seg_04 activities 30 180 settle "WORKOUTS"         0x6AA8FF 64 0
render_beat seg_05 health     30 180 push   "HEALTH"           0xFF9EC4 64 0
render_beat seg_06 steps      30 180 settle "STEPS"            0xC9A8FF 64 0
render_beat seg_07 trips      30 180 push   "TRIPS"            0x5FD08A 64 0
render_beat seg_08 memories   30 150 settle "MEMORIES"         0xF5C36B 64 0
render_beat seg_09 bucket     15 180 push   "GOALS"            0x6AA8FF 60 0
render_beat seg_10 dailylog   15 180 settle "EVERY DAY"        0xF5C36B 60 0
render_beat seg_11 charts     60 210 out    "ALL IN ONE APP"   0xFFFFFF 64 0

echo "== brand card =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i assets/branding/icon-1024.png \
  -filter_complex "[1:v]scale=440:440,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:(H-h)/2-150[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=96:x=(w-text_w)/2:y=H/2+170,\
drawtext=fontfile='${FONT}':text='Track your entire life':fontcolor=0x99A0AE:fontsize=44:x=(w-text_w)/2:y=H/2+300,\
fade=t=in:st=0:d=0.4,format=yuv420p[v]" \
  -map "[v]" -frames:v 45 -c:v libx264 -pix_fmt yuv420p -profile:v high -crf 18 -preset medium "$W/seg_12.mp4" -loglevel error
echo "  rendered seg_12 (brand)"

echo "== cta card =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i assets/branding/icon-1024.png \
  -filter_complex "[1:v]scale=240:240,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-380[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=66:x=(w-text_w)/2:y=H/2-90,\
drawbox=x=220:y=1020:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1055,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" \
  -map "[v]" -frames:v 45 -c:v libx264 -pix_fmt yuv420p -profile:v high -crf 18 -preset medium "$W/seg_13.mp4" -loglevel error
echo "  rendered seg_13 (cta)"

echo "== concat =="
LIST="$W/list.txt"
: > "$LIST"
for n in 01 02 03 04 05 06 07 08 09 10 11 12 13; do echo "file 'seg_${n}.mp4'" >> "$LIST"; done
"$FF" -y -f concat -safe 0 -i "$LIST" -c copy "$W/concat.mp4" -loglevel error || {
  echo "  copy-concat failed, re-encoding"; "$FF" -y -f concat -safe 0 -i "$LIST" -c:v libx264 -pix_fmt yuv420p -crf 18 "$W/concat.mp4" -loglevel error; }

echo "== add silent audio track =="
"$FF" -y -i "$W/concat.mp4" -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 \
  -map 0:v -map 1:a -c:v copy -c:a aac -shortest "$OUT/lifemaxxing_promo_v1_silent.mp4" -loglevel error

echo "DONE -> $OUT/lifemaxxing_promo_v1_silent.mp4"
