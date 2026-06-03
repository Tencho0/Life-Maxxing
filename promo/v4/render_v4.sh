#!/usr/bin/env bash
# Video #4 "Let your favorite AI analyze your life" — phone-mock (hook + export),
# AI logo row, dramatic MISTAKES (red) -> FIX (green) reveal, brand/CTA.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
W="promo/v4/work"; OUT="promo/v4/out"; mkdir -p "$W" "$OUT"
if [ -f "/c/Windows/Fonts/arialbd.ttf" ]; then FONT='C\:/Windows/Fonts/arialbd.ttf'; else FONT='C\:/Windows/Fonts/arial.ttf'; fi
ICON="src/assets/branding/icon-1024.png"
PB="promo/v2/work/phone_body.png"; MK="promo/v2/work/screen_mask.png"
[ -f "$PB" ] && [ -f "$MK" ] || python promo/make_phone_frame.py
[ -f "$W/chip_chatgpt.png" ] && [ -f "$W/chip_claude.png" ] && [ -f "$W/chip_gemini.png" ] || python promo/v4/make_ai_chips.py
GRAD="$W/grad.png"
"$FF" -y -f lavfi -i "gradients=s=1080x1920:c0=0x1A2738:c1=0x070910:x0=0:y0=0:x1=1080:y1=1920" -frames:v 1 "$GRAD" -loglevel error
# red-tinted gradient for the "mistakes" beat
"$FF" -y -f lavfi -i "gradients=s=1080x1920:c0=0x2A1518:c1=0x0B0708:x0=0:y0=0:x1=1080:y1=1920" -frames:v 1 "$W/grad_red.png" -loglevel error

make_phone(){ local app="$1" dur="$2" cap="$3" col="$4" o="$5"; local N=$(awk "BEGIN{print $dur*30-1}")
  "$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$PB" -loop 1 -i "$app" -loop 1 -i "$MK" \
   -filter_complex "[2:v]crop=1280:2610:0:123,scale=620:1264,setsar=1,format=rgba[av];[3:v]format=gray[mk];[av][mk]alphamerge[appR];\
[1:v][appR]overlay=20:20[mock];[0:v][mock]overlay=(W-w)/2:(H-h)/2:shortest=1[c];\
[c]zoompan=z='1.03+0.05*on/${N}':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=1:fps=30:s=1080x1920,\
drawtext=fontfile='${FONT}':text='${cap}':fontcolor=${col}:fontsize=56:x=(w-text_w)/2:y=h*0.085:box=1:boxcolor=black@0.45:boxborderw=24:alpha='if(lt(t,0.25),t/0.25,if(lt(t,${dur}-0.3),1,(${dur}-t)/0.3))',format=yuv420p[v]" \
   -map "[v]" -t "$dur" "$o" -loglevel error; }

echo "== s1 hook + s2 export =="
make_phone promo/work/charts.png        2.3 '30 DAYS, TRACKED'      0xFFFFFF "$W/s1.mp4"
make_phone promo/work/more_bottom2.png  2.2 '1 TAP - EXPORT FOR AI' 0x6AA8FF "$W/s2.mp4"

echo "== s3 AI logo row =="
"$FF" -y -loop 1 -i "$GRAD" -loop 1 -i "$W/chip_chatgpt.png" -loop 1 -i "$W/chip_claude.png" -loop 1 -i "$W/chip_gemini.png" \
 -filter_complex "[1:v]scale=300:-1,format=rgba,fade=t=in:st=0.10:d=0.3:alpha=1[c1];\
[2:v]scale=300:-1,format=rgba,fade=t=in:st=0.35:d=0.3:alpha=1[c2];\
[3:v]scale=300:-1,format=rgba,fade=t=in:st=0.60:d=0.3:alpha=1[c3];\
[0:v]drawtext=fontfile='${FONT}':text='YOUR FAVORITE AI':fontcolor=white:fontsize=58:x=(w-text_w)/2:y=h*0.22[bg];\
[bg][c1]overlay=x=60:y=(H-h)/2:shortest=1[o1];[o1][c2]overlay=x=390:y=(H-h)/2[o2];[o2][c3]overlay=x=720:y=(H-h)/2,format=yuv420p[v]" \
 -map "[v]" -t 3.9 "$W/s3.mp4" -loglevel error

echo "== s4 MISTAKES (red reveal) =="
"$FF" -y -loop 1 -i "$W/grad_red.png" \
 -filter_complex "[0:v]\
drawtext=fontfile='${FONT}':text='3 MISTAKES FOUND':fontcolor=0xFF7A6B:fontsize=68:x=(w-text_w)/2:y=h*0.16:alpha='if(lt(t,0.25),t/0.25,1)',\
drawtext=fontfile='${FONT}':text='Money wasted on food':fontcolor=0xFF7A6B:fontsize=54:x=(w-text_w)/2:y=h*0.42:alpha='if(lt(t,2.6),0,min((t-2.6)/0.3,1))',\
drawtext=fontfile='${FONT}':text='Skipping workouts kills your mood':fontcolor=0xFF7A6B:fontsize=48:x=(w-text_w)/2:y=h*0.54:alpha='if(lt(t,3.4),0,min((t-3.4)/0.3,1))',\
drawtext=fontfile='${FONT}':text='Salt is spiking your blood pressure':fontcolor=0xFF7A6B:fontsize=46:x=(w-text_w)/2:y=h*0.66:alpha='if(lt(t,4.4),0,min((t-4.4)/0.3,1))',\
format=yuv420p[v]" -map "[v]" -t 8.0 "$W/s4.mp4" -loglevel error

echo "== s5 FIX (green payoff) =="
"$FF" -y -loop 1 -i "$GRAD" \
 -filter_complex "[0:v]\
drawtext=fontfile='${FONT}':text='HOW TO FIX IT':fontcolor=0x5FD08A:fontsize=68:x=(w-text_w)/2:y=h*0.16:alpha='if(lt(t,0.25),t/0.25,1)',\
drawtext=fontfile='${FONT}':text='Cook two more nights':fontcolor=0x5FD08A:fontsize=54:x=(w-text_w)/2:y=h*0.42:alpha='if(lt(t,0.6),0,min((t-0.6)/0.3,1))',\
drawtext=fontfile='${FONT}':text='Train four times a week':fontcolor=0x5FD08A:fontsize=54:x=(w-text_w)/2:y=h*0.54:alpha='if(lt(t,1.1),0,min((t-1.1)/0.3,1))',\
drawtext=fontfile='${FONT}':text='Cut the sodium':fontcolor=0x5FD08A:fontsize=54:x=(w-text_w)/2:y=h*0.66:alpha='if(lt(t,1.6),0,min((t-1.6)/0.3,1))',\
format=yuv420p[v]" -map "[v]" -t 3.2 "$W/s5.mp4" -loglevel error

echo "== s6 brand + CTA =="
"$FF" -y -f lavfi -i color=c=0x0C0D11:s=1080x1920:r=30 -loop 1 -i "$ICON" \
 -filter_complex "[1:v]scale=320:320,setsar=1[ic];[0:v][ic]overlay=(W-w)/2:H/2-470[bg];\
[bg]drawtext=fontfile='${FONT}':text='LifeMaxxing':fontcolor=white:fontsize=84:x=(w-text_w)/2:y=H/2-110,\
drawtext=fontfile='${FONT}':text='Your life, optimized':fontcolor=0x99A0AE:fontsize=40:x=(w-text_w)/2:y=H/2+10,\
drawbox=x=220:y=1080:w=640:h=140:color=0x5FD08A@1:t=fill,\
drawtext=fontfile='${FONT}':text='DOWNLOAD NOW':fontcolor=0x0C0D11:fontsize=58:x=(w-text_w)/2:y=1115,\
fade=t=in:st=0:d=0.3,format=yuv420p[v]" -map "[v]" -frames:v 99 "$W/s6.mp4" -loglevel error

echo "== concat =="
L="$W/list_v4.txt"; : > "$L"
for s in s1 s2 s3 s4 s5 s6; do echo "file '$s.mp4'" >> "$L"; done
"$FF" -y -f concat -safe 0 -i "$L" -c copy "$OUT/v4_silent.mp4" -loglevel error || \
  "$FF" -y -f concat -safe 0 -i "$L" -c:v libx264 -pix_fmt yuv420p -crf 18 "$OUT/v4_silent.mp4" -loglevel error
echo "DONE -> $OUT/v4_silent.mp4"
