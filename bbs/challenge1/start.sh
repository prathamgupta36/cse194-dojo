#!/opt/pwn.college/bash
set -euo pipefail

cd /challenge
exec /challenge/run.sh "$@"
