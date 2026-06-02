#!/usr/bin/env bash
# Places each neural-VO phrase at its beat cue, mixes, normalizes loudness,
# and muxes onto the silent cut -> the final voiced promo.
set -e
cd "$(dirname "$0")/.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
VID="promo/out/lifemaxxing_promo_v1_silent.mp4"
OUT="promo/out/lifemaxxing_promo_v1_VO.mp4"

# Cue start (ms) for p01..p11, aligned to the visual beats.
delays=(0 2000 3000 4000 5000 6000 7000 8000 9050 12000 13650)

ins=""; fc=""; mixin=""
for i in $(seq 1 11); do
  idx=$(printf "%02d" "$i")
  ins="$ins -i promo/vo/p$idx.mp3"
  d=${delays[$((i-1))]}
  fc="$fc[$i:a]adelay=$d:all=1[a$i];"
  mixin="$mixin[a$i]"
done

"$FF" -y -i "$VID" $ins \
  -filter_complex "${fc}${mixin}amix=inputs=11:normalize=0:dropout_transition=0:duration=longest[mix];[mix]loudnorm=I=-15:TP=-1.5:LRA=11[vo]" \
  -map 0:v -map "[vo]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
