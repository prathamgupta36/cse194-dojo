#!/opt/pwn.college/bash
set -euo pipefail

if [[ "$#" -ne 1 ]]; then
  echo "Usage: $0 DEST_DIR" >&2
  exit 1
fi

dest_dir="$1"

rm -f "$dest_dir/archive/ledger.txt" "$dest_dir/cache/receipt.txt" "$dest_dir/rooms/east/pamphlet.txt"
ln "$dest_dir/.master_copy" "$dest_dir/archive/ledger.txt"
ln "$dest_dir/.master_copy" "$dest_dir/cache/receipt.txt"
ln "$dest_dir/.master_copy" "$dest_dir/rooms/east/pamphlet.txt"

printf '%s\n' 'just a normal file' > "$dest_dir/rooms/west/decoy.txt"
