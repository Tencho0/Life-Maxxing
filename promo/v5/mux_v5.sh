#!/usr/bin/env bash
# Mux video #5: 13 VO phrases at their cues + music bed under -> loudnorm.
# Cue delays (ms) = each beat's start time + 150ms, from the retimed render_v5.sh beats.
set -e
cd "$(dirname "$0")/../.."
FF="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffmpeg.exe"
FP="promo/tools/ffmpeg-8.1.1-essentials_build/bin/ffprobe.exe"
VID="promo/v5/out/v5_silent.mp4"; OUT="promo/v5/out/v5_final.mp4"
MUSIC="promo/v2/work/music_v2.wav"
DUR=$("$FP" -v error -show_entries format=duration -of csv=p=0 "$VID")
FADEOUT=$(awk "BEGIN{print $DUR-0.8}")
delays=(150 5150 9950 12950 17250 20450 23250 26050 29050 32050 35050 38050 44550)
n=${#delays[@]}
ins=""; fc=""; mixin=""
for i in $(seq 1 $n); do idx=$(printf "%02d" $i); ins="$ins -i promo/v5/vo/p$idx.mp3";
  d=${delays[$((i-1))]}; fc="$fc[$i:a]adelay=$d:all=1[a$i];"; mixin="$mixin[a$i]"; done
M=$((n+1))
# music: input index $M; loop it (-stream_loop) so the ~20s bed covers the full video.
"$FF" -y -i "$VID" $ins -stream_loop 4 -i "$MUSIC" \
 -filter_complex "${fc}${mixin}amix=inputs=$n:normalize=0:dropout_transition=0:duration=longest[vo];\
[${M}:a]atrim=0:${DUR},volume=0.24,afade=t=in:st=0:d=0.5,afade=t=out:st=${FADEOUT}:d=0.7[mus];\
[vo][mus]amix=inputs=2:normalize=0:duration=first[mix];[mix]loudnorm=I=-16:TP=-1.5:LRA=11[ao]" \
 -map 0:v -map "[ao]" -c:v copy -c:a aac -b:a 192k "$OUT" -loglevel error
echo "DONE -> $OUT"
