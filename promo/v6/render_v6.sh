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

# make_broll <clip> <dur> <cool|warm> <out> <ss>
# Graded full-frame B-roll, gentle push-in, light grain, in/out fades. No caption (story beats).
make_broll(){ local clip="$1" dur="$2" mode="$3" o="$4" ss="${5:-0}"; local NN=$(awk "BEGIN{print $dur*30-1}")
  local fo=$(awk "BEGIN{print $dur-0.3}") grade
  if [ "$mode" = "warm" ]; then
    grade="eq=brightness=0.04:saturation=1.10:contrast=1.04,colorbalance=rm=0.06:gm=0.02:bm=-0.06,vignette=PI/5"
  else
    grade="eq=brightness=-0.04:saturation=0.78:contrast=1.03,colorbalance=rm=-0.04:bm=0.05,vignette=PI/4.5"
  fi
  "$FF" -y -stream_loop -1 -ss "$ss" -i "$clip" -filter_complex "\
[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,setsar=1,${grade},\
zoompan=z='1.04+0.06*on/${NN}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
noise=alls=7:allf=t,\
fade=t=in:st=0:d=0.3,fade=t=out:st=${fo}:d=0.3,format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== s01-s04 B-roll story (no app) =="
make_broll "$W/b1.mp4" 3.4 cool "$W/s01.mp4" 0.5
make_broll "$W/b2.mp4" 2.0 warm "$W/s02.mp4" 2.0
make_broll "$W/b3.mp4" 3.4 warm "$W/s03.mp4" 1.0
make_broll "$W/b4.mp4" 2.5 cool "$W/s04.mp4" 1.0

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
 -map "[v]" -t 4.3 "$W/s05base.mp4" -loglevel error

echo "== s05b reveal: overlay connect-the-dots sequence + caption =="
"$FF" -y -i "$W/s05base.mp4" -framerate 30 -i "$W/dots/dots_%03d.png" \
 -filter_complex "[0:v][1:v]overlay=0:0:shortest=1,\
drawtext=fontfile='${FONT}':text='Higher mood on training days':fontcolor=0x5FD08A:fontsize=52:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.5:boxborderw=22:enable='gte(t,1.6)':alpha='if(lt(t,1.6),0,if(lt(t,1.9),(t-1.6)/0.3,1))',format=yuv420p[v]" \
 -map "[v]" -t 4.3 "$W/s05.mp4" -loglevel error

echo "== s06 endcard (brand + CTA) =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
 -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Track your whole life':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 126 "$W/s06.mp4" -loglevel error

echo "== concat =="
L="$W/list_v6.txt"; : > "$L"
for s in s01 s02 s03 s04 s05 s06; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v6_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v6_silent.mp4" -loglevel error
echo "DONE -> $OUT/v6_silent.mp4"
