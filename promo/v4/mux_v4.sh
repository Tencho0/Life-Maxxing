#!/usr/bin/env bash
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
VID="promo/v4/out/v4_silent.mp4"; OUT="promo/v4/out/v4_final.mp4"
MUSIC="promo/v2/work/music_v2.wav"
delays=(150 2450 4650 7550 10000 16500 19750)
ins=""; fc=""; mixin=""; n=7
for i in $(seq 1 $n); do idx=$(printf "%02d" $i); ins="$ins -i promo/v4/vo/p$idx.mp3"; d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
M=$((n+1))
"$FF" -y -i "$VID" $ins -i "$MUSIC" \
 -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${M}:a]volume=0.26,afade=t=in:st=0:d=0.4,afade=t=out:st=22.1:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
 -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
