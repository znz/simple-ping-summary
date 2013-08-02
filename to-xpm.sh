#!/bin/bash
set -eu
to_xpm () {
  OUT_DIR="$1"
  WIDTH=0
  HEIGHT=0
  for f in "$OUT_DIR"/*.out; do
    HEIGHT=$[$HEIGHT + 1]
  done
  WIDTH="$(wc -l < "$f")"
  cat <<EOF
static const char* const xpm[] = {
    "$WIDTH $HEIGHT 3 1",
    "  c None",
    "A c #00FF00",
    "U c #FF0000",
EOF
  for f in "$OUT_DIR"/*.out; do
    echo -n '    "'
    sort -V $f | awk -v ORS= '/alive/{print "A"}/unreachable/{print "U"}'
    echo '",'
  done
  echo '};'
}
if [ -z "$1" ]; then
  echo "usage: $0 out_dir"
  exit 1
fi
to_xpm "$1"
