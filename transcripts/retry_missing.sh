#!/usr/bin/env bash
# Retry downloading transcripts that failed due to rate limiting (429).
# Run this script after waiting a while (e.g. an hour) for YouTube rate limits to reset.
#
# Missing due to rate limiting:
#   12 - Tutorial 6: Fields (C4jJe_b0KMs)
#   14 - Lecture 8: Parallel Transport & Curvature (2eVWUdcI2ho)
#   16 - Lecture 10: Metric Manifolds (ONCZNwKswn4)
#   19 - Lecture 12: Integration on manifolds (2XpnbvPy-Zg)
#   20 - Tutorial 12: Integration (iwbJvfFNRh8)
#   22 - Lecture 14: Matter (65Y38aRWIXs)
#
# Missing because no English subtitles found (may have German auto-generated):
#   26 - Lecture 18: Canonical Formulation of GR I (sOiifkFYck4)
#   27 - Lecture 19: Canonical Formulation of GR II (GSxuLzmHyyU)
#   28 - Lecture 20: Cosmology - The early epoch (xzzSlx4tdOw)
#   33 - Lecture 23: Penrose Diagrams (nAT1PDkufso)
#   35 - Lecture 24: Perturbation Theory I (H_1ZBlwVsXo)
#   36 - Lecture 25: Perturbation Theory II (q9qWR9xUMts)

set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== Retrying rate-limited downloads ==="
RATE_LIMITED_IDS=(C4jJe_b0KMs 2eVWUdcI2ho ONCZNwKswn4 2XpnbvPy-Zg iwbJvfFNRh8 65Y38aRWIXs)

for vid in "${RATE_LIMITED_IDS[@]}"; do
    echo "Downloading $vid..."
    uvx yt-dlp --write-subs --write-auto-subs --sub-langs "en" --sub-format "json3" \
        --skip-download \
        --output "$SCRIPT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
        "https://www.youtube.com/watch?v=$vid" 2>&1 || true
    echo "Sleeping 30s..."
    sleep 30
done

echo ""
echo "=== Trying German auto-generated (translated to English) for videos with no English subs ==="
NO_EN_IDS=(sOiifkFYck4 GSxuLzmHyyU xzzSlx4tdOw nAT1PDkufso H_1ZBlwVsXo q9qWR9xUMts)

for vid in "${NO_EN_IDS[@]}"; do
    echo "Downloading $vid (trying all languages)..."
    uvx yt-dlp --write-subs --write-auto-subs --sub-langs "en,de" --sub-format "json3" \
        --skip-download \
        --output "$SCRIPT_DIR/%(playlist_index)s - %(title)s.%(ext)s" \
        "https://www.youtube.com/watch?v=$vid" 2>&1 || true
    echo "Sleeping 30s..."
    sleep 30
done

echo ""
echo "=== Converting any new json3 files to text ==="
python3 - "$SCRIPT_DIR" << 'PYEOF'
import json, sys, os, glob

transcript_dir = sys.argv[1]
for json_file in sorted(glob.glob(os.path.join(transcript_dir, "*.json3"))):
    basename = os.path.basename(json_file).replace(".en.json3", "").replace(".de.json3", "")
    out_file = os.path.join(transcript_dir, basename + ".txt")
    if os.path.exists(out_file):
        continue
    with open(json_file, 'r') as f:
        data = json.load(f)
    events = data.get("events", [])
    lines = []
    for event in events:
        if "segs" not in event:
            continue
        start_ms = event.get("tStartMs", 0)
        total_secs = start_ms / 1000
        hours = int(total_secs // 3600)
        mins = int((total_secs % 3600) // 60)
        secs = int(total_secs % 60)
        text = "".join(seg.get("utf8", "") for seg in event["segs"]).strip()
        if not text or text == "\n":
            continue
        if hours > 0:
            timestamp = f"[{hours:d}:{mins:02d}:{secs:02d}]"
        else:
            timestamp = f"[{mins:02d}:{secs:02d}]"
        lines.append(f"{timestamp} {text}")
    with open(out_file, 'w') as f:
        f.write("\n".join(lines) + "\n")
    print(f"Converted: {basename} ({len(lines)} lines)")
PYEOF

echo "Done!"
