#!/usr/bin/env bash
set -euo pipefail

sysop_secret() {
  printf '%s' 'RkxBR3tET09SR0FNRV9FU0NBUEV9' | base64 -d
}

echo "===================================="
echo "        Galactic Trade Door         "
echo "===================================="
echo ""
read -r -p "Pilot handle: " handle

# Vulnerable pattern: user input becomes part of an eval string.
line="echo [Door] Welcome back, ${handle}"
eval "$line"

echo "[Door] Cargo bay status: nominal"
echo "[Door] Rank: Copper Trader"
