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
# beat starts (0 / 3.4 / 5.4 / 8.8 / 11.3 / 15.6) + 150 ms
delays=(150 3550 5550 8950 11450 15750)
n=${#delays[@]}
ins=""; fc=""; mixin=""
for i in $(seq 1 $n); do idx=$(printf "%02d" $i); ins="$ins -i promo/v6/vo/p$idx.mp3";
  d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
M=$((n+1))
"$FF" -y -i "$VID" $ins -i "$MUSIC" \
 -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${M}:a]atrim=0:${DUR},volume=0.26,afade=t=in:st=0:d=0.5,afade=t=out:st=${FADEOUT}:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
 -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k -ar 48000 "$OUT" -loglevel error
echo "DONE -> $OUT"
