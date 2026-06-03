#!/usr/bin/env bash
# Video #2 "A day in my life" — clean phone mockup (NO hand) on a dark gradient,
# real app frames inside, full-screen charts payoff, brand/CTA, VO-synced captions.
set -e
cd "$(dirname "$0")/../.."   # repo root
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v2/work"; OUT="promo/v2/out"; mkdir -p "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"; GRAD="$W/grad.png"
[ -f "$W/phone_body.png" ] && [ -f "$W/screen_mask.png" ] || python promo/make_phone_frame.py

"$FF" -y -f lavfi -i "gradients=s=1080x1920:c0=0x1A2738:c1=0x070910:x0=0:y0=0:x1=1080:y1=1920" -frames:v 1 "$GRAD" -loglevel error

# assemble screencaps -> crop to screen aspect -> scale to screen size -> interpolate to 30fps
make_appclip(){ local d="$1" fr="$2" o="$3"
  "$FF" -y -framerate "$fr" -start_number 1 -i "$d/f%02d.png" \
    -vf "crop=1280:2610:0:123,scale=620:1264,setsar=1,minterpolate=fps=30:mi_mode=mci:me_mode=bidir:mc_mode=aobmc" \
    -pix_fmt yuv420p "$o" -loglevel error; }

# overlay app into the phone frame (rounded), float on gradient, push-in
make_inphone(){ local app="$1" dur="$2" z0="$3" z1="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$W/phone_body.png" -i "$app" -loop 1 -i "$W/screen_mask.png" \
    -filter_complex "[2:v]format=rgba[av];[3:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];\
[0:v][mock]overlay=(W-w)/2:(H-h)/2:shortest=1[c];\
[c]zoompan=z='${z0}+(${z1}-${z0})*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,format=yuv420p[v]" \
    -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== app clips =="
[ -f "$W/clip_home.mp4" ]   || make_appclip "$W/../seq"        7 "$W/clip_home.mp4"
[ -f "$W/clip_log.mp4" ]    || make_appclip "$W/../seq_log"    5 "$W/clip_log.mp4"
[ -f "$W/clip_charts.mp4" ] || make_appclip "$W/../seq_charts" 7 "$W/clip_charts.mp4"

echo "== s1 morning (clean) =="
"$FF" -y -loop 1 -framerate 30 -i promo/v2/morning/m4.jpg \
  -vf "scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,zoompan=z='1.06+0.06*on/89':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,eq=brightness=-0.03:saturation=1.05,fade=t=in:st=0:d=0.6,format=yuv420p" \
  -frames:v 90 "$W/s1.mp4" -loglevel error

echo "== s2 home / s3 log / s4 charts (in-phone) =="
make_inphone "$W/clip_home.mp4"   3.9 1.02 1.07 "$W/s2.mp4"
make_inphone "$W/clip_log.mp4"    3.5 1.05 1.10 "$W/s3.mp4"
make_inphone "$W/clip_charts.mp4" 3.0 1.04 1.10 "$W/s4.mp4"

echo "== s5 charts in-phone (mock) — gentle push, framed like the rest =="
make_inphone "$W/clip_charts.mp4" 3.43 1.04 1.10 "$W/s5.mp4"

echo "== s6 brand =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
  -filter_complex "[1:v]scale=440:440,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:(H-h)/2-150[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=96:x=(w-text_w)/2:y=H/2+170,\
drawtext=fontfile='${FONT}':text='Your life, leveled up':fontcolor=0x99A0AE:fontsize=44:x=(w-text_w)/2:y=H/2+300,\
fade=t=in:st=0:d=0.4,format=yuv420p[v]" -map "[v]" -frames:v 45 "$W/s6.mp4" -loglevel error

echo "== s7 cta =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
  -filter_complex "[1:v]scale=240:240,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-380[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=66:x=(w-text_w)/2:y=H/2-90,\
drawbox=x=220:y=1020:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1055,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 45 "$W/s7.mp4" -loglevel error

echo "== concat =="
L="$W/list_v2.txt"; : > "$L"
for s in s1 s2 s3 s4 s5 s6 s7; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$W/v2_concat.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$W/v2_concat.mp4" -loglevel error

echo "== VO-synced captions =="
# cap <text> <start> <end>  drawn at top, fade in/out, synced to the VO cues
cap(){ local t="$1" s="$2" e="$3"
  echo "drawtext=fontfile='${FONT}':text='${t}':fontcolor=white:fontsize=56:x=(w-text_w)/2:y=h*0.10:box=1:boxcolor=black@0.40:boxborderw=24:enable='between(t,${s},${e})':alpha='if(lt(t,${s}+0.25),(t-${s})/0.25,if(lt(t,${e}-0.25),1,(${e}-t)/0.25))'"; }
CAPS="$(cap 'Run your whole life from one app' 0.3 2.9),$(cap 'Meals. Money.' 3.2 4.9),$(cap 'Training. Health.' 5.0 6.8),$(cap 'Steps. Trips. Memories.' 7.0 10.2),$(cap 'All in one private place' 10.6 13.2),$(cap 'It all becomes insight' 13.6 16.6)"
"$FF" -y -i "$W/v2_concat.mp4" -vf "${CAPS},format=yuv420p" -c:v libx264 -pix_fmt yuv420p -crf 18 -preset medium "$OUT/v2_silent.mp4" -loglevel error
echo "DONE -> $OUT/v2_silent.mp4"
