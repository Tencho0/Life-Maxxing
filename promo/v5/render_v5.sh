#!/usr/bin/env bash
# Video #5 "I built an app to track my entire life" — builder explainer.
# Desk B-roll bookends + full-frame 9-module tour + AI payoff (reuses #4) + CTA.
# Silent cut; audio via mux_v5.sh. Beat durations are retimed to the measured VO
# (promo/v5/work/vo_durations.txt); total ~55.1s.
set -e
cd "$(dirname "$0")/../.."   # repo root
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v5/work"; OUT="promo/v5/out"; mkdir -p "$W" "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"
PB="promo/v2/work/phone_body.png"; MK="promo/v2/work/screen_mask.png"
[ -f "$PB" ] && [ -f "$MK" ] || python promo/make_phone_frame.py
CHIP="promo/v4/work"
[ -f "$CHIP/chip_chatgpt.png" ] || python promo/v4/make_ai_chips.py
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
# Builder bookend: graded desk B-roll (lighter blur = hero shot), gentle push-in, lower-third caption.
make_desk(){ local broll="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -i "$broll" \
   -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=8,eq=brightness=-0.15:saturation=0.7,vignette=PI/5[bg];\
[bg]zoompan=z='1.04+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=60:x=(w-text_w)/2:y=h*0.78:box=1:boxcolor=black@0.45:boxborderw=26:alpha='if(lt(t,0.3),t/0.3,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

# make_phone <app_png> <dur> <cap> <col> <out>  (phone-mock over gradient — export beat; from #4)
make_phone(){ local app="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$PB" -loop 1 -i "$app" -loop 1 -i "$MK" \
   -filter_complex "[2:v]crop=1280:2610:0:123,scale=620:1264,setsar=1,format=rgba[av];[3:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];[0:v][mock]overlay=(W-w)/2:(H-h)/2:shortest=1[c];\
[c]zoompan=z='1.03+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=56:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.45:boxborderw=24:alpha='if(lt(t,0.25),t/0.25,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== s01 hook opener (energetic: cinematic keyboard, fast push-in) =="
HN=$(awk "BEGIN{print 5.0*30-1}")
"$FF" -y -i "$W/hook.mp4" -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,gblur=sigma=4,eq=brightness=-0.04:saturation=1.15:contrast=1.08,vignette=PI/6[bg];\
[bg]zoompan=z='1.05+0.13*on/${HN}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='I built an app to track my entire life':fontcolor=0xFFFFFF:fontsize=60:x=(w-text_w)/2:y=h*0.78:box=1:boxcolor=black@0.5:boxborderw=26:alpha='if(lt(t,0.2),t/0.2,if(lt(t,4.7),1,(5.0-t)/0.3))',format=yuv420p[v]" \
 -map "[v]" -t 5.0 "$W/s01.mp4" -loglevel error

echo "== s02-s11 full-frame module tour =="
make_full promo/work/home.png       4.8 'One app. Everything. Offline.' 0xFFFFFF "$W/s02.mp4"
make_full promo/work/food.png       3.0 'FOOD'                          0xF5C36B "$W/s03.mp4"
make_full promo/work/current.png    4.3 'MONEY - 47 percent on food'    0x5FD08A "$W/s04.mp4"
make_full promo/work/health.png     3.2 'HEALTH - avg 127/78'           0xFF9EC4 "$W/s05.mp4"
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
make_desk "$W/desk2.mp4" 4.2 'Built for me. Now yours too.' 0x5FD08A "$W/s14.mp4"

echo "== s15 endcard (brand + CTA) =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
 -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Track your whole life':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 75 "$W/s15.mp4" -loglevel error

echo "== concat =="
L="$W/list_v5.txt"; : > "$L"
for s in s01 s02 s03 s04 s05 s06 s07 s08 s09 s10 s11 s12 s13 s14 s15; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v5_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v5_silent.mp4" -loglevel error
echo "DONE -> $OUT/v5_silent.mp4"
