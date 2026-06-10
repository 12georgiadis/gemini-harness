#!/usr/bin/env bash
# gemini-pilot.sh — Allows Claude to pilot Gemini CLI via a drop folder

DROP_DIR="$HOME/.gemini/tasks"
mkdir -p "$DROP_DIR"
PROCESSED_DIR="$DROP_DIR/processed"
mkdir -p "$PROCESSED_DIR"

echo "Gemini Pilot is listening in $DROP_DIR..."

while true; do
    for f in "$DROP_DIR"/*.md; do
        if [ -e "$f" ]; then
            echo "New task: $f"
            cmd=$(cat "$f")
            ~/.gemini/gemini-bridge.sh "$cmd"
            timestamp=$(date +%Y%m%d_%H%M%S)
            mv "$f" "$PROCESSED_DIR/${timestamp}_$(basename "$f")"
        fi
    done
    sleep 2
done
