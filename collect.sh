#!/bin/bash
set -u
# do not use 'set -e' because fping return 1 with unreachable hosts
collect () {
  IP_PREFIX=$1
  IP_RANGE=${2:-"{1..254}"}
  OUT_FILE="data/$IP_PREFIX/$(date '+%Y%m%d/%H%M%S').out"
  trap "rm -f $OUT_FILE" 1 2 3 15
  mkdir -p "$(dirname "$OUT_FILE")"
  {
    eval set -- $IP_PREFIX.$IP_RANGE
    for ip; do
      echo "$ip"
     done
  } | /usr/local/sbin/fping -r 0 >"$OUT_FILE"
  trap "" 1 2 3 15
}
if [ -z "$1" ]; then
  echo "usage: $0 192.168.y [{1..254}]"
  exit 1
fi
collect "$1" "$2"
