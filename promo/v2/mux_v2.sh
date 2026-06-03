#!/usr/bin/env bash
# Mux beat-synced VO + music bed onto the silent v2 cut.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
VID="promo/v2/out/v2_silent.mp4"
OUT="promo/v2/out/v2_final.mp4"
VO=promo/v2/vo
# VO cue starts (ms): p01..p08
delays=(300 3200 5000 7000 10600 13600 16900 18400)
ins=""; fc=""; mixin=""
for i in $(seq 1 8); do idx=$(printf "%02d" $i); ins="$ins -i $VO/p$idx.mp3"; d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
# music is input index 9
"$FF" -y -i "$VID" $ins -i promo/v2/work/music_v2.wav \
  -filter_complex "${fc}${mixin}amix=inputs=8:normalize=0:dropout_transition=0:duration=longest[vo];\
[9:a]volume=0.28,afade=t=in:st=0:d=0.4,afade=t=out:st=19.0:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
  -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
