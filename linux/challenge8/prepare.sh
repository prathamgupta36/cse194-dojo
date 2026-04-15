#!/bin/bash
set -euo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 DEST_DIR" >&2
  exit 1
fi

dest_dir="$1"

chmod 000 "$dest_dir/mirage/amber/note.txt" "$dest_dir/mirage/onyx/note.txt" "$dest_dir/mirage/glass/note.txt"
chmod 644 "$dest_dir/mirage/velvet/clue.txt"
