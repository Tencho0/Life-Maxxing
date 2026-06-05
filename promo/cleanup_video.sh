#!/usr/bin/env bash
# Finalize a promo video once the cut is done & perfect.
#
# Deletes the video's build scratch (raw B-roll, candidate footage, per-beat segments,
# frame sequences, generated music, contact sheets, grade tests) and any non-final cuts,
# keeping ONLY:
#   - the final  *_final.mp4  (gitignored, kept on disk for re-upload)
#   - the committed recipe: render/mux/make_* scripts, vo_lines.txt, sources.txt, copy.txt,
#     the VO mp3s, and any committed source screenshot (e.g. work/mood.png)
# `git clean` never removes tracked files, so committed sources survive automatically.
#
# The shared screenshot library (promo/work) and the ffmpeg toolchain (promo/tools) are
# NEVER touched here — they are cross-video sources/infra, not one video's scratch.
#
# Usage:  bash promo/cleanup_video.sh <video-number>     e.g.  cleanup_video.sh 6
set -e
cd "$(dirname "$0")/.."                       # repo root
N="$1"; [ -z "$N" ] && { echo "usage: cleanup_video.sh <video-number>"; exit 1; }
[ "$N" = "1" ] && { echo "refusing: video #1 shares promo/work (shared library) — clean its scratch by hand."; exit 1; }
BASE="promo/v$N"
[ -d "$BASE" ] || { echo "no such video dir: $BASE"; exit 1; }

before=$(du -sh "$BASE" 2>/dev/null | awk '{print $1}')

# 1) out/: keep only *_final.mp4 — drop silent/VO/intermediate cuts.
[ -d "$BASE/out" ] && find "$BASE/out" -maxdepth 1 -type f -name '*.mp4' ! -name '*_final.mp4' -delete

# 2) scratch dirs: wipe regenerable intermediates. Tracked files (committed sources) are kept.
for sub in work broll logos seq seq_log seq_charts morning rec cand dots; do
  [ -d "$BASE/$sub" ] && git clean -fdx "$BASE/$sub" >/dev/null 2>&1 || true
done

after=$(du -sh "$BASE" 2>/dev/null | awk '{print $1}')
echo "finalized $BASE  ($before -> $after)"
echo "  kept: $(ls "$BASE"/out/*_final.mp4 2>/dev/null | xargs -n1 basename 2>/dev/null | tr '\n' ' ')+ committed recipe"
