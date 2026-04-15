#!/bin/bash
set -euo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 DEST_DIR" >&2
  exit 1
fi

dest_dir="$1"

touch -t 202404140900 "$dest_dir/window_open.marker"
touch -t 202404140915 "$dest_dir/window_close.marker"
touch -t 202404140830 "$dest_dir/evidence/alpha.txt"
touch -t 202404140845 "$dest_dir/evidence/bravo.txt"
touch -t 202404140910 "$dest_dir/evidence/charlie.txt"
touch -t 202404140930 "$dest_dir/evidence/delta.txt"
