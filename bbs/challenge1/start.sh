#!/usr/bin/exec-suid -- /bin/bash
set -euo pipefail

cd /challenge
exec /challenge/run.sh "$@"
