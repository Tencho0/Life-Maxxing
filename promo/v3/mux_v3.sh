#!/usr/bin/env bash
# Mux VO (synced to captions) + music bed onto the silent v3 cut.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
VID="promo/v3/out/v3_silent.mp4"; OUT="promo/v3/out/v3_final.mp4"
MUSIC="promo/v2/work/music_v2.wav"
# VO files (p06 omitted) and their cue starts (ms)
files=(p01 p02 p03 p04 p05 p07); delays=(150 3600 5800 8600 11100 14000)
ins=""; fc=""; mixin=""; n=${#files[@]}
for i in $(seq 0 $((n-1))); do
  k=$((i+1)); ins="$ins -i promo/v3/vo/${files[$i]}.mp3"; d=${delays[$i]}
  fc="$fc[$k:a]adelay=$d:all=1[a$k];"; mixin="$mixin[a$k]"
done
MIDX=$((n+1))
"$FF" -y -i "$VID" $ins -i "$MUSIC" \
  -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${MIDX}:a]volume=0.28,afade=t=in:st=0:d=0.4,afade=t=out:st=15.4:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
  -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
