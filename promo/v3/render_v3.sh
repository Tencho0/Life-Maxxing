#!/usr/bin/env bash
# Video #3 "30 days taught me" — phone mockup over themed, blurred B-roll, with
# data-insight captions synced to the VO. Silent cut; audio via mux_v3.sh.
set -e
cd "$(dirname "$0")/../.."   # repo root
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v3/work"; OUT="promo/v3/out"; mkdir -p "$W" "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"
PB="promo/v2/work/phone_body.png"; MK="promo/v2/work/screen_mask.png"
[ -f "$PB" ] && [ -f "$MK" ] || python promo/make_phone_frame.py

# make_insight <app_png> <broll> <dur> <captext> <capcolor> <out>
make_insight(){ local app="$1" broll="$2" dur="$3" cap="$4" col="$5" o="$6"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -i "$broll" -loop 1 -i "$PB" -loop 1 -i "$app" -loop 1 -i "$MK" \
    -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=26,eq=brightness=-0.17:saturation=1.12[bg];\
[2:v]crop=1280:2610:0:123,scale=620:1264,setsar=1,format=rgba[av];[3:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];\
[bg][mock]overlay=(W-w)/2:(H-h)/2[c];\
[c]zoompan=z='1.03+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=58:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.45:boxborderw=24:alpha='if(lt(t,0.25),t/0.25,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
    -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== insight beats =="
make_insight promo/work/home.png    promo/v3/broll/hike1.mp4  3.5 '30 DAYS, TRACKED'             0xFFFFFF "$W/s1.mp4"
make_insight promo/work/current.png promo/v3/broll/food2.mp4  2.2 'Half my money on food'        0xF5C36B "$W/s2.mp4"
make_insight promo/work/steps.png   promo/v3/broll/run2.mp4   2.8 '294,000 steps'                0xC9A8FF "$W/s3.mp4"
make_insight promo/work/charts.png  promo/v3/broll/gym2.mp4   2.5 'Mood higher on training days' 0x6AA8FF "$W/s4.mp4"
make_insight promo/work/health.png  promo/v3/broll/dinner1.mp4 2.9 'BP spikes on salty dinners'  0xFF9EC4 "$W/s5.mp4"

echo "== endcard (brand + CTA) =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
  -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Track your whole life':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 69 "$W/s6.mp4" -loglevel error

echo "== concat =="
L="$W/list_v3.txt"; : > "$L"
for s in s1 s2 s3 s4 s5 s6; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v3_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v3_silent.mp4" -loglevel error
echo "DONE -> $OUT/v3_silent.mp4"
