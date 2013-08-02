#!/bin/bash
set -eu

cd $(dirname $0)
exec >_out.log 2>_err.log
echo "start at $(date)"
set -x
touch _tmp.xpm

for ip2 in 16 17 18; do
  ./main.sh "172.$ip2" "{0..255}.254"
done

for ip3 in 0 1 2; do
  ./main.sh "192.168.$ip3" "{1..254}"
done

rm -f _tmp.xpm
echo "end at $(date)"
